%% TomTec Longitudinal Strain Rate Plot (18-Segment AHA Standard)
% currently only takes the midwall data and plots it. 
% ADH 31/01/26
%%
% Collect segment data into a cell array
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

% Time vector
t =  x_LongitudinalStrainRateMid_Unit_1_s__Time_ms__Time_ms_;

%% TomTec AHA 18-Segment Labels
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

%% Style definitions

% Color set (MATLAB default-like)
colors = lines(18);

% Line styles (cycled)
lineStyles = {'-','--','-.',':'};

%% Plot
figure;
hold on;

validIdx = true(1,numel(segments));
h = gobjects(1,numel(segments));

for i = 1:numel(segments)

    y = segments{i}(:);

    % Check length consistency
    if numel(y) ~= numel(t)
        warning('Segment %d length mismatch (skipped)', i);
        validIdx(i) = false;
        continue;
    end

    % Select style
    c  = colors(i,:);
    ls = lineStyles{mod(i-1,numel(lineStyles))+1};

    % Plot
    h(i) = plot(t, y, ...
        'Color', c, ...
        'LineStyle', ls, ...
        'LineWidth', 1.2);

end

hold off;

%% Formatting
xlabel('Time (ms)');
ylabel('Longitudinal Strain Rate (1/s)');
title('Mid-wall Longitudinal Strain Rate (TomTec 18-Segment Model)');
grid on;

%% Legend
legend(h(validIdx), legendLabels(validIdx), ...
       'Location','eastoutside', ...
       'NumColumns',2, ...
       'FontSize',9);
