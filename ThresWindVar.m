function [threshold, signal] = ThresWindVar(x, T, G, offset)
%% threshold = CLong(x, T, G, offset) returns the threshold depending on the received 
%% signal property

if iscolumn(x)
    x = x';
end %if

% x = [zeros(1, G+T), x];
x = [ones(1, G+T)*mean(x), x];

Ns = length(x);

threshold = [];
signal = [];

for i = G+T+1:Ns
    noise_level = sqrt(var((x(i-G-T:i-1))));
    
    % calculate the threshold based on cell-averaging technique
    thres = noise_level*offset;
    threshold = [threshold, thres];


    % extract the signal
    sig = x(i);

    if (sig < thres)
        sig = 0;
    end %if
    
    signal = [signal, sig];
    
end

end 
