function [AUC, ACC, MCC, GM, F_measure] = NewOne(OutLabel, TestingLabel)
    % Calculate True Positive (TP), True Negative (TN), False Positive (FP), and False Negative (FN)
    TP = sum((OutLabel == 1) & (TestingLabel == 1));
    TN = sum((OutLabel == 0) & (TestingLabel == 0));
    FP = sum((OutLabel == 1) & (TestingLabel == 0));
    FN = sum((OutLabel == 0) & (TestingLabel == 1));
    
    % Calculate TPrate, FPrate, precision, and recall
    TPrate = TP / (TP + FN);
    FPrate = FP / (FP + TN);
    precision = TP / (TP + FP);
    recall = TP / (TP + FN);
    
    % Calculate metrics
    % AUC
    AUC = (1 + TPrate - FPrate)/2;
    
    % Accuracy (ACC)
    ACC = (TP + TN) / (TP + TN + FP + FN);
    
    % Matthews Correlation Coefficient (MCC)
    MCC = ((TP * TN) - (FP * FN)) / sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN));
    
    % Geometric Mean (GM)
    GM = sqrt((TP / (TP + FN)) * (TN / (TN + FP)));
    
    % F-measure
    beta = 1; % F1-score
    F_measure = ((beta + 1) * precision * recall) / ((beta * precision) + recall);
end
