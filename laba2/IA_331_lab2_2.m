%descrete 

%define arguments
x = 0 : 100;

%define descrete distr
f = @(x) (0.1) * (1 - 0.1).^x;

%function values
X = f(x);

%define selection size
N = [50, 200, 1000];

%define alpha
alpha = [0.1, 0.05, 0.01];

for k = 1: length(N)

    %define selection
    selection = zeros(N(k), 1);
    
    %generate numbers
    for i = 1: N(k)
        selection(i) = generate_rand_num(X, x);
    end
    
    %compute mean and disp
    mean_local = mean(selection);
    disp_local = var(selection);

    %output result
    fprintf("N = %d mean = %f \t disp = %f\n", N(k), mean_local, disp_local);

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

figure; 
histogram(selection, 'NumBins', count_of_intervals); 
hold on;
plot(x, X.*N(k))
title('Гистограмма данных');       
xlabel('Значения');                
ylabel('Количество');               
grid on;  

end


%sub function
function [rand_num, theory_mean] = generate_rand_num(X, x)
    rand_num = 0;
    theory_mean = 0;

    %generate z
    z = rand();
    s = z;
    %find interval
    for i = 1 : length(X)
        s = s - X(i);

        if s < 0
            rand_num = x(i);
            theory_mean = theory_mean + z * rand_num;
            break;
        end
    end
end
