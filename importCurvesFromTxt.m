function blocks = importCurvesFromTxt(fullFileName)
%IMPORTCURVESFROMTXT  Recursively import all Curves blocks from a txt file
%
% This function asks the user to select a txt file from TomTec, then parses all
% 'Curves' blocks recursively. Each block is stored in a struct, with
% subtable names generated from rows +2, +3, +4 relative to 'Curves'.
%
% Output:
%   blocks - struct containing all extracted subtables

    % ---- Read table ----
    T = readtable(fullFileName, 'Delimiter', ',', 'ReadVariableNames', false);
    col1 = string(T{:,1});

    % ---- Parse recursively ----
    blocks = parseBlock(T, col1);

end


% =====================================================================
% Local recursive parser
% =====================================================================
function out = parseBlock(T, col1)
    %PARSEBLOCK  Recursively parse 'Curves' blocks in a table

    out = struct();

    curveIdx = find(startsWith(col1, "Curves"));    % updated to deal with AutoStrain data 
    nCurves  = numel(curveIdx);

    for k = 1:nCurves
        startRow = curveIdx(k);

        % Determine block extent
        if k < nCurves
            endRow = curveIdx(k+1) - 1;
        else
            endRow = height(T);
        end

        blockT   = T(startRow:endRow, :);
        blockCol = col1(startRow:endRow);

        % ---- Build block name from rows +2, +3, +4 ----
        if startRow + 4 > height(T)
            warning('Insufficient rows to name block at row %d. Skipping.', startRow);
            continue
        end

        nameParts = col1(startRow + (2:4));
        nameParts = matlab.lang.makeValidName(nameParts);
        blockName = strjoin(nameParts, "_");

        % ---- Recurse if nested Curves exist ----
        innerIdx = find(blockCol == "Curves");

        if numel(innerIdx) > 1
            % Skip first Curves marker and recurse
            out.(blockName) = parseBlock(blockT(2:end,:), blockCol(2:end));
        else
            % Leaf block
            out.(blockName).table = blockT;
        end
    end
end

