
addpath .\generateFeatureData;

% 1. Initialize the TotalTable
TotalTable = zeros(7000, 32);
for i = 1:70
    start_row = 100*i-99;
    end_row = 100*i;
    TotalTable(start_row:end_row, 1) = i;           % COL 1 : The index of subject
    TotalTable(start_row:end_row, 2) = (1:100)';    % COL 2 : The index of stimuli image
    TotalTable(start_row:end_row, 3) = (i>30);      % COL 3 : '1' indicates the subject is a patient
end


% 2. Calculate fixation-based data 
load('ProcessedDataset/fixations.mat', 'fixations');

% load ROI map
load('ProcessedDataset/ROImap_47.mat', 'ROImap_47');
fixations = addROILabel(fixations, ROImap_47);

% The selction criteria of fixations
FixationsSelectionCriteria.InROI = false;         % Only reserve fixations in ROI
FixationsSelectionCriteria.RemoveFirstFixation = false;
FixationsSelectionCriteria.RemoveFixationWithBlink = false;
FixationsSelectionCriteria.RemoveFixationOutOfScreen = true; 
FixationsSelectionCriteria.RemovePreStimuliFixations = true; 

rowsToDelete_Fix = [];
for pic = 1:100
    for k = 1:70
        fix_origin = fixations{pic}.subject{k};
        nIndex = (k-1)*100 + pic;
        if(~isempty(fix_origin)) 
            fixSelected = selectFix(fix_origin, FixationsSelectionCriteria);
            fix = fixSelected;
            TotalTable(nIndex,25) = sum(OutOfBoundary(fix, 800, 600));
            if(~isempty(fix.fix_x))
                [fix,~] = calcFixFeature(fix);
                TotalTable(nIndex,4) = fix.avg_fix_duration;
                TotalTable(nIndex,6) = fix.avg_fix_x_resolution;
                TotalTable(nIndex,7) = fix.avg_fix_y_resolution;
                % The COL 9 temporarily save the number of
                % valid_fix_duration, and will be updated while processing
                % saccades.
                TotalTable(nIndex,9) = fix.valid_fix_duration;
                TotalTable(nIndex,10) = fix.fix_count;
                TotalTable(nIndex,11) = fix.max_fix_duration;
                TotalTable(nIndex,12) = fix.min_fix_duration;
                TotalTable(nIndex,13) = fix.max_pupil_size;
                TotalTable(nIndex,14) = fix.max_pupil_size_x;
                TotalTable(nIndex,15) = fix.max_pupil_size_y;
                TotalTable(nIndex,16) = fix.avg_pupil_size;
                TotalTable(nIndex,19) = fix.valid_fix_duration;
                TotalTable(nIndex,20) = fix.min_pupil_size;
                TotalTable(nIndex,24) = fix.fix_skewness;
            else
                rowsToDelete_Fix = [rowsToDelete_Fix nIndex];
            end
        else
            rowsToDelete_Fix = [rowsToDelete_Fix nIndex];
        end
    end
end


% 3. Calculate saccade-based data 
load('ProcessedDataset\saccades.mat','saccades');

SaccadesSelectionCriteria.RemovePreStimuliSaccades = true;

rowsToDelete_Sac = [];
for pic = 1:100
    for k = 1:70
        sac_origin = saccades{pic}.subject{k};
        nIndex = (k-1)*100 + pic;
        if(~isempty(sac_origin.Amplitude)) 
            sacSelected = selectSac(sac_origin,RulesOfSacSelection);
            sac = sacSelected;
            if(~isempty(sac.Amplitude))
                TotalTable(nIndex,5) = mean(sac.Amplitude,'omitnan');% Average saccade amplitude
                
                % Valid viewing duration = fixation duration + saccade duration
                TotalTable(nIndex,9) = TotalTable(nIndex,6+3)+sum(sac.Duration,'omitnan');
                
                TotalTable(nIndex,17) = length(sac.Amplitude); % Saccade count
                
               
                dVTime = (sac.Duration)./1000; % Duration is divided by 1000 because the unit changes from ms to s
                dVAvgV = sac.AvgVelocity;
                dVPath = dVTime.*dVAvgV;
                
                tempV = ~isnan(dVPath);
                dScanPath = sum(dVPath(tempV));
                dAvgSpeed = dScanPath./sum(dVTime(tempV));
                TotalTable(nIndex,18+3) = dAvgSpeed;
                TotalTable(nIndex,23) = dScanPath; % Total saccade amplitude, unit: бу
            else
                rowsToDelete_Sac = [rowsToDelete_Sac nIndex];
            end
        else
            rowsToDelete_Sac = [rowsToDelete_Sac nIndex];
        end
    end
end


% 4. Load data from trial report
load('ProcessedDataset\ThreeColsInTrialReport.mat','BC_Dura_SC');
TotalTable(:,8) = BC_Dura_SC(:,1); % BlinkCount
TotalTable(:,26) = BC_Dura_SC(:,2); % Duration
TotalTable(:,27) = BC_Dura_SC(:,3); % SampleCount 


