clear;close all;clc

fs = 160e3;
fc = 50e3;
dt = 1/fs;
B =  5e3;
Np = 100;
Ts = Np/fc;
t = 0:dt:Ts-dt;
x = sin(2*pi*fc*t);

figure(1)
plot(t, x)
figure(2)
plot_freq_spectrum(x, fs, 0, 0, 0, 1, 1)
noise = wgn(1,2*length(x), 0);
y = [noise, x, noise];


% t = (0:length(x)-1)/fs;
% x = x.*exp(-1i*2*pi*fc*t);

[x,t] = sig_shift(x, fc, fs);
[y,ty] = sig_shift(y, fc, fs);

figure(3)
plot_freq_spectrum(x, fs, 1, 0, 0, 0, 0)

x = LP(x, 1);
y = LP(y, 1);


figure(4); subplot(2, 1,1); plot(t, x);
subplot(2,1,2); plot_freq_spectrum(x, fs, 1,0,0,0,0)

Fs = B;
p = 1;
q = floor(fs/B);
x = resample(x, p, q);
y = resample(y, p, q);
t = (0:length(x)-1)/Fs;
ty = (0:length(y)-1)/Fs;
figure(5); subplot(2, 1,1); plot(t, x);
subplot(2,1,2); 
scorr = conv(y, conj(fliplr(x)));
plot((0:length(scorr)-1)*1/Fs,abs(scorr)*max(abs(x))/max(abs(scorr)),'o-k');

figure(6);
plot_freq_spectrum(x, fs, 1,0,0,0,0)

% create time signal










