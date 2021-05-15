
load('Data/FeatureData201912.mat', 'FeatureData');
Type1Feature = [4, 5, 23, 17];
Type2Feature = [21, 9, 24, 25, 18, 22];
Type3Feature = [28, 64, 34, 31, 67, 37];
ixFeature = [Type1Feature, Type2Feature, Type3Feature];

N_Features = length(ixFeature);
N_Patient = sum(FeatureData(:, 3));
N_CTRL = size(FeatureData, 1) - N_Patient;

data = FeatureData(:, ixFeature);
[m, n] = size(data);
Pred = -ones(m,2);

data = normalize(data);

% Classification
KFold = 5;
INDICES = crossvalind('Kfold', 70, KFold); % Divide 70 subjects into K groups
for k = 1:KFold
    tic;
    fprintf('Fold: %d\n', k);
    
    test_idx = zeros(m, 1);
    for i = 1:70
        if INDICES(i)==k
            test_idx = test_idx | FeatureData(:,1)==i;
        end
    end
    train_idx = ~test_idx;
    
    train_data = data(train_idx,:);
    train_label = FeatureData(train_idx,3);
    test_data = data(test_idx,:);
    test_label = FeatureData(test_idx,3);

    %rbf_sum
    testNo = find(test_idx==1);
    SVMStruct = svmtrain(train_data, train_label,'kernel_function','rbf','showplot',false); 
    predict_label  = svmclassify(SVMStruct, test_data,'showplot',false); 
    Pred(testNo,1) = predict_label;
    Pred(testNo,2) = Pred(testNo,2) + ones(length(predict_label),1);
    toc;
end

% Evaluation by sample/row
label = FeatureData(:, 3);
[accuracy, precision, recall] = eval(Pred, label);
fprintf('Sample accuracy: %.2f\n', accuracy);

% Evaluation by person
threshold = 0.5;
subject_pred = -ones(70,1);
label = [zeros(30,1);ones(40,1)];
for i = 1:70
    samples = Pred(FeatureData(:,1)==i, 1);
    if (sum(samples)./length(samples))>=threshold
        subject_pred(i) = 1;
    else
        subject_pred(i) = 0;
    end
end
[accuracy, precision, recall] = eval(subject_pred, label);
fprintf('Subject accuracy: %.2f\n', accuracy);

% Evaluation by images
label = FeatureData(:, 3);
img_accuracy = [[1:100]', zeros(100,1)]; % ImageNo - Accuracy
res = Pred==FeatureData(:, 3);
for img = 1:100
    pic_pred = res(FeatureData(:,2)==img);
    img_accuracy(img,2) = sum(pic_pred)/length(pic_pred);
    fprintf('Image %d accuracy: %.2f\n', img_accuracy(img,1), img_accuracy(img,2));
end
% save('Img_accuracy.mat', 'img_accuracy');



function [accuracy, precision, recall] = eval(pred, label)

    TP = sum(pred == label & label);
    FN = sum(pred ~= label & label);
    FP = sum(pred ~= label & ~label);
    TN = sum(pred == label & ~label);

    precision = TP./(TP+FP);
    recall = TP./(TP+FN);
    accuracy = (TP+TN)./length(pred);

end
    

function data = normalize(data)
    dataMax = max(data);
    dataMin = min(data);
    data = (data-dataMin)./(dataMax - dataMin);
end