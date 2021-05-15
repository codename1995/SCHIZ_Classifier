function [saccade_num,saccade_cell] = getSaccadeData(File)
%GETSACCADEDATA Get the data of saccades from FILE. Cause the original
%data is too large, some data are throw away.



[NUM,~,RAW]=xlsread(File); %打开文件
[m,~]=size(NUM);
%numeric data
saccade_num = zeros(m,16);
%text fields in cell array
saccade_cell = cell(m,3);

NUM = [zeros(m,1), NUM];    % Compared to RAW, NUM lose the first col.
                            % Therefore, we replenish them back.
%找到要用的数据列在xls文件中的列号，例如No_CURRENT_FIX_X在xls文件中是第16列
No_TRIAL_SACCADE_TOTAL              = RAW(1,:)== string('TRIAL_SACCADE_TOTAL');
No_CURRENT_SAC_ANGLE                = RAW(1,:)== string('CURRENT_SAC_ANGLE');
No_CURRENT_SAC_AVG_VELOCITY         = RAW(1,:)== string('CURRENT_SAC_AVG_VELOCITY');
No_CURRENT_SAC_PEAK_VELOCITY        = RAW(1,:)== string('CURRENT_SAC_PEAK_VELOCITY');
No_CURRENT_SAC_DURATION             = RAW(1,:)== string('CURRENT_SAC_DURATION');
No_CURRENT_SAC_START_X              = RAW(1,:)== string('CURRENT_SAC_START_X');
No_CURRENT_SAC_START_X_RESOLUTION   = RAW(1,:)== string('CURRENT_SAC_START_X_RESOLUTION');
No_CURRENT_SAC_START_Y              = RAW(1,:)== string('CURRENT_SAC_START_Y');
No_CURRENT_SAC_START_Y_RESOLUTION   = RAW(1,:)== string('CURRENT_SAC_START_Y_RESOLUTION');
No_CURRENT_SAC_END_X                = RAW(1,:)== string('CURRENT_SAC_END_X');
No_CURRENT_SAC_END_X_RESOLUTION     = RAW(1,:)== string('CURRENT_SAC_END_X_RESOLUTION');
No_CURRENT_SAC_END_Y                = RAW(1,:)== string('CURRENT_SAC_END_Y');
No_CURRENT_SAC_END_Y_RESOLUTION     = RAW(1,:)== string('CURRENT_SAC_END_Y_RESOLUTION');
No_class                            = RAW(1,:)== string('class');%3/24新增该图片所属分组

No_pic_3_3                          = RAW(1,:)== string('pic_3_3');%该驻视点属于哪一个图片
No_CURRENT_SAC_CONTAINS_BLINK       = RAW(1,:)== string('CURRENT_SAC_CONTAINS_BLINK');
No_CURRENT_SAC_AMPLITUDE            = RAW(1,:)== string('CURRENT_SAC_AMPLITUDE');
NO_TRIAL_START_TIME                 = RAW(1,:)== string('TRIAL_START_TIME');
NO_CURRENT_SAC_START_TIME           = RAW(1,:)== string('CURRENT_SAC_START_TIME');
NO_CURRENT_SAC_END_TIME             = RAW(1,:)== string('CURRENT_SAC_END_TIME');
%存入返回的矩阵
saccade_num(:,1) = NUM(:,No_TRIAL_SACCADE_TOTAL);
saccade_num(:,2) = NUM(:,No_CURRENT_SAC_ANGLE);
saccade_num(:,3) = NUM(:,No_CURRENT_SAC_AVG_VELOCITY);
saccade_num(:,4) = NUM(:,No_CURRENT_SAC_PEAK_VELOCITY);
saccade_num(:,5) = NUM(:,No_CURRENT_SAC_DURATION);
saccade_num(:,6) = NUM(:,No_CURRENT_SAC_START_X);
saccade_num(:,7) = NUM(:,No_CURRENT_SAC_START_Y);
saccade_num(:,8) = NUM(:,No_CURRENT_SAC_START_X_RESOLUTION);
saccade_num(:,9) = NUM(:,No_CURRENT_SAC_START_Y_RESOLUTION);
saccade_num(:,10) = NUM(:,No_CURRENT_SAC_END_X);
saccade_num(:,11) = NUM(:,No_CURRENT_SAC_END_Y);
saccade_num(:,12) = NUM(:,No_CURRENT_SAC_END_X_RESOLUTION);
saccade_num(:,13) = NUM(:,No_CURRENT_SAC_END_Y_RESOLUTION);
saccade_num(:,14) = NUM(:,No_class);
saccade_num(:,15) = NUM(:,No_CURRENT_SAC_CONTAINS_BLINK);%0-不包含眨眼，1-包含眨眼
saccade_num(:,16) = NUM(:,No_CURRENT_SAC_AMPLITUDE);
saccade_num(:,17) = NUM(:,NO_TRIAL_START_TIME);
saccade_num(:,18) = NUM(:,NO_CURRENT_SAC_START_TIME);
saccade_num(:,19) = NUM(:,NO_CURRENT_SAC_END_TIME);

saccade_cell(:,1) = RAW(2:end,No_pic_3_3);

