function sac_out = selectSac(sac_in, SaccadesSelectionCriteria)
% In this function, we record the index of saccades that should be deleted
% according to the criteria. And delete these saccades at the end of this
% function.

bOnlyStimulis = params.bOnlyStimulis;

len = length(sac_in.StartX);
DelVect = zeros(1,len); % Record the index of saccades that will be deleted

% Each viewing session consists of a black cross with white background
% (1.5s), an interval (0.2s) and a stimuli/an image (5s). Therefore, the
% saccades whose start time is in the first 1.7s should be removed because
% they do not reflect subject's response to this image/stimuli.
if SaccadesSelectionCriteria.RemovePreStimuliSaccades 
    for i = 1:1:len
        if (isnan(sac_in.CURRENT_SAC_START_TIME(i)) || ...
            sac_in.CURRENT_SAC_START_TIME(i) <=1700)
            DelVect(i) = 1;
        end
    end
end

% After all these operations, delete the saccades.
for i = len:-1:1
    if DelVect(i) == 1
        sac_in.Angle(i) = [];
        sac_in.AvgVelocity(i) = [];
        sac_in.PeakVelocity(i) = [];
        sac_in.Duration(i) = [];
        sac_in.StartX(i) = [];
        sac_in.StartY(i) = [];
        sac_in.StartXResolution(i) = [];
        sac_in.StartYResolution(i) = [];
        sac_in.EndX(i) = [];
        sac_in.EndY(i) = [];
        sac_in.EndXResolution(i) = [];
        sac_in.EndYResolution(i) = [];
        sac_in.Class(i) = [];
        sac_in.BlinkRound(i) = [];
        sac_in.Amplitude(i) = [];
        sac_in.TRIAL_START_TIME(i) = [];
        sac_in.CURRENT_SAC_START_TIME(i) = [];
        sac_in.CURRENT_SAC_END_TIME(i) = [];
    end
end

sac_out = sac_in;