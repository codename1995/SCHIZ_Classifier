
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
        if(~isempty(fix_origin.fix_x)) 
            fixSelected = selectFix(fix_origin, FixationsSelectionCriteria);
            fix = fixSelected;
%             fprintf('%d %d\n',pic,k);
            TotalTable(nIndex,25) = fix.Cnt_Fix_Out_Screen;
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
            sacSelected = selectSac(sac_origin,SaccadesSelectionCriteria);
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


% 5. Calculate metric-related data (ML-Net,SAM-VGG)
load('MetricRelatedFeatures\FD_metric201912.mat','FD_metric','FD_metric_name');
% Some code of experiment but not used in final version
metric_resnet = FD_metric(:,13:18);
metric_resnet_name = FD_metric_name(13:18);
FD_metric(:,13:18) = [];
FD_metric_name(:,13:18) = [];
cell_model_name = {'FES','GBVS','Itti_Koch','LDS','ResNet'};
for i = 1:length(cell_model_name)
    if i==5
        FD_metric = [FD_metric, metric_resnet];
        FD_metric_name = [FD_metric_name, metric_resnet_name];
        continue;
    end        
    model_name = char(cell_model_name(i));
    filename = ['.\MetricRelatedFeatures\', model_name,...
        '_metric.mat'];
    matname = [model_name,'_metric'];
    metric_name_name = [model_name,'_metric_name'];
    structdata = load(filename,matname,metric_name_name);
    FD_metric = [FD_metric, structdata.(matname)];
    FD_metric_name = [FD_metric_name, structdata.(metric_name_name)];
end
% FD_metric = FD_metric(:,[1,7,13,4,10,16]);
% FD_metric_name = FD_metric_name(:,[1,7,13,4,10,16]);
N_fea = size(TotalTable,2);
TotalTable(:,28:28+size(FD_metric,2)-1) = FD_metric;


% 6.1 Delete samples (=rows) without fix or sac

% Combine `rowsToDelete_Fix` and `rowsToDelete_Sac`
rowsToDelete = [rowsToDelete_Fix rowsToDelete_Sac]';
rowsToDelete = unique(rowsToDelete); % remove duplicate
rowsToDelete = sortrows(rowsToDelete,-1); % Descending sort
for row = rowsToDelete
    TotalTable(row,:) = [];
end

% 6.2 Calculated Pupil Size Ratio and Dynamic Range of Pupil Size
TotalTable(:,18) = TotalTable(:,13)./TotalTable(:,16); % Pupil Size Ratio = MAX/MEAN
TotalTable(:,22) = (TotalTable(:,13)-TotalTable(:,20))./TotalTable(:,16); % Dynamic Range of Pupil Size

% 6.3 Delete rows including NAN
[m,n] = size(TotalTable);
rowsnan = [];
for row = m:-1:1
    for col = 4:1:n
        temp = TotalTable(row,col);
        if isnan(temp)
            fprintf('Not a Number! row:%d col:%d\n',row,col);
            TotalTable(row,:) = [];
            rowsnan = [rowsnan;row]; 
            break;
        end
    end
end
rowsnan = unique(rowsnan);

% 7. Add features' properties
FeatureName = InputName(FD_metric_name);
FeatureData = TotalTable;
FeatureInfo = calcSampleInfo(FeatureData);
info.generatedFile = 'generateFeatureData201912.m';
save('Data\FeatureData201912.mat','FeatureData','FeatureName','FeatureInfo','info');
toc;


function FeatureName = InputName(FD_metric_name)
FeatureName(1,1) = {'SubjectNo.'};
FeatureName(1,2) = {'ImageNo.'};
FeatureName(1,3) = {'Label'};
FeatureName(1,4) = {'Avg Fix Duration'};
FeatureName(1,5) = {'Avg Sac Duration'};
FeatureName(1,6) = {'Avg X Resolution'};
FeatureName(1,7) = {'Avg Y Resolution'};
FeatureName(1,8) = {'Blink Count'};
FeatureName(1,9) = {'Valid Viewing Duration'};
FeatureName(1,10) = {'Fix Count'};
FeatureName(1,11) = {'Max Fix Duration'};
FeatureName(1,12) = {'Min Fix Duration'};
FeatureName(1,13) = {'Max Pupil Size'};
FeatureName(1,14) = {'X to Max Pupil Size'}; % The x-coordination of the fix with max pupil size
FeatureName(1,15) = {'Y to Max Pupil Size'};
FeatureName(1,16) = {'Avg Pupil Size'};
FeatureName(1,17) = {'Sac Count'};
FeatureName(1,18) = {'Pupil Size Ratio'};
FeatureName(1,19) = {'Fix Duration'};
FeatureName(1,20) = {'Min Pupil Size'};
FeatureName(1,21) = {'Avg Sac Velocity'};
FeatureName(1,22) = {'Dynamic Range of Pupil Size'};
FeatureName(1,23) = {'Saccadic Amplitude'};
FeatureName(1,24) = {'Fix Skewness'};
FeatureName(1,25) = {'Outside Fixation Count'};

% Dec 2018: Some date from Trial Report.
FeatureName(1,26) = {'(TrialReport)Duration'};
FeatureName(1,27) = {'(TrialReport)SampleCount'};

% Model-metric based features
FeatureName(1,28:28+length(FD_metric_name)-1) = FD_metric_name;
end

function SampleInfo=calcSampleInfo(FeatureData)

    % The number of samples
    SampleInfo.Nsamples = size(FeatureData,1);
    
    % The number of each subject's samples
    IdxTester = sortrows(unique(FeatureData(:,1)));
    Ntester = length(IdxTester);
    for i = 1:Ntester
        idx = IdxTester(i);
        SampleInfo.NTesterSamples{i} = sum(FeatureData(:,1)==idx);        
    end
    
    % The index of valid images for each subject
    IdxTester = sortrows(unique(FeatureData(:,1)));
    Ntester = length(IdxTester);
    for i = 1:Ntester
        idx = IdxTester(i);
        SampleInfo.TesterSampleNo(i) = {FeatureData((FeatureData(:,1)==idx),2)};        
    end
    
    % The index of invalid images for each subject
    IdxTester = sortrows(unique(FeatureData(:,1)));
    Ntester = length(IdxTester);
    for i = 1:Ntester
        idx = IdxTester(i);
        if SampleInfo.NTesterSamples{i}==SampleInfo.Nsamples
            continue;
        else
            IdxSamples = cell2mat(SampleInfo.TesterSampleNo(i));
            MissedSamples = [];
            N = max(cell2mat(SampleInfo.NTesterSamples));
            for j = 1:N
                if sum(j==IdxSamples)==0
                    MissedSamples = [MissedSamples,j];
                end
            end
            SampleInfo.NTesterMissedSamples(i) = {MissedSamples};
        end
    end
end