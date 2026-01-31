%% seg_corr.m
% calculates correlation matrix for segments
% version 0.1 alpha
% ADH 31/1/25
%%
% Assemble data matrix [time x segment]
nSeg = numel(segments);
T    = numel(t);

Y = NaN(T, nSeg);

for i = 1:nSeg
    y = segments{i}(:);

    if numel(y) == T
        Y(:,i) = y;
    else
        warning('Segment %d length mismatch (excluded from correlation)', i);
    end
end


%% Correlation matrix (Pearson)

R = corr(Y, 'Rows','pairwise');


%% Display correlation matrix

figure;

imagesc(R);
axis equal tight;
colorbar;

clim([-1 1]);   % correlation range

title('Inter-Segment Correlation (Longitudinal Strain Rate)');
xlabel('Segment');
ylabel('Segment');


%% Tick labels (AHA)

set(gca, ...
    'XTick',1:nSeg, ...
    'YTick',1:nSeg, ...
    'XTickLabel',legendLabels, ...
    'YTickLabel',legendLabels, ...
    'XTickLabelRotation',45, ...
    'FontSize',9);

grid on;


%% Optional: Show values on heatmap

for i = 1:nSeg
    for j = 1:nSeg
        if ~isnan(R(i,j))
            text(j,i,sprintf('%.2f',R(i,j)), ...
                'HorizontalAlignment','center', ...
                'FontSize',7, ...
                'Color','k');
        end
    end
end
