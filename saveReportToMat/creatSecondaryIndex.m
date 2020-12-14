function [secondary_index] = creatSecondaryIndex(xls_num, fixation_cell, TXT)
%creatSecondaryIndex create an secondary table for fixation or saccade
% Specifically, secondary_index(k, 1) is the first fixation of image k and
% secondary(k, 2) is the last fixation of image k

n = size(TXT,1); % the number of images
secondary_index = zeros(n,2);
m = size(xls_num,1);
num_of_fixations_in_this_img = 0; %the number of fixations in this pic


index_of_fixations = 1;
while index_of_fixations < m %遍历注视点，此处一个小bug，不能等于m，不然循环体会出错
    for k = 1:100 %遍历100张图片，寻找k值；k值表示当前注视点对应第k张图片
        if(isequal(fixation_cell(index_of_fixations,1),TXT(k,1)))
            num_of_fixations_in_this_img = xls_num(index_of_fixations,1);
            break;
        end
    end
    secondary_index(k,1) = index_of_fixations;%二级索引表第k张图片的起始点
    index_of_fixations = index_of_fixations + num_of_fixations_in_this_img;
    secondary_index(k,2) = index_of_fixations-1;%二级索引表第k张图片的终止点
end