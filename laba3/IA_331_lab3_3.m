%% define params
N = 600;
K = 200;
mu = 0;
sigma = 1;
a = 0.9;
l1 = 5; l2 = 50;

omega = mu + sigma*randn(N,K);
xi_matrix = zeros(N,K);
xi_matrix(1,:) = omega(1,:);

for n = 2:N
    xi_matrix(n,:) = a*xi_matrix(n-1,:) + omega(n,:);
end

figure;
plot(1:N, xi_matrix, 'LineWidth', 1);
xlabel('n');
ylabel('\xi[n]');
title('Damped random walk realizations');
grid on;

pairs1 = [10 9; 50 49; 100 99; 200 199];
pairs2 = [50 40; 100 90; 200 190];

colors = lines(max(size(pairs1,1), size(pairs2,1)));

figure;

subplot(1,2,1);
hold on;
for k = 1:size(pairs1,1)
    ni = pairs1(k,1);
    nj = pairs1(k,2);
    scatter(xi_matrix(ni,:), xi_matrix(nj,:), 36, colors(k,:), 'filled');
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
    scatter(xi_matrix(ni,:), xi_matrix(nj,:), 36, colors(k,:), 'filled');
end
xlabel('\xi[ni]');
ylabel('\xi[nj]');
title('Отдаленные отсчеты');
grid on;
legend(arrayfun(@(k) sprintf('(%d,%d)',pairs2(k,1),pairs2(k,2)), 1:size(pairs2,1), 'UniformOutput', false));
hold off;

r_empirical = zeros(N-1,1);
for n = 2:N
    r_empirical(n-1) = mean(xi_matrix(n,:) .* xi_matrix(n-1,:));
end

r_theoretical = (a.^(0:N-2)') * sigma^2;

figure;
plot(2:N, r_empirical, 'b', 'LineWidth', 1.5); hold on;
plot(2:N, r_theoretical, 'r--', 'LineWidth', 1.5);
xlabel('n');
ylabel('r_\xi(n,n-1)');
title('Выборочная автокорреляция vs Теоретическая');
legend('Выборочная (по ансамблю)','Теоретическая');
grid on;
