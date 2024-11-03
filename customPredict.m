function predictions = customPredict(tree, X)
    % CUSTOMPREDICT Make predictions using the decision tree
    predictions = zeros(size(X, 1), 1);
    for i = 1:size(X, 1)
        predictions(i) = predictSingle(tree, X(i, :));
    end
end

function label = predictSingle(node, sample)
    % Recursive function to predict a single sample
    if isfield(node, 'label')
        label = node.label;
        return;
    end
    
    if sample(node.feature) < node.threshold
        label = predictSingle(node.left, sample);
    else
        label = predictSingle(node.right, sample);
    end
end
