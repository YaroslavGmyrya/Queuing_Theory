%define params
lambda = 30;
mu = 40;
n = 6;
m = 10;

%compute mark chain params
rho = lambda/mu;

p0 = 1 / (sum(arrayfun(@(k) rho^k/factorial(k), 0:n-1)) + rho^n/factorial(n) * (1-rho^m)/(1-rho));

P_otk = rho^(n+m)/(n^m*factorial(n)) * p0;

Q = 1 - P_otk;

A = lambda * Q;

k_zan = A / mu;

L_och = (rho^(n+1)/(n*factorial(n))) * (1 - (rho/n)^m * (m+1 - m*rho/n)) / (1 - rho/n)^2 * p0;

T_och = L_och / lambda;

L_sist = L_och + k_zan;

T_sist = L_sist / lambda;

%output result
disp(['rho = ', num2str(rho)]);
disp(['P_otk = ', num2str(P_otk)]);
disp(['Q = ', num2str(Q)]);
disp(['A = ', num2str(A)]);
disp(['k_zan = ', num2str(k_zan)]);
disp(['L_och = ', num2str(L_och)]);
disp(['T_och = ', num2str(T_och)]);
disp(['L_sist = ', num2str(L_sist)]);
disp(['T_sist = ', num2str(T_sist)]);


