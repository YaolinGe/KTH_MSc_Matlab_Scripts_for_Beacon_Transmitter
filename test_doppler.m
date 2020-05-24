clear;close all;clc;

Fs = 160e3;
fc = 30e3;
N = 100;
t = (0:N-1)/Fs;
y = exp(1i*2*pi*fc*t);
plot(t, y)


pspectrum(y, Fs)


vs = 100;
c = 343;
f = (c+0)/(c+vs)*fc;
y = exp(1i*2*pi*f*t);
hold on;
pspectrum(y, Fs)


y = chirp(t, 0, t(end), fc);
figure
pspectrum(y, Fs)


y = chirp(t, f, t(end), f);
% figure
hold on;
pspectrum(y, Fs, 'power')


% [p, f, t] = pspectrum(y, Fs, 'spectrogram');
% waterfall(f, t, p');
% xlabel('Frequency (Hz)')
% ylabel('Time (seconds)')
% wtf = gca;
% wtf.XDir = 'reverse';
% view([30 45])