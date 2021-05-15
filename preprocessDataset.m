% This file convert the Original Dataset to .mat files for easily loading

% set the path of Original Dataset
DataPath = '.\OrignialVersion\';

% add the path of preprocess functions
addpath('.\saveReportToMat\');

% create output folder
OutputPath = '.\ProcessedDataset\';
if ~exist(OutputPath, 'dir')     
    mkdir(OutputPath);
end

%========== 1. Get images information
tic;
fprintf('1. Get images information\n');
[~,~,cellImgNamesJPG] = xlsread(fullfile(OutputPath, 'ImgNamesJPG.xlsx'));
toc;

%========== 2. Get eye-tracking data from the three report
SubjectID = genSubjectID();
EyeDataPath = fullfile(DataPath, 'EyeTrackingData');

tic;
fprintf('get BlinkCount, Duration, SampleCount from Trial Report.\n');
% cd ..
BC_Dura_SC = saveTrialReportToStruct(EyeDataPath, SubjectID, cellImgNamesJPG); %BlinkCount, Duration, SampleCount
% cd SCHIZ_Classifer
save(fullfile(OutputPath, 'ThreeColsInTrialReport.mat'),'BC_Dura_SC');
toc;

tic;
fprintf('saveFixationsToStruct\n');
% cd ..
fixations = saveFixationsToStruct(EyeDataPath, SubjectID, cellImgNamesJPG); 
% cd SCHIZ_Classifer
save(fullfile(OutputPath, 'fixations.mat'),'fixations');
toc;

tic;
fprintf('saveSaccadesToStruct\n');
% cd ..
saccades = saveSaccadesToStruct(EyeDataPath, SubjectID, cellImgNamesJPG); 
% cd SCHIZ_Classifer
save(fullfile(OutputPath, 'saccades.mat'), 'saccades');
toc;