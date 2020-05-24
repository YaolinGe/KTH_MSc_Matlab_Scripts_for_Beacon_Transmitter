clear; clc; close all;

% load chirp.mat
% plot(y)

% plot_freq_spectrum(y,Fs, 1)

% snr(y)
% rng default
% Tpulse = 20e-3;
% Fs = 10e3;
% t = -1:1/Fs:1;
% x = rectpuls(t, Tpulse);
% % figure
% % plot(x)
% plot_freq_spectrum(x, Fs, 1)
% y = 0.00001*randn(size(x));
% 
% s = x + y;
% plot_freq_spectrum(s, Fs, 1)
% figure
% plot(t,s)
% % pulseSNR = snr(x, s-x)
% % figure
% snr(x,y)


% powerbw(y)

% plot(20*log(abs(fft(y))))

% plot(y)
% Y = stft(y);


% fs = 1600e3;
% f0 = 50e3;
% f1 = 55e3;
% Np = 100;
% Ts = Np / f0;
% Ns = fs * Ts;
% B = 1/Ts;
% t = ((0:Ns-1)*fs/Ns)';
% 
% phi = 0;
% c = (f1 - f0)/Ts;
% % x_t = sin(phi + 2*pi*(c/2.*t.^2+f0*t));
% x_t = sin(2*pi*(0:Ns-1)'*f1/fs);
% % plot(t,x_t)
% plot_freq_spectrum(x_t, fs, 1)





msq = mseq(2,10,1,1);
s = [zeros(1e3,1);msq;zeros(1e3,1)];

noise = 0.1*wgn(length(s),1,0);
s = s + noise;
% plot(s)
Y = conv(s, conj(flipud(msq)));
plot(Y)

[YY,lags ]= xcorr(s, msq);
figure
plot(lags, YY)
% plot(20*log(abs(fft(msq))));





