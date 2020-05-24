clear;close all;clc

% design parameters
Tp = 10; W = 50; taup = 1;
fs = max(100, 10*W); %set the sampling rate
t = (0:1/fs:Tp)'; % time sampling for the replica

% generate the LFM-pulse complex envelope
s = exp(1i*2*pi*(-t*W/2+(W/(2*Tp)*t.^2)));
figure(1)
plot(t, s)

figure(2)
pspectrum(s, fs, 'spectrogram')
s = s/sqrt(s'*s); % scale the replica so it is a unit length;

% place the replica in the middle of a data sample
x = [zeros(round(fs*taup*1.5),1); s; zeros(round(fs*taup*1.5),1)];

% matched filter the data
y = filter(conj(s(end:-1:1)), 1, x);

figure(3); stem(y)
% remove samples until replica fully overlaps data
y = y(length(s):end);
tau =  (0:length(y)-1)/fs; % delay for each filter output sample
figure(4)
plot(tau, abs(y)); % plot the envelope

figure(5)
plot_freq_spectrum(y, fs, 1, 0, 0, 0, 1)



%%
clear;close all;clc
fs = 160e3;
Np = 1e3;
f0 = 50e3;
Tp = 1/f0;
Ts = Np * Tp;
t =  0:1/fs:Ts-1/fs;

y = chirp(t, -fs, t(end), fs);
figure(1)
plot(t,y)
figure(2)
pspectrum(y, fs, 'spectrogram')


%%
clear; clc; close all;
x = rand(1e2, 1);
y = [rand(1e3, 1);x;rand(1e5,1)];

Y = fft(y);
X = zeros(length(Y), 1);
X(1:length(x)) = fft(x);

Z = Y .* conj(X);
z = real(ifft(Z));
% stem(z)

[s, lags] = xcorr(y, x);

stem(lags, s)



clear;close all;clc;
nSamp = 1024;
Fs = 1024e3;
SNR = 40;
rng default;

t = (0:nSamp - 1)'/Fs;

x = sin(2*pi*t*100.123e3);
x = x + randn(size(x))*std(x)/db2mag(SNR);

[pxx, f] = periodogram(x, kaiser(nSamp, 38), [], Fs);

figure
plot(f, pxx)
figure
powerbw(pxx, f)


%%
clear;close all; clc;

a = 1;
fwind = @hamming;
N = 100;
fc = .25;
b = LowPassFIRFilter(fwind, fc, N);

x = rand(1e3,1);
figure(1)
plot_freq_spectrum(x, 1, 0, 0, 1, 0,1)
y  =  filter(b,a,x);
figure(2)
plot_freq_spectrum(y, 1, 0, 0, 1, 0,1)










