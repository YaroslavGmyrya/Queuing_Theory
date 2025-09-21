%% define params
N = 600;      % samples
K = 200;      % realizations
mu = 0;      % avg
sigma = 1;   % SKO
l1 = 5; l2 = 50;   % lags
%% create random walk matrix

omega = mu + sigma*randn(N,K);
rw_matrix = cumsum(omega);

%% build rw plot
figure;
plot(1:N, rw_matrix, 'LineWidth', 1);
xlabel('n');
ylabel('xi[n]');
title('Random walk realizations');
grid on;


%% (n_i, n_j) pairs
pairs1 = [10 9; 50 49; 100 99; 200 199];

pairs2 = [50 40; 100 90; 200 190];

%% define colors
colors = lines(max(size(pairs1,1), size(pairs2,1)));

%% build plots 
figure;

subplot(1,2,1);
hold on;

for k = 1:size(pairs1,1)
    ni = pairs1(k,1);
    nj = pairs1(k,2);
    scatter(realization_matrix(ni,:), realization_matrix(nj,:), 36, colors(k,:), 'filled');
end

xlabel('\xi[ni]');
ylabel('\xi[nj]');
title('Соседние отсчеты');
grid on;
legend(arrayfun(@(k) sprintf('(%d,%d)',pairs1(k,1),pairs1(k,2)), 1:size(pairs1,1), 'UniformOutput', false));
hold off;

subplot(1,2,2);
hold on;
for k = 1:size(pairs2,1)
    ni = pairs2(k,1);
    nj = pairs2(k,2);
    scatter(realization_matrix(ni,:), realization_matrix(nj,:), 36, colors(k,:), 'filled');
end
xlabel('\xi[ni]');
ylabel('\xi[nj]');
title('Отдаленные отсчеты');
grid on;
legend(arrayfun(@(k) sprintf('(%d,%d)',pairs2(k,1),pairs2(k,2)), 1:size(pairs2,1), 'UniformOutput', false));
hold off;

r_empirical = zeros(N-1,1);
for n = 2:N
    r_empirical(n-1) = mean(realization_matrix(n,:) .* realization_matrix(n-1,:));
end

%% theoretical corr
r_theoretical = ((1:N-1)' ) * sigma^2;

%% Построение графика
figure;
plot(2:N, r_empirical, 'b', 'LineWidth', 1.5); hold on;
plot(2:N, r_theoretical, 'r--', 'LineWidth', 1.5);
xlabel('n');
ylabel('r_\xi(n,n-1)');
title('Выборочная автокорреляция vs Теоретическая');
legend('Выборочная (по ансамблю)','Теоретическая');
grid on;