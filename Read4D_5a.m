% Read 4D Tomtec data
clear
% ===== USER INPUT =====
% Import the entire file as a table
filename = 'C:\Users\adh30\OneDrive - University College London\_Tomtec\4DLV_35747_20260127_112547.txt';

% Read table
T = readtable(filename, 'Delimiter', ',', 'ReadVariableNames', false);

% Extract first column as string for safe comparison
col1 = string(T{:,1});

% Find all occurrences of 'Curves'
curveIdx = find(col1 == "Curves");
nCurves  = numel(curveIdx);

% Container for results (preferred to base workspace pollution)
subtables = struct();

for k = 1:nCurves
    startRow = curveIdx(k);

    % Determine end row
    if k < nCurves
        endRow = curveIdx(k+1) - 1;
    else
        endRow = height(T);
    end

    % Extract subtable
    subT = T(startRow:endRow, :);

    % ---- Build subtable name from rows +2, +3, +4 ----
    nameParts = col1(startRow + (2:4));
    nameParts = matlab.lang.makeValidName(nameParts);

    subName = strjoin(nameParts, "_");

    % Store
    subtables.(subName) = subT;
end
