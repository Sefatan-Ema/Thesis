function tree = customFitctree(X, y)
    % CUSTOMFITCTREE Build a simple decision tree classifier.
    % X: Features (matrix)
    % y: Labels (column vector)

    tree = buildTree(X, y);
end

function node = buildTree(X, y)
    % Recursive function to build the decision tree
    if length(unique(y)) == 1
        % If all labels are the same, return the leaf node
        node.label = y(1);
        return;
    end
    
    if size(X, 1) < 2
        % If there's not enough data, return the most common label
        node.label = mode(y);
        return;
    end

    % Find the best split
    [bestFeature, bestThreshold] = findBestSplit(X, y);
    if isempty(bestFeature)
        node.label = mode(y); % If no valid split found
        return;
    end

    % Split the dataset
    leftIdx = X(:, bestFeature) < bestThreshold;
    rightIdx = X(:, bestFeature) >= bestThreshold;

    % Create the node
    node.feature = bestFeature;
    node.threshold = bestThreshold;
    node.left = buildTree(X(leftIdx, :), y(leftIdx));
    node.right = buildTree(X(rightIdx, :), y(rightIdx));
end

function [bestFeature, bestThreshold] = findBestSplit(X, y)
    % Find the best feature and threshold to split on
    bestGini = inf;
    bestFeature = [];
    bestThreshold = [];

    numFeatures = size(X, 2);
    for feature = 1:numFeatures
        thresholds = unique(X(:, feature));
        for threshold = thresholds'
            leftIdx = X(:, feature) < threshold;
            rightIdx = X(:, feature) >= threshold;
            if sum(leftIdx) == 0 || sum(rightIdx) == 0
                continue; % Skip if no samples in one side
            end
            
            % Calculate Gini impurity for the split
            gini = calculateGini(y(leftIdx), y(rightIdx));
            if gini < bestGini
                bestGini = gini;
                bestFeature = feature;
                bestThreshold = threshold;
            end
        end
    end
end

function gini = calculateGini(leftLabels, rightLabels)
    % Calculate the Gini impurity for a split
    p1 = sum(leftLabels == 1) / length(leftLabels);
    p0 = sum(leftLabels == 0) / length(leftLabels);
    giniLeft = 1 - (p1^2 + p0^2);
    
    p1 = sum(rightLabels == 1) / length(rightLabels);
    p0 = sum(rightLabels == 0) / length(rightLabels);
    giniRight = 1 - (p1^2 + p0^2);

    % Weighted average of Gini impurity
    gini = (length(leftLabels) * giniLeft + length(rightLabels) * giniRight) / (length(leftLabels) + length(rightLabels));
end
