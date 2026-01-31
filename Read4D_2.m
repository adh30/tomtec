% Read 4D Tomtec data
clear
% Import the entire file as a table
filename = 'C:\Users\adh30\OneDrive - University College London\_Tomtec\4DLV_35747_20260127_112547.txt';

% Read file
T = readtable(filename, 'Delimiter', ',', 'ReadVariableNames', false);

% Extract rows
subsetvol = T(781:782, :);

% First column: names
varNames = subsetvol{:,1};

% Preallocate
nCols = width(subsetvol) - 1;
numericData = nan(2, nCols);

% Convert each variable safely
for c = 1:nCols
    v = subsetvol.(c+1);

    if isnumeric(v)
        numericData(:,c) = v;
    else
        numericData(:,c) = str2double(string(v));
    end
end

% Assign outputs
time   = numericData(1,:);
volume = numericData(2,:);

% Perform a simple plot of volume against time
figure;
plot(time, volume);
xlabel('Time');
ylabel('Volume');
title('Volume vs Time');
grid on;