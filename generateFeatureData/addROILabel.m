function fixations_out = addROILabel(fixations_in, ROI)

fixations_out = fixations_in;

k = 0; % Subject_ix
for i = 1:100
    ROImap = ROI{i};
    if ~isempty(ROImap)
        % If image i has ROI map, then give each fixation a ROI Lable that indicates it is 
        % in the ROI or not.
        for k = 1:70
            fix = fixations_in{i}.subject{k};
            if ~isempty(fix) && ~isempty(fix.fix_x)
                % Only when there is fixation on this image, then label the fixation
                for j = 1:length(fix.fix_x);
                    x1 = floor(fix.fix_x(j));
                    y1 = floor(fix.fix_y(j));
                    if(x1>0 && x1<800 && y1>0 && y1<600) % the range of x1 and y1 are 1-799 and 1-599, resepctively
                        x2 = x1 + 1;
                        y2 = y1 + 1;
                        % The coordinate (x,y) in EYELINK should be swapped in MATLAB
                          nearestPixelsSum = ROImap(y1,x1) + ROImap(y1,x2) + ROImap(y2,x1) + ROImap(y2,x2);
                        if nearestPixelsSum >= 3
                            % Only when the surrounding 4 pixels contain at least 3 pixels in ROI,
                            % the fixation will be regarded as in ROI
                            fix.inROI(j) = true;
                        else
                            fix.inROI(j) = false;
                        end
                    else
                         fix.inROI(j) = false;
                    end
                end
            end
            fixations_out{i}.subject{k} = fix; % update fixation
        end
    else
        for k = 1:70
            fix = fixations_in{i}.subject{k};
            if ~isempty(fix) && ~isempty(fix.fix_x)
                len = length(fix.fix_x);
                fix.inROI = zeros(len,1);
            end
            fixations_out{i}.subject{k} = fix;
        end
    end

end