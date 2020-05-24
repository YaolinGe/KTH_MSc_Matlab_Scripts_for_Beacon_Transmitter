clear;close all;clc;

fs = 160e3;
Np = 1e4;
f0 = 50e3;
Tp = 1/f0;
Ts = Np*Tp;

t = 0:1/fs:Ts-1/fs;
y = chirp(t, 1e-6, t(end), 2*160e3, 'logarithmic');
y = chirp(t, 1e-6, t(end), 2*160e3, 'quadratic');
y = chirp(t, 1e-6, t(end), 2*160e3, 'linear');
% spectrogram(y)

figure(1)
plot(t,y)
figure(2)
pspectrum(y, fs, 'spectrogram')
figure(3)
plot_freq_spectrum(y, fs, 0, 0, 1, 1,1)
