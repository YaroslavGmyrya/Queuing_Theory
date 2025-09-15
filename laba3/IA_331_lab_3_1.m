

%% ------------------- ПАРАМЕТРЫ -------------------
N = 600;     % длина реализации
K = 200;       % число реализаций
mu = 12;       % мат. ожидание шума
sigma = 10;    % СКО шума

%% ------------------- 1. БЕЛЫЙ ШУМ -------------------
% Матрица Xi (N x K): каждая колонка – реализация
Xi = mu + sigma*randn(N, K);

% Среднее по ансамблю (усреднение по строкам)
mu_ens = mean(Xi, 2);

% Среднее по времени для каждой реализации
mu_time = mean(Xi, 1);

% Рисуем
figure;
plot(1:N, mu_ens, 'LineWidth', 2); hold on;
plot(1:K, mu_time, 'ro'); 
yline(mu, '--k', 'Теор. среднее');
xlabel('n (или k)');
ylabel('Среднее значение');
title('Задание 1: Белый шум');
legend('Среднее по ансамблю', 'Среднее по времени','Теор. среднее');
grid on;

%% ------------------- 2. СКАТТЕРОГРАММЫ -------------------
pairs = [10 9; 50 49; 100 99];

figure;
for i = 1:3
    ni = pairs(i,1); nj = pairs(i,2);
    subplot(1,3,i);
    scatter(Xi(ni,:), Xi(nj,:), 'filled');
    xlabel(['\xi[' num2str(ni) ']']);
    ylabel(['\xi[' num2str(nj) ']']);
    title(['Скаттер: n_i=' num2str(ni) ', n_j=' num2str(nj)]);
    grid on;

    % Выборочная корреляция
    r_hat = mean(Xi(ni,:).*Xi(nj,:));
    fprintf('Задание 2: r_hat(%d,%d) = %.4f\n', ni, nj, r_hat);
end

%% ------------------- 3. СЛУЧАЙНОЕ БЛУЖДАНИЕ -------------------
Omega = mu + sigma*randn(N,K);
Xi_rw = zeros(N,K);
for k = 1:K
    for n = 2:N
        Xi_rw(n,k) = Xi_rw(n-1,k) + Omega(n,k);
    end
end

% Теоретическое мат. ожидание
mu_rw_theory = (0:N-1)*mu;

fprintf('Задание 3: M[xi[n]] = %g для любого n\n', mu);

%% ------------------- 4. СКО случайного блуждания -------------------
% Теория: D[xi[n]] = n * sigma^2, при sigma^2=1 → sqrt(n)
sigma_rw_theory = sqrt(0:N-1);

figure;
plot(0:N-1, sigma_rw_theory, 'LineWidth', 2);
xlabel('n');
ylabel('\sigma_{\xi}[n]');
title('Задание 4: СКО случайного блуждания');
grid on;

%% ------------------- 5. АКФ случайного блуждания -------------------
% r_xi(n,n-1) = M[xi[n-1]^2] = (n-1)*sigma^2
r_theory = (0:N-1);

% Нормированный коэффициент корреляции
rho_theory = r_theory ./ sqrt((0:N-1).*(1:N));

figure;
plot(1:200, rho_theory(2:201), 'LineWidth', 2);
xlabel('n');
ylabel('\rho_{\xi}(n,n-1)');
title('Задание 5: Нормированный коэффициент корреляции (RW)');
grid on;

%% ------------------- 6. МАТРИЦА реализаций для RW -------------------
Xi_rw_mat = zeros(N,K);
for k = 1:K
    for n = 2:N
        Xi_rw_mat(n,k) = Xi_rw_mat(n-1,k) + randn;
    end
end

figure;
plot(1:N, Xi_rw_mat);
xlabel('n');
ylabel('\xi[n]');
title('Задание 6: Реализации случайного блуждания');
grid on;

% Скаттерограммы
pairs1 = [10 9; 50 49; 100 99; 200 199];
pairs2 = [50 40; 100 90; 200 190];

figure;
subplot(1,2,1); hold on;
for i=1:size(pairs1,1)
    scatter(Xi_rw_mat(pairs1(i,1),:), Xi_rw_mat(pairs1(i,2),:), 'filled');
end
title('Соседние точки (RW)');
grid on;

subplot(1,2,2); hold on;
for i=1:size(pairs2,1)
    scatter(Xi_rw_mat(pairs2(i,1),:), Xi_rw_mat(pairs2(i,2),:), 'filled');
end
title('Отдалённые точки (RW)');
grid on;

%% ------------------- 7. Выборочная АКФ по ансамблю -------------------
r_exp = mean(Xi_rw_mat(2:end,:).*Xi_rw_mat(1:end-1,:), 2);

figure;
plot(2:N, r_exp, 'r', 'LineWidth', 2); hold on;
plot(2:N, r_theory(2:end), 'b--');
xlabel('n');
ylabel('r_{\xi}(n,n-1)');
title('Задание 7: АКФ случайного блуждания (эксперимент vs теория)');
legend('Эксперимент','Теория');
grid on;

%% ------------------- 8. СЛУЧАЙНОЕ БЛУЖДАНИЕ С ЗАТУХАНИЕМ -------------------
Xi_rw_decay = zeros(N,K);
for k = 1:K
    for n = 2:N
        Xi_rw_decay(n,k) = 0.9*Xi_rw_decay(n-1,k) + randn;
    end
end

figure;
plot(1:N, Xi_rw_decay);
xlabel('n');
ylabel('\xi[n]');
title('Задание 8: Случайное блуждание с затуханием');
grid on;

%% ------------------- 9. СКАТТЕРОГРАММЫ ДЛЯ RW С ЗАТУХАНИЕМ -------------------
figure;
subplot(1,2,1); hold on;
for i=1:size(pairs1,1)
    scatter(Xi_rw_decay(pairs1(i,1),:), Xi_rw_decay(pairs1(i,2),:), 'filled');
end
title('Соседние точки (RW с затуханием)');
grid on;

subplot(1,2,2); hold on;
for i=1:size(pairs2,1)
    scatter(Xi_rw_decay(pairs2(i,1),:), Xi_rw_decay(pairs2(i,2),:), 'filled');
end
title('Отдалённые точки (RW с затуханием)');
grid on;

%% ------------------- 10. Сравнение АКФ -------------------
% Белый шум (теория): дельта-функция
acf_white = [1 zeros(1,50)];

% RW: растёт с n
acf_rw = 0:50;

% RW с затуханием: затухающая экспонента
acf_decay = (0.9).^(0:50);

figure;
stem(0:50, acf_white, 'r','LineWidth',2); hold on;
plot(0:50, acf_rw, 'b','LineWidth',2);
plot(0:50, acf_decay, 'g','LineWidth',2);
xlabel('lag l');
ylabel('АКФ');
title('Задание 10: Сравнение АКФ процессов');
legend('Белый шум','RW','RW с затуханием');
grid on;
