function results = LV_EnsembleAnalysis(Y, t, rThresh)
% LV_EnsembleAnalysis
%
% Ensemble and synchrony analysis for 18-segment TomTec LV strain/strain-rate
%
% INPUTS:
%   Y       : [time x 18] segment data matrix
%   t       : [time x 1] time vector (ms)
%   rThresh : optional correlation threshold for network weighting (default=0.6)
%
% OUTPUTS (results struct):
%   results.Basal      : Basal average waveform (segments 1-6)
%   results.Mid        : Mid average waveform (segments 7-12)
%   results.Apical     : Apical average waveform (segments 13-18)
%   results.Global     : Global average waveform (all 18 segments)
%   results.NetWeighted: Network-weighted waveform (using degree centrality)
%   results.PC1        : First principal component waveform
%   results.MD         : Mechanical dispersion (SD of time-to-peak per segment)
%   results.MeanCorr   : Mean inter-segment correlation
%   results.GSI        : Global Synchrony Index
%   results.degree     : Node degree per segment
%   results.betweenness: Betweenness centrality per segment
%   results.R          : Correlation matrix

%% Default threshold
if nargin < 3
    rThresh = 0.6;
end

%% Validate input
[nT, nSeg] = size(Y);
if nSeg ~= 18
    error('Input Y must be [time x 18]');
end
if size(t,1) ~= nT
    error('Time vector t must match number of rows in Y');
end

%% -------------------------------
% 1. Regional averages
%% -------------------------------
results.Basal  = mean(Y(:,1:6),2);
results.Mid    = mean(Y(:,7:12),2);
results.Apical = mean(Y(:,13:18),2);
results.Global = mean(Y,2);

%% -------------------------------
% 2. Correlation matrix
%% -------------------------------
R = corr(Y,'Rows','pairwise');
results.R = R;

%% -------------------------------
% 3. Network-based weighting
%% -------------------------------
Rnet = R; Rnet(eye(nSeg)==1) = 0;
A = Rnet; A(abs(A)<rThresh) = 0;
G = graph(A);
deg = degree(G);
results.degree = deg;
results.betweenness = centrality(G,'betweenness');

% Network-weighted ensemble
weights = deg / sum(deg);
results.NetWeighted = Y * weights;

%% -------------------------------
% 4. Principal Component Analysis
%% -------------------------------
[~, score, ~] = pca(Y);
results.PC1 = score(:,1);

%% -------------------------------
% 5. Mechanical Dispersion (time-to-peak)
%% -------------------------------
% For each segment, find time of minimum (strain rate peak)
tPeak = zeros(1,nSeg);
for i = 1:nSeg
    [~, idx] = min(Y(:,i));  % assuming negative peak = systolic
    tPeak(i) = t(idx);
end
results.MD = std(tPeak);

%% -------------------------------
% 6. Global synchrony indices
%% -------------------------------
results.MeanCorr = mean(Rnet(:),'omitnan');
strongEdges = abs(Rnet) >= rThresh;
results.GSI = sum(strongEdges(:)) / (nSeg*(nSeg-1));

end
