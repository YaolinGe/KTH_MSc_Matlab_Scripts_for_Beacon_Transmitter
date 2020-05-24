clear;close all;clc;

y = data_acquisition('DB_test', 'WAVEFORM');
y_w = data_acquisition('DB_test', 'WAVEFORM_W');
% y = y(1:34);

% y_w = y_w(1:34);
subplot(3,1,1);
plot(y)

% ylim([0, 5000])
subplot(3,1,2);
plot(y_w)

fc = 47e3;
Fs = 160e3;
np = 10;
T = 1/fc;
Tp = np * T;
Np = Tp * Fs;

t = (0:Np-1)/Fs;
y_ref = sin(2*pi*fc * t);
y_ref = y_ref';
subplot(3,1,3);
plot(y_ref)


%% chirp ref signal generation 
clear;close all;clc;

y = data_acquisition('DB_test', 'WAVEFORM');
y_w = data_acquisition('DB_test', 'WAVEFORM_W');
y = y(1:34);
y_w = y_w(1:34);

f1 = 44.5e3;
f2 = 49.5e3;

subplot(3,1,1);
plot(y)

% ylim([0, 5000])
subplot(3,1,2);
plot(y_w)

np = 10;
fc = 47e3;

T = 1/fc;

Fs = 160e3;

Tp = np * T;
Np = Tp * Fs;

t = (0:1e6-1)/Fs;
y_ref = chirp(t, f1, t(end), f2);
y_ref = y_ref';
subplot(3,1,3);
plot(y_ref)

figure
pspectrum(y_ref,1e3,'spectrogram','TimeResolution',0.002, ...
    'OverlapPercent',50,'Leakage',0.15)
