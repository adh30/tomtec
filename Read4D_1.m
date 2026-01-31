% Read 4D Tomtec data
clear
% Import the entire file as a table
filename = 'C:\Users\adh30\OneDrive - University College London\_Tomtec\4DLV_35747_20260127_112547.txt';

% Read the file without assuming variable names
T = readtable(filename, 'Delimiter', ',', 'ReadVariableNames', false);

% Extract rows 781 and 782
subsetvol = T(781:782, :);

% First column = variable names (text)
varNames = subsetvol{:,1};   % cell array of strings

% Number of numeric columns
nCols = width(subsetvol) - 1;

% Preallocate numeric array
numericData = zeros(2, nCols);

% Loop through numeric columns and convert safely
for c = 1:nCols
    col = subsetvol{:, c+1};

    % Convert cell text to double if needed
    if iscell(col)
        numericData(:,c) = str2double(col);
    else
        numericData(:,c) = col;
    end
end

time= numericData(1,:);
volume = numericData(2,:);
% Perform a simple plot of volume against time
figure;
plot(time, volume);
xlabel('Time');
ylabel('Volume');
title('Volume vs Time');
grid on;