clear; clc; close all;

[y,fs] = audioread('te.wav');
% [y,fs] = audioread('yaolin.m4a');
% sound(y,fs)

figure()
plot(y)


n = pow2(nextpow2(length(y)));
df = fs / n;
f = (-n/2:n/2-1)*df;

Y = fft(y, n);
Y = fftshift(Y);
power = abs(Y).^2/n;
figure()
plot(f, power)

pspectrum(y,fs, 'spectrogram')