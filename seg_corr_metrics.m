%% seg_corr_metrics
% calculates segment correlation metrics
% version 0.1 alpha
% ADH 31/1/26
%% 

Rnet = R; 
Rnet(eye(nSeg)==1) = 0;  % remove self-correlation

meanCorr = mean(Rnet(:),'omitnan');
fprintf('Mean segment correlation: %.3f\n', meanCorr);


%% -------------------------------
% 2. Global Synchrony Index (fraction of strong edges)
%% -------------------------------

rThresh = 0.6;  % threshold for strong coupling
strongEdges = abs(Rnet) >= rThresh;

GSI = sum(strongEdges(:)) / (nSeg*(nSeg-1)); % fraction of possible edges
fprintf('Global Synchrony Index: %.3f\n', GSI);


%% -------------------------------
% 3. Node-level synchrony: Degree centrality
%% -------------------------------

degreeVals = degree(G);  % number of edges per node
T_degree = table(legendLabels(:), degreeVals, ...
                 'VariableNames', {'Segment','Degree'});
disp(T_degree);

%% Optional: Mechanical dispersion
% If you have segment-specific time-to-peak:
% tPeak = [t1_peak, t2_peak, ..., t18_peak];
% MD = std(tPeak);
% fprintf('Mechanical Dispersion (ms): %.1f\n', MD);
