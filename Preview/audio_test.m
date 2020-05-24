clear; close all; clc;

device = audiodevinfo;

r1 = audiorecorder(44100, 16, 1, 1);
r2 = audiorecorder(48000, 16, 1, 4);


disp('start recording');
recordblocking(r1, 2);
recordblocking(r2, 2);
disp('end of recording');

% play(audio_obj);
y1 = getaudiodata(r1);
y2 = getaudiodata(r2);
% plot(y1)
% figure()
% plot(y2)
% play(r1)
% play(r2)

%%
load chirp.mat;
% sound(y,Fs);

% load gong.mat;
gong = audioplayer(y,Fs);
play(gong);


%%

[r3, Fs] = audioread('matlab_tteset.m4a');
figure()
plot(r3)
rp = audioplayer(r3,Fs);
play(rp)
y = r3 + 2.5 * gallery('normaldata', size(r3), 4);
Y = fft(r3);
Y = fftshift(Y);
n = length(r3);
f = (-n/2:n/2-1)*(Fs/n);
power = abs(Y).^2/n;
figure()
plot(f, power);
xlabel('Frequency')
ylabel('Power')



% n = length(r3);
% N = pow2(nextpow2(n));
% 
% Y = fft(r3, N);
% df = 1/N;
% f = (-(N-1)/2:df:(N-1)/2);
% plot(Y)



%% generatee a sound
A = 10;
Fs = 16e3;
t_tot = 1;
f = 1000;
t = 0:1/Fs:t_tot;
y = A * sin(2*pi*f*t);
% plot(t, y)

% 
% N = pow2(nextpow2(length(y)));
% Y = fft(y, N);
% Y = fftshift(Y);
% F = (-N/2:N/2-1)*(Fs/N);
% p = abs(Y).^2/N;
% plot(F, p)


% Y = dwt(y)



%% LPC


clear; clc; close all;

load mtlb;
segmentlen = 100;
noverlap = 90;
NFFT = 128;
spectrogram(mtlb,segmentlen,noverlap,NFFT,Fs,'yaxis')
title('Signal Spectrogram')



%%  autocorrelation
clear; clc; close all;

load officetemp;

Tmp = (temp - 32)*5/9;
Tmp_norm = Tmp - mean(Tmp);
fs = 2* 24;
t = (0:length(Tmp_norm)-1)/fs;
plot(t, Tmp_norm)
% tempC = te

%%
clear; clc; close all;

[y,fs] = audioread('whistle.m4a');
plot(y)

sound(y,fs)
plot_freq_spectrum(y,fs,1)


%%

















