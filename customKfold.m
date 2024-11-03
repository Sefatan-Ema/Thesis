function indices = customKfold(group, k)
    numObservations = length(group);
    indices = zeros(numObservations, 1);
    
    % Create a stratified k-fold partition
    uniqueClasses = unique(group);
    for i = 1:length(uniqueClasses)
        classIndices = find(group == uniqueClasses(i));
        numClassInstances = length(classIndices);
        
        % Shuffle class indices
        shuffledClassIndices = classIndices(randperm(numClassInstances));
        
        % Assign k-fold indices
        foldSizes = floor(numClassInstances / k) * ones(1, k);
        foldSizes(1:mod(numClassInstances, k)) = foldSizes(1:mod(numClassInstances, k)) + 1;
        
        currentIdx = 1;
        for j = 1:k
            indices(shuffledClassIndices(currentIdx:currentIdx+foldSizes(j)-1)) = j;
            currentIdx = currentIdx + foldSizes(j);
        end
    end
end
