%graphical and analytical eq solution


%define function
f = @(x) exp(sin(x) + cos(x));

%define line
k = 4;
b = -2;
line = @(x) k*x + b;

%define arguments

x = -10 : 0.1 : 10;

y_f = f(x);
y_line = line(x);

%graphical solution
figure;
plot(x, y_f, 'r', x, y_line, 'b');
legend('exp(sin(x) + cos(x)', '4x - 2');
grid on;
title('Graphical solution');
xlabel('x');
ylabel('f(x)');

%analytical solution

func = @(x) f(x) - line(x);

sol = fsolve(func, 1);

fprintf("analytical solution: (%f, %f)", sol, line(sol));