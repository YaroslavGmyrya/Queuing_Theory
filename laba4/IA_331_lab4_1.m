%define move matrix
P = [5 5 0 0;
     5 5 3 4;
     3 3 0 0;
     3 3 2 1];

%define markov chain
mc = dtmc(P, 'StateNames', {'Healthy','Unwell','Sick','Very sick'});

%output matrix
disp("Normalized matrix:")
disp(mc.P)

%build graph
h = graphplot(mc, 'ColorEdges', true);  

%define cum matrix
P_cum = cumsum(mc.P, 2);
disp("Cumulative matrix")
disp(P_cum);

%define iterations
N=[200,1000,10000]; 

%markov chain modeling
figure;
for m = 1:length(N)

    % allocate memory
    z = zeros(N(m), 1);

    %define start value
    z(1) = 1;
    
    %generate vector of numbers from uniformity distribution
    r = rand(N(m), 1);
    
    for i = 2:N(m)
        k = 1;
        %compute new state
        while r(i-1) > P_cum(z(i-1), k)
            k = k + 1;
        end
        %save state 
        z(i) = k;
    end
    
    %build plot
    subplot(length(N), 1, m)
    title(sprintf("Markov modeling N = %d", N(m)));
    xlabel("Time samples");
    ylabel("State")
    plot(z);
 
    
    %allocate memory
    P_obs = zeros(4,4);
    
    %compute estimate for markov chain
    for n = 2:N(m)          
        prev = z(n-1);  
        curr = z(n);     
        P_obs(prev, curr) = P_obs(prev, curr) + 1;
    end
    
    %normalazing matrix
    for row = 1: size(P_obs, 2)
        s = 0;
        for col = 1: size(P_obs, 1)
            s = s + P_obs(row, col);
        end
        
        for col = 1: size(P_obs, 1)
            P_obs(row, col) = P_obs(row, col) / s;
        end
    end
    
    %final matrix
    fprintf("N = %d\n", N(m));
    disp(P_obs)

end



