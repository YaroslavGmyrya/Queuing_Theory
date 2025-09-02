%plots, diff and integral

%define function
f = @(x) exp(sin(x) + cos(x));

%define arguments
x = -10 : 0.1 : 10;

%define f(x)

y = f(x);

%f(x) plot
figure;
plot(x, y);
title("Function plot")
legend('exp(sin(x) + cos(x))');
xlabel("f");
ylabel("f(x)");
grid on;

%compute f'(x)
y_diff = diff(y) ./ diff(x);  %delta y / delta x = diff

%f'(x) plot
figure;
plot(x(1:end-1), y_diff);
title("Function diff plot");
legend("exp(sin(x) + cos(x))'");
ylabel("f'(x)");
grid on;

%compute integral
f_integral = zeros(1, length(x));

for k = 1:length(x)
    f_integral(k) = integral(f, 0, x(k));
end

%f_integral plot
figure;
plot(x, f_integral);
title("Function integral plot");
legend("exp(sin(x) + cos(x))dx");
xlabel("x");
ylabel("F(x)");
grid on;


