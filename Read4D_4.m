% Read 4D Tomtec data
clear
% ===== USER INPUT =====
% Import the entire file as a table
filename = 'C:\Users\adh30\OneDrive - University College London\_Tomtec\4DLV_35747_20260127_112547.txt';

% Read file once
T = readtable(filename, 'Delimiter', ',', 'ReadVariableNames', false);
nRows = height(T);
nCols = width(T) - 1;




for r = 1:nRows
    row = T(r, :);

    % Check if last column is numeric or numeric-encoded text
    lastVal = row.(width(T));

    if isnumeric(lastVal)
        isNumericRow = ~isnan(lastVal);
    else
        isNumericRow = ~isnan(str2double(string(lastVal)));
    end

    if ~isNumericRow
        continue
    end

    % Variable name from first column
    varName = string(row{1,1});
    varName = matlab.lang.makeValidName(varName);

    % Convert columns 2:end safely
    numericRow = nan(1, nCols);

    for c = 1:nCols
        v = row.(c+1);

        if isnumeric(v)
            numericRow(c) = v;
        else
            numericRow(c) = str2double(string(v));
        end
    end

    % Assign variable
    assignin('base', varName, numericRow);
end
