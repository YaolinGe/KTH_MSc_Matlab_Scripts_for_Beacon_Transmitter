function [threshold_cfar, signal_cfar]= CAGO_CFAR(x, T, G, offset)
%% threshold = CAGO_CFAR(x, T, G, offset) returns the threshold based on 
%% Cell-Averaging Greatest Of-CFAR (CAGO-CFAR)

Ns = length(x);

threshold_cfar = [];
signal_cfar = [];

% for i = 1:(Ns-2*(G+T))
for i = G+T+1:(Ns-(G+T))
    
    noise_level_left = sum(x(i-G-T:i-1))/T;
    noise_level_right = sum(x(i+G+1:i+(T+G)))/T;
    noise_level = max(noise_level_left, noise_level_right);

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