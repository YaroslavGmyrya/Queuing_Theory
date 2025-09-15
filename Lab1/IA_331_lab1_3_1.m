%define network size
L = 15;

%create move matrix 
move_matrix = zeros(L, L);

%set non-zero variables
move_matrix(1,1) = 0.1;
move_matrix(1,6) = 0.4;
move_matrix(1,7) = 0.5;

move_matrix(2,4) = 0.2;
move_matrix(2,8) = 0.3;
move_matrix(2,9) = 0.1;
move_matrix(2,10) = 0.4;

move_matrix(3,10) = 0.66;
move_matrix(3,11) = 0.12;
move_matrix(3,15) = 0.22;

move_matrix(4,8) = 0.2;
move_matrix(4,11) = 0.35;
move_matrix(4,13) = 0.45;

move_matrix(5,1) = 0.5;
move_matrix(5,11) = 0.3;
move_matrix(5,12) = 0.2;

move_matrix(6,2) = 0.4;
move_matrix(6,5) = 0.3;
move_matrix(6,13) = 0.3;

move_matrix(7,1) = 0.2;
move_matrix(7,9) = 0.46;
move_matrix(7,15) = 0.34;

move_matrix(8,5) = 0.26;
move_matrix(8,6) = 0.32;
move_matrix(8,14) = 0.42;

move_matrix(9,3) = 0.1;
move_matrix(9,7) = 0.1;
move_matrix(9,14) = 0.8;

move_matrix(10,4) = 0.1;
move_matrix(10,6) = 0.6;
move_matrix(10,9) = 0.3;

move_matrix(11,10) = 0.22;
move_matrix(11,13) = 0.3;
move_matrix(11,15) = 0.48;

move_matrix(12,2) = 0.44;
move_matrix(12,7) = 0.36;
move_matrix(12,12) = 0.2;

move_matrix(13,12) = 0.2;
move_matrix(13,13) = 0.6;
move_matrix(13,14) = 0.2;

move_matrix(14,7) = 0.12;
move_matrix(14,12) = 0.5;
move_matrix(14,15) = 0.38;

move_matrix(15,11) = 0.5;
move_matrix(15,13) = 0.4;
move_matrix(15,15) = 0.1;

%output result
fprintf("stochastic = %d\n", stochastic(move_matrix));

fprintf("ergodic = %d\n", ergodic(move_matrix, 10 ^ -5));

mc = dtmc(move_matrix);
h = graphplot(mc, 'ColorEdges', true);  


%define functions
function is_stochastic = stochastic(matrix)
    is_stochastic = true;
    
    %take row from matrix
    for i = 1:size(matrix,1)   
        row = matrix(i,:);
        sum = 0;
        
        %sum all elements in row
        for k = 1:length(row)
           sum = sum + row(k); 
        end
        
        %check condition
        if sum ~= 1
            is_stochastic = false;
        end
    end
end

function is_ergodic = ergodic(matrix, eps)
    is_ergodic = true;
    
    %start probability
    pi0 = rand(1, 15);      
    pi0 = pi0 / sum(pi0); 
    
    %mul move_matrix with pi0
    for i = 1:200
        pi0 = pi0 * matrix;
    end
    
    %check condition
    for i = 1:length(pi0)
        if pi0(i) < eps
            is_ergodic = false;
        end
    end
end
