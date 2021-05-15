function [fix_out,valid_fix_duration] = calcFixFeature(fix)

% Fixation count
len = length(fix.fix_x);
fix_count = len;

% Valid fixation duration
valid_fix_duration = sum(fix.fix_duration);

% Other fixation duration
avg_fix_duration = mean(fix.fix_duration,'omitnan');
max_fix_duration = max(fix.fix_duration,[],1,'omitnan');
min_fix_duration = min(fix.fix_duration,[],1,'omitnan');

% Average fixation x-/y-axis resolution
avg_fix_x_resolution = mean(fix.X_Resolution,'omitnan');
avg_fix_y_resolution = mean(fix.Y_Resolution,'omitnan');

% Pupil-related feature
avg_pupil_size = mean(fix.PupilSize,'omitnan');
max_pupil_size = max(fix.PupilSize,[],1,'omitnan');
min_pupil_size = min(fix.PupilSize,[],1,'omitnan');
max_pupil_size_i = min(find(fix.PupilSize == max_pupil_size));
max_pupil_size_x = fix.fix_x(max_pupil_size_i);
max_pupil_size_y = fix.fix_y(max_pupil_size_i);

% Fixation skewness
sumDist = 0;
for i = 1:len
    x = fix.fix_x(i);
    y = fix.fix_y(i);
    dirtx = abs(x-400);
    dirty = abs(y-300);
    dist = sqrt(dirtx^2 + dirty^2);
    sumDist = sumDist + dist;
end
fix_skewness = sumDist./len;


fix_out.avg_fix_duration = avg_fix_duration;
fix_out.avg_fix_x_resolution = avg_fix_x_resolution;
fix_out.avg_fix_y_resolution = avg_fix_y_resolution;

% The `valid_fix_duration` temporarily save the number of 
% valid_fix_duration, and will be updated while processing saccades.
fix_out.valid_fix_duration = valid_fix_duration;

fix_out.fix_count = fix_count;
fix_out.max_fix_duration = max_fix_duration;
fix_out.min_fix_duration = min_fix_duration;
fix_out.max_pupil_size = max_pupil_size;
fix_out.max_pupil_size_x = max_pupil_size_x;
fix_out.max_pupil_size_y = max_pupil_size_y;
fix_out.avg_pupil_size = avg_pupil_size;
fix_out.valid_fix_duration = valid_fix_duration;
fix_out.min_pupil_size = min_pupil_size;
fix_out.fix_skewness = fix_skewness;