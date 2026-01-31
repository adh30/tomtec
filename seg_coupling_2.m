%% seg_coupling_2.m
% LV Segment Coupling Analysis (TomTec 18-Segment Model)
% Plots strain-rate, network, and computes synchrony metrics
% version 0.1 alpha
% ADH 31/1/26
%%

% Collect segment data
segments = {
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment1
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment2
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment3
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment4
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment5
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment6
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment7
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment8
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment9
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment10
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment11
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment12
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment13
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment14
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment15
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment16
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment17
    x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Segment18
};
% identify time, t
t = x_LongitudinalStrainMid_Unit____Time_ms__Total(:);
nSeg = numel(segments);
T    = numel(t);

%% TomTec AHA 18-segment labels

legendLabels = {
    'Basal Anterior'
    'Basal Anteroseptal'
    'Basal Inferoseptal'
    'Basal Inferior'
    'Basal Inferolateral'
    'Basal Anterolateral'

    'Mid Anterior'
    'Mid Anteroseptal'
    'Mid Inferoseptal'
    'Mid Inferior'
    'Mid Inferolateral'
    'Mid Anterolateral'

    'Apical Anterior'
    'Apical Septal'
    'Apical Inferior'
    'Apical Lateral'
    'Apical Posterior'
    'Apical Anterolateral'
};

%% Assemble data matrix [time x segment]

Y = NaN(T,nSeg);
for i = 1:nSeg
    y = segments{i}(:);
    if numel(y) == T
        Y(:,i) = y;
    else
        warning('Segment %d length mismatch',i);
    end
end

%% Plot strain rate waveforms

colors = lines(nSeg);
lineStyles = {'-','--','-.',':'};

figure; hold on;
for i = 1:nSeg
    ls = lineStyles{mod(i-1,numel(lineStyles))+1};
    plot(t,Y(:,i),'Color',colors(i,:),'LineStyle',ls,'LineWidth',1.2);
end
xlabel('Time (ms)');
ylabel('Longitudinal Strain Rate (1/s)');
title('Mid-wall Longitudinal Strain Rate (TomTec 18-Segment)');
grid on;
legend(legendLabels,'Location','eastoutside','NumColumns',2,'FontSize',9);

%% Compute correlation matrix

R = corr(Y,'Rows','pairwise');

%% Build thresholded network graph

rThresh = 0.6;               % threshold for strong coupling (arbitrary)
Rnet = R; Rnet(eye(nSeg)==1) = 0;
A = Rnet; A(abs(A)<rThresh)=0;

G = graph(A,legendLabels,'upper');

figure;
h = plot(G,'Layout','force','NodeFontSize',9,'MarkerSize',7);
title('LV Segment Coupling Network (Strain Rate)');

% Edge width & color
w = G.Edges.Weight;
wNorm = 1 + 4*(abs(w)-min(abs(w))) / (max(abs(w))-min(abs(w))+eps);
h.LineWidth = wNorm;
edgeColors = zeros(numel(w),3);
for i = 1:numel(w)
    edgeColors(i,:) = w(i)>=0*[0 0.45 0.74] + w(i)<0*[0.85 0.33 0.1];
    if w(i)>=0, edgeColors(i,:)=[0 0.45 0.74]; else, edgeColors(i,:)=[0.85 0.33 0.1]; end
end
h.EdgeColor = edgeColors;

% Node colors by region
nodeColors = zeros(nSeg,3);
nodeColors(1:6,:) = repmat([0.3 0.6 0.9],6,1);
nodeColors(7:12,:) = repmat([0.3 0.8 0.4],6,1);
nodeColors(13:18,:) = repmat([0.9 0.6 0.2],6,1);
h.NodeColor = nodeColors;
set(gca,'FontSize',10); axis off;

%% Quantitative synchrony indices

% Mean correlation
meanCorr = mean(Rnet(:),'omitnan');
fprintf('Mean segment correlation: %.3f\n', meanCorr);

% Global Synchrony Index (fraction of edges above threshold)
strongEdges = abs(Rnet) >= rThresh;
GSI = sum(strongEdges(:)) / (nSeg*(nSeg-1));
fprintf('Global Synchrony Index: %.3f\n', GSI);

% Node-level degree centrality
degreeVals = degree(G);
T_degree = table(legendLabels(:),degreeVals,'VariableNames',{'Segment','Degree'});
disp(T_degree);

%% Group-level network statistics

% Betweenness centrality
bet = centrality(G,'betweenness');

% Average degree
avgDeg = mean(degreeVals);

% Network density
density = sum(A(:)>0)/(nSeg*(nSeg-1));

fprintf('\n--- Group-Level Network Metrics ---\n');
fprintf('Average Node Degree: %.2f\n', avgDeg);
fprintf('Network Density: %.3f\n', density);

T_graph = table(legendLabels(:), degreeVals, bet, ...
    'VariableNames',{'Segment','Degree','Betweenness'});
disp(T_graph);