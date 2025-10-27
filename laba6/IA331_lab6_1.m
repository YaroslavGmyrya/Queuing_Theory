%define params for exp distr

lambda = 5;
u = 15;

%compute E and D for exp distr

E = 1/lambda;
D = 1/lambda^2;

% find d for chi^2 distr

d = 0.11;


% define chi^2 distr sequence

N = 250;

chi_seq = chi2rnd(d, N, 1);
exp_seq1 = exprnd(E, N, 1);
exp_seq2 = exprnd(E, N, 1);

chi_E = sum(chi_seq)/N;
chi_D = sum(chi_seq .^ 2)/N - chi_E^2;

exp_E = sum(exp_seq)/N;
exp_D = sum(exp_seq.^2)/N - exp_E^2;

fprintf("Theory stats: \n");
fprintf("Exp disrt: E = %f  D = %f\n", E, D);
fprintf("Chi^2 disrt: E = %f  D = %f\n", d, 2*d);

fprintf("Real stata: \n");
fprintf("Exp disrt: E = %f  D = %f\n", exp_E, exp_D);
fprintf("Chi^2 disrt: E = %f  D = %f\n", chi_E, chi_D);


