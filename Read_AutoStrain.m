%% Read_AutoStrainCap Tomtec data
% Reads 2D-Tomtec curves from the text file output for further analysis.
% Read_AutoStrain (alpha 0.1): 
% ADH 31/01/26
%%
clear

% -------------------------------------------------------------------------
% Default directory for file selection
% -------------------------------------------------------------------------
defaultDir = 'C:\Users\adh30\OneDrive - University College London\_Tomtec\';

% -------------------------------------------------------------------------
% Let user select a .txt file
% -------------------------------------------------------------------------
[fileName, filePath] = uigetfile( ...
    {'*.txt','Text Files (*.txt)'}, ...
    'Select txt file to import', defaultDir);

if isequal(fileName,0)
    disp('File selection canceled.');
    return;
end

fullFileName = fullfile(filePath, fileName);

% -------------------------------------------------------------------------
% Extract metadata (ID, study date, etc.)
% -------------------------------------------------------------------------
info = ImportInfo(fullFileName);

% -------------------------------------------------------------------------
% Import the hierarchical block structure from the TomTec file
% Each block may contain nested blocks or a leaf containing a table
% -------------------------------------------------------------------------
blocks = importCurvesFromTxt(fullFileName);

% -------------------------------------------------------------------------
% Recursively process all blocks and extract numeric rows
% -------------------------------------------------------------------------
processBlocks(blocks, '');



%% ========================================================================
%  Local recursive function: processBlocks
% ========================================================================
function processBlocks(blockStruct, parentName)
% Recursively walks through the nested TomTec block structure.
% For each leaf block containing a table:
%   • Extracts rows where the last column is numeric
%   • Converts columns 2:end into a numeric array
%   • Assigns each row to the base workspace using a hierarchical name
%
% blockStruct : struct containing nested blocks or leaf tables
% parentName  : accumulated name prefix representing the hierarchy

    % Get all field names in this level of the struct
    fn = fieldnames(blockStruct);

    for k = 1:numel(fn)
        blockName = fn{k};

        % Build hierarchical block name (e.g., "Block_SubBlock")
        fullBlockName = matlab.lang.makeValidName( ...
                            string(parentName + "_" + blockName));

        % Extract the content of this block
        content = blockStruct.(blockName);

        % -----------------------------------------------------------------
        % Case 1: Leaf block containing a table
        % -----------------------------------------------------------------
        if isstruct(content) && isfield(content, 'table')

            T = content.table;          % The actual data table
            nRows = height(T);          % Number of rows
            nCols = width(T) - 1;       % Number of numeric columns (skip col 1)

            % Loop through each row of the table
            for r = 1:nRows
                row = T(r,:);

                % ---------------------------------------------------------
                % Determine whether the last column contains a valid number
                % ---------------------------------------------------------
                lastVal = row{1,end};   % Value in the last column

                if isnumeric(lastVal)
                    isNumericRow = ~isnan(lastVal);
                else
                    isNumericRow = ~isnan(str2double(string(lastVal)));
                end

                % Skip rows that do not contain numeric data
                if ~isNumericRow
                    continue
                end

                % ---------------------------------------------------------
                % Extract variable name from column 1
                % ---------------------------------------------------------
                varName = matlab.lang.makeValidName(string(row{1,1}));

                % ---------------------------------------------------------
                % Convert columns 2:end into a numeric row vector
                % ---------------------------------------------------------
                numericRow = nan(1,nCols);

                for c = 1:nCols
                    v = row.(c+1);

                    if isnumeric(v)
                        numericRow(c) = v;
                    else
                        numericRow(c) = str2double(string(v));
                    end
                end

                % ---------------------------------------------------------
                % Construct final variable name:
                %   <parent>_<block>_<varName>
                % ---------------------------------------------------------
                fullVarName = matlab.lang.makeValidName(fullBlockName + "_" + varName);

                % ---------------------------------------------------------
                % Assign numeric row to base workspace
                % ---------------------------------------------------------
                assignin('base', fullVarName, numericRow);
            end

        % -----------------------------------------------------------------
        % Case 2: Nested struct — recurse deeper
        % -----------------------------------------------------------------
        elseif isstruct(content)
            processBlocks(content, fullBlockName);

        % -----------------------------------------------------------------
        % Case 3: Unexpected content
        % -----------------------------------------------------------------
        else
            warning('Unexpected content type in block "%s".', fullBlockName);
        end
    end
end