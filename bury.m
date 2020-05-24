function [y, t] = bury(x, fs)
y = [zeros(1, 2*length(x)), x, zeros(1, 2*length(x))];
y = y + wgn(1, length(y), 0);
% y = [wgn(1, 2*length(x),0), x, wgn(1, 2*length(x),0)];
t = (0:length(y)-1)/fs;
end