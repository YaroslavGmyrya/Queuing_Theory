% Constant

% Distribution density f(x): (3x^2)/2
% Integral F(x) = (x^3)/2
% (x^3)/2 = z
% x = 2z^(1/3)

%define function
get_rand_num = @(z) (2 * z)^(1/3);

%define selection size
N = [50, 200, 1000];

%define alpha
alpha = [0.1, 0.05, 0.01];

for k = 1: length(N)

    %generate selection
    [selection, theory_mean] = generate_selection(get_rand_num, N(k));
    
    %compute mean and disp
    mean_local = mean(selection);
    disp_local = var(selection);

    %output result
    fprintf("N = %d mean = %f \t theory mean = %f \t disp = %f\n", N(k), mean_local, theory_mean, disp_local);

    for m = 1 : length(alpha)

        %compute mean interval
        student_coeff = tinv(1 - alpha(m)/2, N(k)-1);

        std_disp = sqrt(disp_local);
    
        left_m = mean_local - (student_coeff * (std_disp / sqrt(N(k)))); 
        right_m = mean_local + (student_coeff * (std_disp / sqrt(N(k)))); 

        %compute disp interval
        S2 = sum((selection - mean_local).^2) / (N(k) - 1);
        chi2_l = chi2inv(alpha(m)/2, N(k)-1); 
        chi2_h = chi2inv(1 - alpha(m)/2, N(k)-1);

        left_d = (S2 * (N(k) - 1)) / chi2_h; 
        right_d = (S2 * (N(k) - 1)) / chi2_l; 

    
        fprintf("N = %d  alpha = %f \t mean interval: [%f, %f] \t var interval: [%f, %f]\n", N(k), alpha(m), left_m, right_m, left_d, right_d);

    end

count_of_intervals = floor(1 + 3.2 * N(k));

x_1 = 0:0.01:1.5;
x_2 = 0: 0.01 :1;


f = @(x) (3*x.^2)/2;
F = @(x) (x.^3) / 2;

y_f = f(x_1).*1.6;
y_F = F(x_2).*1.6;

%build plots
figure; 
histogram(selection, 'NumBins', count_of_intervals); 
hold on;
plot(x_1, y_f)
hold off;
title('Гистограмма данных');       
xlabel('Значения');                
ylabel('Количество');               
grid on; 
   
end

y_f = f(x_2).*1.6;

figure;
plot(x_2, y_f, 'r', 'LineWidth', 2); 
hold on;
plot(x_2, y_F, 'b--', 'LineWidth', 2); 
hold off;


%define sub functions
function [selection, theory_mean] = generate_selection(generator, N)
    %define selection
    selection_local = zeros(N, 1);
    
    %define theory mean
    theory_mean = 0;

    %compute random num
    for k = 1 : N
        %generate z
        z = rand();
        
        %compute rand_num
        rand_num = generator(z);

        theory_mean = theory_mean + z * rand_num;

        selection_local(k) = rand_num;
    end

    selection = selection_local;
end






