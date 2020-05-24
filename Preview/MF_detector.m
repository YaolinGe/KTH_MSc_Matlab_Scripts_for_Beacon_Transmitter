clear; clc; close all;


% rng default;
fc = 50e3;              % center frequency, [Hz]
B = 10e3;               % bandwidth, [Hz]
fs = 2 * (fc + B/2);    % sampling rate, [Hz]

Tmax = 5;       % max time lapse
t = (0:1/fs:Tmax)';
Nmax = length(t);
n = (1:Nmax)';

noise = wgn(Nmax, 1, 0);
signal = noise;
plot(n,noise)

ind = round(Nmax * rand()); % indicate where the signal comes in

ms = mseq(2, 5, 1, 1);  % generate original M-sequence signal
replica = conj(flipud(ms)); % generate complex conjugate time reversed replica

% f = 40e3;
% A = 10;
% ms = (A * sin(2*pi*f/fs*(0:1e3) + pi/2))';

assert(ind + length(ms)<Nmax, 'The signal is too long, please make it short');
ms_buried = [zeros(ind, 1); ms; zeros(Nmax-length(ms)-ind,1)];

signal_received = ms_buried + signal;
% stem(signal_received)

[result, lags] = xcorr(signal_received, ms);
plot(lags, result)



% N = pow2(nextpow2(length(signal_received)));
% Y = fft(signal_received, N);
% Y = fftshift(Y);
% power = abs(Y).^2/N;
% f = (-N/2:N/2-1)/N;
% plot(f, power)




















