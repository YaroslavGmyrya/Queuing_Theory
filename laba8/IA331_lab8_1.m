%define params
lambda = 5;
u = 15;

% E and D for exp distr
E = 1/lambda;
D = 1/lambda^2;

% coef of using sysytem
p_v = lambda / u;

%params for time serving distr (gamma)
a = 1;
b = 0.2;
N_i = 250;

%exp distr
exp_distr = exprnd(E, 1, N_i);

%gamma distr
MG1_tn = gamrnd(a, b, 1, N_i);

%vector of var
var = [0, 1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
p_v = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];
p_count = length(p_v);

N_q = zeros(p_count, 1);
N = zeros(p_count, 1);
W = zeros(p_count, 1); 
T = zeros(p_count, 1);

for i = 1: length(p_v)
    stats =  MG1_param(MG1_tn, 30, p_v(i));
    N_q(i) = stats.N_q;
    N(i) = stats.N;
    W(i) = stats.W;
    T(i) = stats.T;
end

figure;
subplot(4, 1, 1);
plot(p_v, N_q);
xlabel("p");
ylabel("N_q");
title("Средняя длина очереди в СМО M/G/1");
subplot(4, 1, 2);
plot(p_v, N);
xlabel("p");
ylabel("N");
title("Среднее число заявок в СМО M/G/1");
subplot(4, 1, 3);
plot(p_v, W);
xlabel("p");
ylabel("W");
title("Среднее время ожидания для M/G/1");
subplot(4, 1, 4);
plot(p_v, T);
xlabel("p");
ylabel("T");
title("Среднее время пребывания требования в системе для M/G/1");

%clean vectors
N_q = zeros(p_count, 1);
N = zeros(p_count, 1);
W = zeros(p_count, 1); 
T = zeros(p_count, 1);


for i = 1: length(var)
    stats =  MG1_param(MG1_tn, var(i), lambda/u);
    N_q(i) = stats.N_q;
    N(i) = stats.N;
    W(i) = stats.W;
    T(i) = stats.T;
end

figure;
subplot(4, 1, 1);
plot(var, N_q);
xlabel("c");
ylabel("N_q");
title("Средняя длина очереди в СМО M/G/1");
subplot(4, 1, 2);
plot(var, N);
xlabel("c");
ylabel("N");
title("Среднее число заявок в СМО M/G/1");
subplot(4, 1, 3);
plot(var, W);
xlabel("c");
ylabel("W");
title("Среднее время ожидания в СМО M/G/1");
subplot(4, 1, 4);
plot(var, T);
xlabel("c");
ylabel("T");
title("Среднее время пребывания требования в СМО M/G/1");

%clean vectors
N_q = zeros(p_count, 1);
N = zeros(p_count, 1);
W = zeros(p_count, 1); 
T = zeros(p_count, 1);

MD1_t = 2;

for i = 1: length(p_v)
    stats =  MD1_param(MD1_t, p_v(i));
    N_q(i) = stats.N_q;
    N(i) = stats.N;
    W(i) = stats.W;
    T(i) = stats.T;
end

figure;
subplot(4, 1, 1);
plot(p_v, N_q);
xlabel("p");
ylabel("N_q");
title("Средняя длина очереди в СМО M/D/1");
subplot(4, 1, 2);
plot(p_v, N);
xlabel("p");
ylabel("N");
title("Среднее число заявок в СМО M/D/1");
subplot(4, 1, 3);
plot(p_v, W);
xlabel("p");
ylabel("W");
title("Среднее время ожидания в СМО M/D/1");
subplot(4, 1, 4);
plot(p_v, T);
xlabel("p");
ylabel("T");
title("Среднее время пребывания требования в СМО M/D/1");

%clean vectors
N_q = zeros(p_count, 1);
N = zeros(p_count, 1);
W = zeros(p_count, 1); 
T = zeros(p_count, 1);

for i = 1: length(p_v)
    stats =  MM1_param(exp_distr, p_v(i));
    N_q(i) = stats.N_q;
    N(i) = stats.N;
    W(i) = stats.W;
    T(i) = stats.T;
end

figure;
subplot(4, 1, 1);
plot(p_v, N_q);
xlabel("p");
ylabel("N_q");
title("Средняя длина очереди в СМО M/M/1");
subplot(4, 1, 2);
plot(p_v, N);
xlabel("p");
ylabel("N");
title("Среднее число заявок в СМО M/M/1");
subplot(4, 1, 3);
plot(p_v, W);
xlabel("p");
ylabel("W");
title("Среднее время ожидания в СМО M/M/1");
subplot(4, 1, 4);
plot(p_v, T);
xlabel("p");
ylabel("T");
title("Среднее время пребывания требования в СМО M/M/1");

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