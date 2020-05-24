function [Xk] = dft(xn, N)
%compute discrete Fourier transform
n = [0:1:N-1];
k = [0:1:N-1];
WN = exp(-j*2*pi/N);
nk = n'*k;
WNnk = WN .^nk;
Xk = xn *  WNnk;
