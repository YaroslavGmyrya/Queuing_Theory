%3D function


%define function
f = @(x, y) 1./(x.^3) + 1./(y.^3);

%define arguments

x = -10:0.1:10;   
y = -10:0.1:10;   

%create matrix
[x_matrix, y_matrix] = meshgrid(x, y);

%compute f(x)
f_z = f(x_matrix, y_matrix);

%build plot
figure;
surf(x_matrix, y_matrix, f_z);

title('f(x,y) = 1/(x^3) + 1 / (y^3)');
legend('1/(x^3) + 1 / (y^3)');
xlabel('x');
ylabel('y');
zlabel('f(x,y)');
colorbar;       

