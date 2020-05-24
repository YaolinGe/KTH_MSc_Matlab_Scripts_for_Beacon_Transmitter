function [threshold_cfar, signal_cfar]= CAOS_CFAR(x, T, G, offset)
%% threshold = CAGO_CFAR(x, T, G, offset) returns the threshold based on 
%% Cell-Averaging Greatest Of-CFAR (CAGO-CFAR)

Ns = length(x);

threshold_cfar = [];
signal_cfar = [];

% for i = 1:(Ns-2*(G+T))
for i = G+T+1:(Ns-(G+T))
    
%     training_cells = [x(i:i+T-1); x(i+(T+2*G+1):i+(T+2*G)+T)];
    training_cells = [x(i-G-T:i-1);x(i+G+1:i+(T+G))];
    training_cells = sort(training_cells, 'descend');
    training_cells(1:int16(.001*Ns)) = [];
    
    noise_level = mean(training_cells);

    threshold = noise_level*offset;
    threshold_cfar = [threshold_cfar, {threshold}];
    
    % pick the CUT
    signal = x(i+T+G);
    
    if (signal < threshold)
        signal = 0;
    end %if
    
    signal_cfar = [signal_cfar, {signal}];
    
end %for


end