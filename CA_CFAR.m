function [threshold_cfar, signal_cfar]= CA_CFAR(x, T, G, offset)
%% threshold = CA_CFAR(x, T, G, offset) returns the threshold based on 
%% cell-averaging CFAR

if iscolumn(x)
    x = x';
end %if

x = [zeros(1, T+G), x, zeros(1, T+G)];
Ns = length(x);
threshold_cfar = [];
signal_cfar = [];

% for i = 1:(Ns-2*(G+T))
for i = G+T+1:(Ns-(G+T))
    
%     noise_level = sqrt(var([y(i:i+T-1);y(i+(T+2*G+1): i+(T+2*G)+T)]));
%     noise_level = sum([x(i:i+T-1);x(i+(T+2*G+1): i+(T+2*G)+T)]);
    noise_level = sqrt(var(([x(i-G-T:i-1), x(i+G+1:i+(T+G))])));
%     noise_level = sum([x(i-G-T:i-1), x(i+G+1:i+(T+G))])/2/T;

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