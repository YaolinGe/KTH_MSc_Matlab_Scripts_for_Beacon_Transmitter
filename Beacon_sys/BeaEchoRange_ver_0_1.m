clear; clc; close all;

fs = 160e3;
fc = 50e3;
a = 1;
Np = 10;
phi = 0;
shift = 1;  %  shift index
I = 1;  % random index
Nmax = 1e4;     % assume long receiving process
Nbuffer = 100; % buffer  length
Ts = Np/fc;
B = 1/Ts;   %bandwidth
scale = 12;  % magic number
vsound = 1500;


[t,y] = pulse(Np, a, fs, fc, phi);
figure(1)
plot(t,y)

plot_freq_spectrum(y, fs, shift)
[t,y_received] = received_signal(fs, y, Nmax, I);
figure
plot(t,y_received)
[y_dc,fs_dc] = downconvert(y_received, fc, fs, B);
shift = 0;
% plot_freq_spectrum(y_dc, fs_dc, shift,0,0,1)
% [y_ref, fs_ref] = downconvert(y, fc, fs, B);
y_dc = y_received;
fs_dc = fs;


figure
plot((0:length(y_dc)-1),y_dc)
% figure
plot_freq_spectrum(y_dc, fs_dc, shift)

ind = MF_detector(y, y_dc, scale);
range = t(ind) * vsound /2


%% following action pulse back


function [t,y] = pulse(Np, a, fs, fc, phi)
%% usage: y = pulse(Np, a, fs, fc, phi);
%% generates s sinusoidal waveform which has the expression as follows:
%%      y = a * sin(2*pi*fc/fs*t+phi)

Ts = Np / fc;
Ns = Ts * fs;
n = (0:Ns-1)';
t = n*fc/fs;
y = a * sin(2*pi*n.*fc/fs+phi);

end %pulse




