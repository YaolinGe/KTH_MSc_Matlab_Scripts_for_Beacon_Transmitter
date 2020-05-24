function [hw] = LowPassFIRFilter(wind, fc, N)
%% Usage: function returns the low pass filter coefficients for FIR filter
f = 0:1/N:1-1/N;
F = 12;
w = window(wind, N);
H = ones(N,1);
H(f>fc&f<(1-fc)) = 0;
h = real(fftshift(ifft(H)));
hw = h.*w;
hw = round(hw*2^F)/2^F;
