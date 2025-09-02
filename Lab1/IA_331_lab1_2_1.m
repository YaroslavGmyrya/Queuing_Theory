%define vector size
I = 46;
J = 11;

%call function
[mean_val, disp_val] = my_func(I, J);

%output result
fprintf("mean = %f \t disp = %f", mean_val, disp_val);

%define function
function [mean_val, var_val] = my_func(I, J)
    % define range
    a = -10;
    b = 35;

    % define vectors
    vector_col = (b-a)/2 * rand(I, 1);
    vector_row = (b-a)/2 * rand(J, 1)';

    % multiply vectors
    vector_mul = vector_col * vector_row;

    % compute mean and variance
    mean_val = mean(vector_mul(:));
    var_val = var(vector_mul(:));
end


