%% seg_net_metrics.m
% Calculates graph metrics for segments
% version 0.1 alpha
% ADH 31/1/26
%%

% Weighted adjacency matrix (abs)
A_w = abs(A);

% Node degree
deg = degree(G);

% Betweenness centrality
bet = centrality(G,'betweenness');

% Average degree
avgDeg = mean(deg);

% Network density
density = sum(A_w(:)>0) / (nSeg*(nSeg-1));

% Display
fprintf('\n--- Group-Level Network Metrics ---\n');
fprintf('Average Node Degree: %.2f\n', avgDeg);
fprintf('Network Density: %.3f\n', density);

T_graph = table(legendLabels(:), deg, bet, ...
                'VariableNames', {'Segment','Degree','Betweenness'});
disp(T_graph);
