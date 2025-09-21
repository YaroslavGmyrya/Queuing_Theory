%% define params
N = 600;      % samples
K = 200;      % realizations
mu = 12;      % avg
sigma = 10;   % SKO

%% create matrix with realization N(mu, sigma), where (N - rows, K - cols)
realization_matrix = mu + sigma * randn(N,K);

%% compute avg ensemble
avgs_ensemble = mean(realization_matrix, 2); 

%% compute avg realization
avgs_realization = mean(realization_matrix, 1)';

%% create plots for comparison

rows = 1 : 1 : N;
cols = 1 : 1 : K;

subplot(2, 1, 1);
plot(rows, avgs_ensemble);
xlabel("ensemble");
ylabel("avg");
title("avg ensemle");
grid on;

subplot(2, 1, 2);
plot(cols, avgs_realization);
xlabel("time (sample)");
ylabel("avg");
title("avg time");
grid on;

%% build scatter for realization_matrix(n_i) and realization_matrix(n_j)
ni = [10, 50, 100];  
nj = [25, 87, 153]; 

for k = 1:3
    subplot(1, 3, k);  
    scatter(realization_matrix(ni(k), :), realization_matrix(nj(k), :), 'filled');
    r = corr(realization_matrix(ni(k), :)', realization_matrix(nj(k), :)');

    xlabel(['\xi[' num2str(ni(k)) ']']);
    ylabel(['\xi[' num2str(nj(k)) ']']);
    title(sprintf('Scatter plot for n_i=%d, n_j=%d, r=%.2f', ni(k), nj(k), r));
    grid on;
end