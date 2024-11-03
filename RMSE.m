function [rmse_value] = RMSE(file_data, FID_data)
    % This function calculates the Root Mean Square Error (RMSE) between file_data and FID_data
    % Ensure both data arrays have the same dimensions
    if ~isequal(size(file_data), size(FID_data))
        error('Input matrices must have the same dimensions.');
    end

    % Calculate the RMSE across all elements
    rmse_value = sqrt(mean((file_data(:) - FID_data(:)).^2)); % Vectorized calculation for efficiency
end
