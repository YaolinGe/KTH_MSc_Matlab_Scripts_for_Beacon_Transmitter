function [hw] = BandPassFIRFilter(win, fL, fH, N)
%% Usage: function returns the bandpass FIR filter to conduct the bandpassing work
F = 12; % fixed bit

w = window(win, N);
H = ones(N, 1);
f = 0:1/N:1-1/N;
H(f<fL|f>fH) = 0;
h = real(ifft(H));
h = fftshift(h);
hw = h.*w;
hw = round(hw*pow2(F))/pow2(F);
