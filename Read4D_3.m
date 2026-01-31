% Read 4D Tomtec data
clear
% ===== USER INPUT =====
% Import the entire file as a table
filename = 'C:\Users\adh30\OneDrive - University College London\_Tomtec\4DLV_35747_20260127_112547.txt';

rowsToExtract = [781 782 900 901 1020];
% ======================

% Read file once
T = readtable(filename, 'Delimiter', ',', 'ReadVariableNames', false);

nCols = width(T) - 1;

for r = 1:numel(rowsToExtract)
    row = rowsToExtract(r);
    subset = T(row, :);

    % Extract variable name (first column)
    varName = string(subset{1,1});
    varName = matlab.lang.makeValidName(varName);  % ensure valid identifier

    % Convert numeric columns safely
    numericRow = nan(1, nCols);

    for c = 1:nCols
        v = subset.(c+1);

        if isnumeric(v)
            numericRow(c) = v;
        else
            numericRow(c) = str2double(string(v));
        end
    end

    % Assign variable to workspace
    assignin('base', varName, numericRow);
end
