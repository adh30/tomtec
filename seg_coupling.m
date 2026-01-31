%% LV Segment Coupling Network (TomTec 18-Segment Model)

%% -------------------------------------------------
% Collect segment data
%% -------------------------------------------------

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

t = x_LongitudinalStrainMid_Unit____Time_ms__Total(:);

nSeg = numel(segments);
T    = numel(t);


%% -------------------------------------------------
% TomTec AHA labels
%% -------------------------------------------------

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


%% -------------------------------------------------
% Assemble data matrix [time x segment]
%% -------------------------------------------------

Y = NaN(T,nSeg);

for i = 1:nSeg

    y = segments{i}(:);

    if numel(y) == T
        Y(:,i) = y;
    else
        warning('Segment %d length mismatch',i);
    end

end


%% -------------------------------------------------
% Correlation matrix
%% -------------------------------------------------

R = corr(Y,'Rows','pairwise');


%% -------------------------------------------------
% Build adjacency matrix
%% -------------------------------------------------

rThresh = 0.6;    % Coupling threshold

Rnet = R;
Rnet(eye(nSeg)==1) = 0;     % remove self-links

A = Rnet;
A(abs(A) < rThresh) = 0;   % threshold


%% -------------------------------------------------
% Create graph
%% -------------------------------------------------

G = graph(A, legendLabels, 'upper');


%% -------------------------------------------------
% Plot network
%% -------------------------------------------------

figure;

h = plot(G, ...
    'Layout','force', ...
    'NodeFontSize',9, ...
    'MarkerSize',7);

title('LV Segment Coupling Network (Strain Rate)');


%% -------------------------------------------------
% Edge styling (strength + sign)
%% -------------------------------------------------

w = G.Edges.Weight;

% Normalize line widths
wAbs = abs(w);
wNorm = 1 + 4*(wAbs-min(wAbs)) / (max(wAbs)-min(wAbs)+eps);

h.LineWidth = wNorm;

% Color edges by sign
edgeColors = zeros(numel(w),3);

for i = 1:numel(w)

    if w(i) >= 0
        edgeColors(i,:) = [0 0.45 0.74];   % positive = blue
    else
        edgeColors(i,:) = [0.85 0.33 0.1]; % negative = red
    end

end

h.EdgeColor = edgeColors;


%% -------------------------------------------------
% Node coloring by region
%% -------------------------------------------------

nodeColors = zeros(nSeg,3);

% Basal (1–6)  = blue
nodeColors(1:6,:)   = repmat([0.3 0.6 0.9],6,1);

% Mid (7–12)   = green
nodeColors(7:12,:)  = repmat([0.3 0.8 0.4],6,1);

% Apical (13–18)= orange
nodeColors(13:18,:) = repmat([0.9 0.6 0.2],6,1);

h.NodeColor = nodeColors;


%% -------------------------------------------------
% Improve appearance
%% -------------------------------------------------

set(gca,'FontSize',10);
axis off;
