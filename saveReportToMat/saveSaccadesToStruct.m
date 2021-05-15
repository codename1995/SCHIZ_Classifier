function [saccades] = saveSaccadesToStruct(EyeDataPath, SubjectID, cellImgNamesJPG)

% =====Part1£ºsaccades{}.img===== %
for pic = 1:100
    newPicName = pic + 1000;
    saccades{pic}.img = [num2str(newPicName),'.jpg'];
    saccades{pic}.img_oldname = char(cellImgNamesJPG(pic));
end
% saccades = saccades';

% =====Part2£ºload report and save data into structure===== %
FileName = 'SaccadeReport.xlsx';
for i = 1:length(SubjectID) 
    SaccadeReportPath = fullfile(EyeDataPath, char(SubjectID(i)), FileName);

    % Part2.2:load report and create Secondary Index where store the
    % indexs of both the first row and last row of an image
    [saccade_num,saccade_cell] = getSaccadeData(SaccadeReportPath);
    secondary_index = creatSecondaryIndex(saccade_num(:,1),saccade_cell,cellImgNamesJPG);
    
    % Part2.3: save the data into the structure "saccades"
    for pic = 1:100
        vect = secondary_index(pic,1):1:secondary_index(pic,2);
        if(vect(1) == 0)
            saccades{pic}.subject{i}.Angle = [];
            saccades{pic}.subject{i}.AvgVelocity = [];
            saccades{pic}.subject{i}.PeakVelocity = [];
            saccades{pic}.subject{i}.Duration =[];
            saccades{pic}.subject{i}.StartX = [];
            saccades{pic}.subject{i}.StartY = [];
            saccades{pic}.subject{i}.StartXResolution = [];
            saccades{pic}.subject{i}.StartYResolution = [];
            saccades{pic}.subject{i}.EndX = [];
            saccades{pic}.subject{i}.EndY = [];
            saccades{pic}.subject{i}.EndXResolution = [];
            saccades{pic}.subject{i}.EndYResolution = [];
            saccades{pic}.subject{i}.Class = [];
            saccades{pic}.subject{i}.BlinkRound = [];
            saccades{pic}.subject{i}.Amplitude =[];
            saccades{pic}.subject{i}.TRIAL_START_TIME =[];
            saccades{pic}.subject{i}.CURRENT_SAC_START_TIME =[];
            saccades{pic}.subject{i}.CURRENT_SAC_END_TIME =[];
        else
            no_saccade = length(vect);
            saccades{pic}.subject{i}.Angle = saccade_num(vect,2);
            saccades{pic}.subject{i}.AvgVelocity = saccade_num(vect,3);
            saccades{pic}.subject{i}.PeakVelocity = saccade_num(vect,4);
            saccades{pic}.subject{i}.Duration = saccade_num(vect,5);
            saccades{pic}.subject{i}.StartX = saccade_num(vect,6);
            saccades{pic}.subject{i}.StartY = saccade_num(vect,7);
            saccades{pic}.subject{i}.StartXResolution = saccade_num(vect,8);
            saccades{pic}.subject{i}.StartYResolution = saccade_num(vect,9);
            saccades{pic}.subject{i}.EndX = saccade_num(vect,10);
            saccades{pic}.subject{i}.EndY = saccade_num(vect,11);
            saccades{pic}.subject{i}.EndXResolution = saccade_num(vect,12);
            saccades{pic}.subject{i}.EndYResolution = saccade_num(vect,13);
            saccades{pic}.subject{i}.Class = saccade_num(vect,14);
            saccades{pic}.subject{i}.BlinkRound = saccade_num(vect,15);
            saccades{pic}.subject{i}.Amplitude = saccade_num(vect,16);
            saccades{pic}.subject{i}.TRIAL_START_TIME = saccade_num(vect,17);
            saccades{pic}.subject{i}.CURRENT_SAC_START_TIME = saccade_num(vect,18);
            saccades{pic}.subject{i}.CURRENT_SAC_END_TIME = saccade_num(vect,19);
        end
    end
    fprintf('%d\n',i);
end


load handel;
sound(y,Fs);