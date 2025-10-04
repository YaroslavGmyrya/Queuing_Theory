%define network size
L = 15;

%create move matrix 
P = zeros(L, L);

%set non-zero variables
P(1,1) = 0.1;
P(1,6) = 0.4;
P(1,7) = 0.5;

P(2,4) = 0.2;
P(2,8) = 0.3;
P(2,9) = 0.1;
P(2,10) = 0.4;

P(3,10) = 0.66;
P(3,11) = 0.12;
P(3,15) = 0.22;

P(4,8) = 0.2;
P(4,11) = 0.35;
P(4,13) = 0.45;

P(5,1) = 0.5;
P(5,11) = 0.3;
P(5,12) = 0.2;

P(6,2) = 0.4;
P(6,5) = 0.3;
P(6,13) = 0.3;

P(7,1) = 0.2;
P(7,9) = 0.46;
P(7,15) = 0.34;

P(8,5) = 0.26;
P(8,6) = 0.32;
P(8,14) = 0.42;

P(9,3) = 0.1;
P(9,7) = 0.1;
P(9,14) = 0.8;

P(10,4) = 0.1;
P(10,6) = 0.6;
P(10,9) = 0.3;

P(11,10) = 0.22;
P(11,13) = 0.3;
P(11,15) = 0.48;

P(12,2) = 0.44;
P(12,7) = 0.36;
P(12,12) = 0.2;

P(13,12) = 0.2;
P(13,13) = 0.6;
P(13,14) = 0.2;

P(14,7) = 0.12;
P(14,12) = 0.5;
P(14,15) = 0.38;

P(15,11) = 0.5;
P(15,13) = 0.4;
P(15,15) = 0.1;

%output result
fprintf("stochastic = %d\n", stochastic(P));

fprintf("ergodic = %d\n", ergodic(P, 10 ^ -5));

%create and output graph
mc = dtmc(P);
figure;
h = graphplot(mc, 'ColorEdges', true);  

%modelation markov chain
N = 400;
start = 1;
E = MarkovTrajectory(P, N, start);

%create and show plot
t = 0 : 1 : N;

figure;
plot(t, E);

P_m = zeros(L, 1);
f = zeros(L, 1);
min_l = zeros(L, 1);
M_E = zeros(L, 1);
D_E = zeros(L, 1);

for i = 1 : L
    P_m(i) = func_1(P, 4, 13, i);
    f(i) = func_2(P, 4, 13, i);
    min_l(i) = min_len(P, 13, i);
    M_E(i) = M(P, 13, i);
    D_E(i) = D(P, 13, i);
end

figure;

subplot(3,1,1)
plot(1:L, P_m, 'b-o')
title("Вероятность перехода за 4 шага из 2 в L")
xlabel("L")
ylabel("P")

subplot(3,1,2)
plot(1:L, f, 'r-o')
title("Вероятность первого перехода за 4 шага из 2 в L")
xlabel("L")
ylabel("P")

subplot(3,1,3)
plot(1:L, min_l, 'g-o')
title("Минимальный путь из 2 в L")
xlabel("L")
ylabel("l")

figure;

subplot(2,1,1)
plot(1:L, M_E, 'b-o')
title("Мат.ожидание пути из 2 в L")
xlabel("L")
ylabel("M")

subplot(2,1,2)
plot(1:L, D_E, 'r-o')
title("Дисперсия пути из 2 в L")
xlabel("L")
ylabel("D")

%define functions
function is_stochastic = stochastic(matrix)
    is_stochastic = true;
    
    %take row from matrix
    for i = 1:size(matrix,1)   
        row = matrix(i,:);
        sum = 0;
        
        %sum all elements in row
        for k = 1:length(row)
           sum = sum + row(k); 
        end
        
        %check condition
        if sum ~= 1
            is_stochastic = false;
        end
    end
end

function is_ergodic = ergodic(matrix, eps)
    is_ergodic = true;
    
    %start probability
    pi0 = rand(1, 15);      
    pi0 = pi0 / sum(pi0); 
    
    %mul move_matrix with pi0
    for i = 1:200
        pi0 = pi0 * matrix;
    end
    
    %check condition
    for i = 1:length(pi0)
        if pi0(i) < eps
            is_ergodic = false;
        end
    end
end

function E = MarkovTrajectory(P, N, s)
    % Функция для расчета траектории движения пакета по сети
    % P - матрица переходов
    % N - количество шагов
    % s - начальное состояние
    % Возвращает E - массив состояний пакета на каждом шаге
    
    % Инициализация
    E = zeros(1, N + 1); % Хранение траектории
    E(1) = s;    % Начальное состояние
    S = size(P, 1);    % Количество состояний в матрице P
    
    % Цикл по шагам
    for i = 1:N
    r = rand(); % Генерация случайного числа от 0 до 1
    cumulativeProb = 0; % Кумулятивная вероятность
    
    % Поиск следующего состояния
    for j = 1:S
        cumulativeProb = cumulativeProb + P(E(i), j); % Обновляем сумму вероятностей
        if r < cumulativeProb
            E(i + 1) = j; % Переход в состояние j
            break;
        end
    end
end
end

%Вероятность пребывания пакета в узле j после m коммутаций,
%при условии, что пакет поступил в сеть через узел i
function res = func_1(P, m, i, j)
    P = P^m;         
    res = P(i, j); 
end

%Вероятность первого перехода пакета в узел j из узла i после m коммутаций.
function res = func_2(P, m, i, j)
    k = 0;
    cum_mul = 1;
    P_tmp = P;
    while k < m - 1
        cum_mul = cum_mul * (1 - P_tmp(i,j));
        P_tmp = P_tmp * P; 
        k = k + 1;
    end
    if m > 1
         P_tmp = P_tmp * P;
    end
   
    res = P_tmp(i,j) * cum_mul;
end

function res = min_len(P, i, j)
    m = 1;
    while P(i,j) == 0
        P = P * P; 
        m = m + 1;
    end
    res = m;
end

function res = M(P, i, j)
    m = 1;
    max_m = 200;
    res = 0;
    while m <= max_m
        f = func_2(P, m, i, j);
        res = res + m * f;
        m = m + 1;
    end
end

function res = D(P, i, j)
    m = 1;
    max_m = 500;
    res = 0;
    while m <= max_m
        f = func_2(P, m, i, j);
        res = res + m^2 * f;
        m = m + 1;
    end

    res = res - M(P, i, j)^2;
end