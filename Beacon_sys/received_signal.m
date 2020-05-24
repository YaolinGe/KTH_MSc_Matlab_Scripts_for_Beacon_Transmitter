function [t,y] = received_signal(fs, yref, Nmax, I)
%% [t, y] = received_signal(fs, yref, Nmax, I)
%% returns the synthetic signals received by the ADC

if I
    rng default;
end %if

ind = round(Nmax*rand());  % generate random index for which the signal is buried
if length(yref) + ind > Nmax
    ind = Nmax - length(yref);
end

noise = wgn(Nmax, 1, 0)*.1;
y = [zeros(ind, 1); yref; zeros(Nmax-length(yref)-ind,1)];
t = (0:Nmax-1)/fs;
y = y + noise;


end %received_signal
    