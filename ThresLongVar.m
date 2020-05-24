function [threshold, signal] = ThresLongVar(x, offset)
%% threshold = Varlong(x) returns the long duration estimate on the noise poowr 
%% i.e. the variance of the background noise so to determine the threshold
Ns = length(x);

noise_level = sqrt(var(x));
threshold = (noise_level * offset) * ones(1, Ns);

signal = x;
signal(signal<threshold) = 0;

end %Varlong