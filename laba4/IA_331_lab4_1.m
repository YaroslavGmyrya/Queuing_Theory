%define move matrix
P = [5 5 0 0;
     5 5 0 0;
     3 3 0 0;
     3 3 0 0];

%define mark chain
mc = dtmc(P, 'StateNames', {'Healthy','Unwell','Sick','Very sick'});

%output matrix
disp(mc.P)

%check mark chain
for i = 1:size(mc.P, 1)
    if sum(mc.P(i, :)) ~= 1
        fprintf('ERROR: sum of line number %d != 1 !!!!!!', i);
        break;
    end
end

%build graph
h = graphplot(mc, 'ColorEdges', true);  
saveas(h, 'markov_chain_graph.png');

%define cum matrix
P_cum = cumsum(mc.P, 2);
disp(P_cum);

%define iterations
iterations = [200, 1000, 10000];

%modeling mark chain
for k = 1:length(iterations)

    %define states
    z = zeros(1, iterations(k));
    z(1) = 1;  %start 

    for t = 1:iterations(k) - 1
        %generate random number
        r = rand();  
    
        %compute next state
        z(t+1) = sum(r > P_cum(z(t), :)) + 1;  
    end

    %build graph
    figure;
    plot(1:iterations(k), z);
    xlabel('Итерация t');
    ylabel('Состояние z_t');
    title('Поведение цепи Маркова за 200 итераций');
    grid on;
    
    %saveas(gcf, 'markov_chain_trajectory.png');  % можно использовать .jpg или .fig
    
    P_count = zeros(4, 4);
    
    %count moves
    for t = 1:length(z)-1
        i = z(t);      
        j = z(t+1);   
        P_count(i,j) = P_count(i,j) + 1; 
    end
    
    P_obs = P_count ./ sum(P_count, 2);

    disp(P_obs);
end
