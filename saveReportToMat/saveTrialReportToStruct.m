function [ThreeCols] = saveTrialReportToStruct(EyeDataPath, SubjectID, cellImgNamesJPG)

cols = [50, 17, 6, 9, 46];  % The COL 50, 17, 6, 9, 46 are corresponding to
                            % Image_Name, Idx_of_Img_in_the_Trial,
                            % BlinkCount, Duration and SampleCount
                            % in the Trial Report
FileName = 'TrialReport.xlsx';

ThreeCols = NaN(7000, length(cols)-2);
for i = 1:length(SubjectID) 
    
    TrialReportPath = fullfile(EyeDataPath, char(SubjectID(i)), FileName);
    
    [~,~,RAW]=xlsread(TrialReportPath); 
    Data = RAW(2:end, cols);
    
    Data = fillEmptyDataWithNAN(Data, cellImgNamesJPG);
    
    idx_first_row = 100*(i-1) + 1;
    idx_last_row = 100*i;
    ThreeCols(idx_first_row:idx_last_row,1:3) = Data;
    fprintf('%d\n', i);
end

end

function ImportInfo = fillEmptyDataWithNAN(Info, cellImgNamesJPG)
    [m,n] = size(Info);
    Info = sortrows(Info,1); % sort rows via ascending order of image names
    ImportInfo = NaN(100, n-2); % the left two cols of Info are abandoned
    
    if m == 100
        ImportInfo = cell2mat(Info(:,3:5));
    else
        % If the record is incomplete, we use NAN to fullfill the empty rows.
        i = 1;
        j = 1;
        while i<=m
            if isequal(Info(i,1), cellImgNamesJPG(j))
                ImportInfo(j,:) = cell2mat(Info(i,3:end));
                i = i + 1;
            else
                ImportInfo(j,:) = NaN(1,n-2);
            end
            j = j + 1;
        end
    end
    
end