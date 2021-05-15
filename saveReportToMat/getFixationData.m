function [fixation_num,fixation_cell] = getFixationData(File)
%GETFIXATIONDATA Get the data of fixations from FILE. Cause the original
%data is too large, some data are throw away.



[NUM,~,RAW]=xlsread(File); %打开文件
[m,~]=size(NUM);
%numeric data
fixation_num = zeros(m,10);
%text fields in cell array
fixation_cell = cell(m,3);

NUM = [zeros(m,1), NUM, zeros(m,1)];    % Compared to RAW, NUM lose the first 
                                        % and last col. Therefore, we
                                        % replenish them back.
%找到要用的数据列在xls文件中的列号，例如No_CURRENT_FIX_X在xls文件中是第16列
No_CURRENT_FIX_INDEX            = RAW(1,:)== string('CURRENT_FIX_INDEX');
No_CURRENT_FIX_X                = RAW(1,:)== string('CURRENT_FIX_X');
No_CURRENT_FIX_Y                = RAW(1,:)== string('CURRENT_FIX_Y');
No_CURRENT_FIX_DURATION         = RAW(1,:)== string('CURRENT_FIX_DURATION');
No_TRIAL_FIXATION_TOTAL         = RAW(1,:)== string('TRIAL_FIXATION_TOTAL');
No_pic_3_3                      = RAW(1,:)== string('pic_3_3');%该注视点属于哪一个图片
No_CURRENT_FIX_BLINK_AROUND     = RAW(1,:)== string('CURRENT_FIX_BLINK_AROUND');%2/9新增该注视点前后是否有眨眼
No_CURRENT_FIX_PUPIL            = RAW(1,:)== string('CURRENT_FIX_PUPIL');%3/24新增该注视点瞳孔大小
No_CURRENT_FIX_X_RESOLUTION     = RAW(1,:)== string('CURRENT_FIX_X_RESOLUTION');%3/24新增该注视点X方向分辨率
No_CURRENT_FIX_Y_RESOLUTION     = RAW(1,:)== string('CURRENT_FIX_Y_RESOLUTION');%3/24新增该注视点Y方向分辨率
No_class                        = RAW(1,:)== string('class');%3/24新增该图片所属分组
No_PREVIOUS_SAC_END_TIME        = RAW(1,:)== string('PREVIOUS_SAC_END_TIME');


%存入返回的矩阵
fixation_num(:,1) = NUM(:,No_CURRENT_FIX_INDEX);
fixation_num(:,2) = NUM(:,No_CURRENT_FIX_X);
fixation_num(:,3) = NUM(:,No_CURRENT_FIX_Y);
fixation_num(:,4) = NUM(:,No_CURRENT_FIX_DURATION);
fixation_num(:,5) = NUM(:,No_TRIAL_FIXATION_TOTAL);%该列数据在creatSecondaryIndex中使用
%第六列赋值见后
fixation_num(:,7) = NUM(:,No_CURRENT_FIX_PUPIL);
fixation_num(:,8) = NUM(:,No_CURRENT_FIX_X_RESOLUTION);
fixation_num(:,9) = NUM(:,No_CURRENT_FIX_Y_RESOLUTION);
fixation_num(:,10) = NUM(:,No_class);
fixation_num(:,11) = NUM(:,No_PREVIOUS_SAC_END_TIME);
fixation_cell(:,1) = RAW(2:end,No_pic_3_3);
fixation_cell(:,2) = RAW(2:end,No_CURRENT_FIX_BLINK_AROUND);

% 2/9：以如下对应关系，在fixation_num第六列增添数据：0-错误信息，1-前后均无眨眼，2-before，3-after，4-both
nBlink = zeros(m,1);
for i = 1:m
    if(isequal(fixation_cell(i,2),{'NONE'}))
        nBlink(i) = 1;
    elseif(isequal(fixation_cell(i,2),{'BEFORE'}))
        nBlink(i) = 2;
    elseif(isequal(fixation_cell(i,2),{'AFTER'}))
        nBlink(i) = 3;
    elseif(isequal(fixation_cell(i,2),{'BOTH'}))
        nBlink(i) = 4;
    end
end
fixation_num(:,6) = nBlink;