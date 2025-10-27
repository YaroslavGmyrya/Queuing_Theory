% Задание: проделать то же самое для систем M/D/1 и M/G/1, G/M/1, G/G/1.
% Для G/G/1, G/M/1 нет формул для расчета характеристик, поэтому можно просто
% построить графики. В случае M/D/1 распределение времени
% обслуживания детерминировано, т.е является константой. Функции для расчета параметров для систем M/D/1 и M/G/1 уже
% написаны. Для удобства можно оформить код выше в одну функцию, куда будут
% подаваться распределения времени обслуживания и времени поступления
% заявок.

%% Параметры СМО
lambda = 8; %интенсивность поступления заявок (заявок в единицу времени)
u = 15; % интесивность обслуживаниия (заявок в единицу времени)
p = lambda / u; %коэффициент загруженности СМО

N = 1000; % кол-во заявок


% lambda > u - условие стационарности системы (в ином случае сисетма не
% стабильна, т.к заявок в единицу времени больше, чем СМО может обслужить в единицу времени)

%% Расчет характеристик для системы MM1
E = 1/u;
% распределение обслуживания заявок
MM1_vn = exprnd(E, 1, N);
k = 8;
theta = E / k;
MG1_vn = gamrnd(k, theta, 1, N);

% распределение поступления заявок 
MM1_tn = exprnd(1/lambda, 1, N);

sigma = 1;
mu = log(E) - (sigma^2) / 2;
GG1_tn = lognrnd(mu, sigma, 1, N);

% t = system_param(MM1_tn, MM1_vn, "M/M/1");
% t = system_param(MM1_tn, MG1_vn, "M/G/1");
% t = system_param(MM1_tn, MG1_vn, "G/M/1");
t = system_param(GG1_tn, MG1_vn, "G/G/1");

%расчет параметров
params = MM1_param(MM1_vn, p);
fprintf("MM1:\n\nAvg queue len(N_q): \t %f\nAvg tasks count in system(N): \t %f\nAvg waiting time(W): \t %f\nAvg time task into system(T): \t %f\n\n", params.N_q, params.N, params.W, params.T);
params = MG1_param(MG1_vn, 1, p);
fprintf("MG1:\n\nAvg queue len(N_q): \t %f\nAvg tasks count in system(N): \t %f\nAvg waiting time(W): \t %f\nAvg time task into system(T): \t %f\n\n", params.N_q, params.N,params.W, params.T);


function stats = MG1_param(tn, c, p)
    %N_q - avg queue len
    %N - avg tasks count in system
    %W - avg waiting time 
    %T - avg time task into system
    %t_n - set of time serving

    %avg time serving
    avg_tn = mean(tn);

    %compute params
    stats.N_q = p^2 * (1 + c) / (2*(1-p));
    stats.N = p + stats.N_q;
    stats.W = p * avg_tn * (1 + c) / (2*(1-p));
    stats.T = avg_tn + stats.W;

end


function stats = MD1_param(t, p)
    %N_q - avg queue len
    %N - avg tasks count in system
    %W - avg waiting time 
    %T - avg time task into system
    %t - time serving

    %compute params
    stats.N_q = p^2 * 1 / (2*(1-p));
    stats.N = p + stats.N_q;
    stats.W = p * t / (2*(1-p));
    stats.T = t*(1 - p) / (2 * (1 - p));
end

function stats = MM1_param(tn, p)
    %N_q - avg queue len
    %N - avg tasks count in system
    %W - avg waiting time 
    %T - avg time task into system
    %t_n - set of time serving

    %avg time serving
    avg_tn = mean(tn);

    %compute params
    stats.N_q = p^2/(1-p);
    stats.N = p / (1 - p);
    stats.W = stats.N * avg_tn;
    stats.T = avg_tn / (1-p);
end

function t = system_param(tn, vn, type)
    
    %сортируем и накапливаем сумму
    vn = cumsum(vn);
    tn = cumsum(tn);
    
    %визуализация
    figure;
    plot(tn, 0:1:(length(tn) - 1));
    hold on;
    plot(vn, 0:1:(length(vn) - 1));
    title(sprintf("Зависимость числа пришедших/обработанных заявок от времени (%s)", type));
    xlabel("Время,с");
    ylabel("Кол-во заявок,шт");
    hold off;
    grid on;
    legend("Пришедшие заявки", "Обслуженные заявки");
    
    % кол-во заявок в системе
    tasks_in_system = zeros(length(vn), 1);
    
    for i = 1:length(vn)
        tasks_in_system(i) = vn(i) - tn(i) ; 
    end
    
    figure;
    plot(vn, tasks_in_system);
    title(sprintf("Зависимость кол-ва заявок в системе от времени (%s)", type));
    xlabel("Время,с");
    ylabel("Кол-во заявок,шт");
    t = 1;
end
