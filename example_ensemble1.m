% Example usage:

% Y = [time x 18] segment strain-rate matrix
% t = [time x 1] vector in ms

results = LV_EnsembleAnalysis(Y, t);

% Access outputs:
plot(t, results.Basal, 'b', t, results.Mid, 'g', t, results.Apical, 'r');
legend('Basal','Mid','Apical');
xlabel('Time (ms)'); ylabel('Strain rate (1/s)');
title('Regional Averages');

% Global and network-weighted
figure;
plot(t, results.Global, 'k', t, results.NetWeighted, 'm');
legend('Global','Network-weighted');
