function fix_out = selectFix(fix_in, FixationsSelectionCriteria)
% In this function, we record the index of fixations that should be deleted
% according to the criteria. And delete these fixations at the end of this
% function.


if isempty(fix_in.fix_x)
    fix_out = fix_in;
    return;
end

len = length(fix_in.fix_x);
DelVect = zeros(1,len); % Record the index of fixations that will be deleted


if FixationsSelectionCriteria.RemoveFirstFixation
    DelVect(1) = 1;
end

if FixationsSelectionCriteria.RemoveFixationWithBlink
    for i = 1:1:len
        if(fix_in.BlinkRound(i)~=1)
            DelVect(i) = 1;
        end
    end
end

bFixOut = OutOfBoundary(fix_in, 800, 600);
if FixationsSelectionCriteria.RemoveFixationOutOfScreen
    DelVect = DelVect|bFixOut;
end
fix_in.Cnt_Fix_Out_Screen = sum(bFixOut);

if FixationsSelectionCriteria.InROI
    for i = 1:1:len
        if(fix_in.inROI(i) == 0)
            DelVect(i) = 1;
        end
    end
end

% Each viewing session consists of a black cross with white background
% (1.5s), an interval (0.2s) and a stimuli/an image (5s). Therefore, the
% fixation in the first 1.7s should be removed because they do not reflect
% subject's response to this image/stimuli.
if FixationsSelectionCriteria.RemovePreStimuliFixations
    for i = 1:1:len
        if (isnan(fix_in.PREVIOUS_SAC_END_TIME(i)) || ...
            fix_in.PREVIOUS_SAC_END_TIME(i) <=1700)
            DelVect(i) = 1;
        end
    end
end

% After all these operations, delete the fixations.
for i = len:-1:1
    if DelVect(i) == 1
        fix_in.fix_x(i) = [];
        fix_in.fix_y(i) = [];
        fix_in.fix_duration(i) = [];
        fix_in.BlinkRound(i) = [];
        fix_in.PupilSize(i) = [];
        fix_in.X_Resolution(i) = [];
        fix_in.Y_Resolution(i) = [];
        fix_in.Class(i) = [];
        fix_in.inROI(i) = [];
    end
end

fix_out = fix_in;