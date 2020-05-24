function [y,t] = sig_shift(x, fc,fs)
t = (0:length(x)-1)/fs;
y = exp(-1i*2*pi*fc*t).*x;