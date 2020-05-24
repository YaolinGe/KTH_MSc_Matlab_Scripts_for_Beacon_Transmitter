clear; close all; clc;

fs = 160e3;
t = 0:1/fs:1-1/fs;

a = .2.^t;
phi = 2*pi*35*t;
fc = 20e3;
s = a .* sin(2*pi*fc*t +  phi);

plot_freq_spectrum(s, fc, 1, 0, 1)
figure
pspectrum(s,fs)