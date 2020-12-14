function fixations = saveFixationsToStruct(EyeDataPath, SubjectID, cellImgNamesJPG)

% =====Part1£ºfixations{}.img===== %
for pic = 1:100
    newPicName = pic + 1000;
    fixations{pic}.img = [num2str(newPicName),'.jpg'];
    fixations{pic}.img_oldname = char(cellImgNamesJPG(pic));
end
% fixations = fixations';

% =====Part2£ºload report and save data into structure===== %
FileName = 'FixationReport.xlsx';
for i = 1:length(SubjectID) 
    FixationReportPath = fullfile(EyeDataPath, char(SubjectID(i)), FileName);

    % Part2.2: load report and create Secondary Index where store the
    % indexs of both the first row and last row of an image
    [fixation_num,fixation_cell] = getFixationData(FixationReportPath);
    [secondary_index] = creatSecondaryIndex(fixation_num(:,5),fixation_cell,cellImgNamesJPG);
    
    % Part2.3£ºsave the data into the structure "fixations"
    for pic = 1:100
        vect = secondary_index(pic,1):1:secondary_index(pic,2);
        if(vect(1) == 0)
            fixations{pic}.subject{i}.fix_x = [];
            fixations{pic}.subject{i}.fix_y = [];
            fixations{pic}.subject{i}.fix_duration = [];
            fixations{pic}.subject{i}.BlinkRound = [];
            fixations{pic}.subject{i}.PupilSize = [];
            fixations{pic}.subject{i}.X_Resolution = [];
            fixations{pic}.subject{i}.Y_Resolution = [];
            fixations{pic}.subject{i}.Class = [];
        else
            no_fixation = length(vect);
            fixations{pic}.subject{i}.fix_x = fixation_num(vect,2);
            fixations{pic}.subject{i}.fix_y = fixation_num(vect,3);
            fixations{pic}.subject{i}.fix_duration = fixation_num(vect,4);
            fixations{pic}.subject{i}.BlinkRound = fixation_num(vect,6);
            fixations{pic}.subject{i}.PupilSize = fixation_num(vect,7);
            fixations{pic}.subject{i}.X_Resolution = fixation_num(vect,8);
            fixations{pic}.subject{i}.Y_Resolution = fixation_num(vect,9);
            fixations{pic}.subject{i}.Class = fixation_num(vect,10);
        end
    end
    fprintf('%d\n',i);
end


load handel;
sound(y,Fs);