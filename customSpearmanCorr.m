function corr_val = customSpearmanCorr(x, y)
    % Remove NaN values in x and y
    validIdx = ~isnan(x) & ~isnan(y);
    x = x(validIdx);
    y = y(validIdx);

    if numel(x) < 2
        error('Not enough data points for Spearman correlation calculation.');
    end

    % Compute ranks using custom tied rank function
    x_rank = customTiedRank(x);
    y_rank = customTiedRank(y);

    % Compute Pearson correlation on ranks
    mean_x_rank = mean(x_rank);
    mean_y_rank = mean(y_rank);
    numerator = sum((x_rank - mean_x_rank) .* (y_rank - mean_y_rank));
    denominator = sqrt(sum((x_rank - mean_x_rank).^2) * sum((y_rank - mean_y_rank).^2));
    
    corr_val = numerator / denominator;
    
    function ranks = customTiedRank(data)
    % Get the sorted indices of the data
    [sortedData, sortedIdx] = sort(data);
    ranks = zeros(size(data));
    
    % Initialize rank
    currentRank = 1;
    i = 1;
    
    % Loop through sorted data
    while i <= length(data)
        % Find the indices of tied values
        tieGroup = find(sortedData == sortedData(i));
        
        % Calculate the average rank for the tied group
        avgRank = mean(currentRank:(currentRank + length(tieGroup) - 1));
        
        % Assign the average rank to all tied positions
        ranks(sortedIdx(i:i + length(tieGroup) - 1)) = avgRank;
        
        % Update rank and index
        currentRank = currentRank + length(tieGroup);
        i = i + length(tieGroup);
    end
end

end
