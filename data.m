clear;close all;clc;
Fs = 160e3;
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'capture.txt'];
y = get_data_sonarfile(filename, 1);
t = (y(13:end))/Fs;
y_re = y(1:2:12);
y_im = y(2:2:12);
z.re = y_re;
z.im = y_im;

figure(1);

% t = (0:length(y)-1)
y1 = get_data_sonarfile('data_500.txt',1);
y1 = y1 - mean(y1);
t1 = (0:200-1)/Fs;
plot(t, absC(z)/max(absC(z))); hold on;
plot(t1, abs(y1(1:200)/max(y1)));


% Fs = 160e3;
% fc = 50e3;
% B = 5e3;
% t = (0:length(y1)-1)/Fs;

% [y1_dc, ts] = signal_dc(y1, fc, Fs, B);
% plot(ts, y1_dc/max(abs(y1_dc)), 'ro-.')


%% 
clear;close all;clc
ADCRES = pow2(12);
INGAIN = .1;

Fs = 160e3; B = 5e3; f0 = 50e3;

dfile = get_data_sonarfile('pwmsig.txt',1);
Npoints = 500;
ADC = transpose(dfile(1:Npoints));
figure(1); subplot(2,1,1); plot(ADC);
ADC = sig2ADC(ADC, ADCRES, INGAIN); ADC = ADC - mean(ADC); subplot(2,1,2); plot(ADC);
Nadc = length(ADC);
ADCpad=filter_prepad(ADC,0,7);
ADCc = re2complex(ADCpad);
Nadcpad = length(ADCpad);

% Downconversion exponential signal
ADCdc.re=sig2FXP(cos(2*pi*(0:Nadcpad-1)*f0/Fs),ADCRES); % 16bit
ADCdc.im=sig2FXP(sin(-2*pi*(0:Nadcpad-1)*f0/Fs),ADCRES); % 16bit
figure(4); subplot(3,1,1);
plot_freq_spectrum(ADC, Fs, 0, 0, 0, 1, 0)

% Downconvert
INdc=mult_complexC(ADCdc,ADCc); % Store in 32 bit
INdc = rescale_minC(INdc, 100);

subplot(3,1,2);
plot_freq_spectrum(INdc.re, Fs,0, 0, 0, 1, 0)

M = 6;
fc = B/Fs;
fs = fc *1.1;
f = [0 fc fs 1];
a = [1 1 0 0];
n = 6;
fircoef = firls(n, f, a);

fircoef_ADC = sig2FXP(fircoef, ADCRES);
fircoef_ADCc = re2complex(fircoef_ADC);
fircoef_ADCc = rescale_minC(fircoef_ADCc, 100);

% filtering operation

INdclp=filterC(INdc,fircoef_ADCc,Nadc,7);
INdclp=rescale_maxC(INdclp,2^15-1);

subplot(3,1,3); plot_freq_spectrum(INdclp.re, Fs, 0, 0, 0, 1, 0)

p = 1;
q = Fs/B;

% Resample the downconverted signal to B sampling rate
INbaseband.re=resample(INdclp.re,p,q);
INbaseband.im=resample(INdclp.im,p,q);
Nsb = length(INbaseband.re);

Fsnew = B;
dtB = 1/B;
dt = 1/Fs;

figure(2);
plot((0:Nadc - 1)*dt, abs(ADC));
hold on;
plot((0:Nadc-1)*dt, absC(rescale_maxC(INdclp, max(abs(ADC)))), '-or');
plot((0:Nsb-1)*dtB, absC(rescale_maxC(INbaseband, max(abs(ADC)))),'-ok');










