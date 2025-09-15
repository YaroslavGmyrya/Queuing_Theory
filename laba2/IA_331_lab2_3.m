mu = 0;       
sigma = 1;   
lambda = 0.05;

N = [50, 200, 10000];
alpha = [0.1, 0.05, 0.01];

for k = 1:length(N)
    X = exprnd(1/lambda, N(k), 1);

    skew = skewness(X);
    kurt = kurtosis(X);
    fprintf("n = %d\t Skew = %.4f\t Kurt = %.4f\n", N(k), skew, kurt);

    x_sorted = sort(X);
    F = normcdf(x_sorted, mu, sigma);
    cdf_theoretical = [x_sorted, F];

    [h,p,ksstat,cv] = kstest(X, 'CDF', cdf_theoretical, 'Alpha', alpha(k));

    if h == 0
        fprintf('Гипотеза НЕ отклоняется (уровень %.2f): p = %.4f\n', alpha(k), p);
    else
        fprintf('Гипотеза отклоняется (уровень %.2f): p = %.4f\n', alpha(k), p);
    end
    
    fprintf('Статистика D = %.4f, критическое значение = %.4f\n\n', ksstat, cv);
end
