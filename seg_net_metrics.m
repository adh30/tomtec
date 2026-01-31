%% -------------------------------
% Graph metrics
%% -------------------------------

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

%% Optional: Clustering coefficient (requires Brain Connectivity Toolbox)
% cc = clustering_coef_wu(A_w);
% T_cc = table(legendLabels(:), cc, 'VariableNames', {'Segment','Clustering'});
% disp(T_cc);
