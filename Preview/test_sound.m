clear; clc; close all;

% t = 0:0.01:1; k = 1:3;
% xt = (1./k)*sin(2*pi*k'*t);
% % plot(xt)
% 
% stem(t, xt, 'k', 'filled')
% hold on
% plot(t, xt,'k')


load chirp.mat

% sound(y,Fs)


n = (0:length(y)-1)';
t = n/Fs;

plot(y)
hold on
N = round(0.8*Fs);
yy = [zeros(N, 1);y];
y = 0.5* [y;zeros(N,1)];
y = y + yy;
plot(y)
sound(y,Fs)



%% ECHO GENERATION & CORRUPTION

clear; clc; close all;
load handel;
alpha = 0.9; D = 4196;
b = [1, zeros(1,D), alpha];
x = filter(b, 1, y);
% Fs
% plot(y)
% 
% plot_freq_spectrum(x,Fs,1)

sound(x,Fs)
w = filter(1,b,x);
sound(w, Fs)



%%

clear; clc; close all;
load chirp.mat

Fs
alpha = 0.3;
D = 4196;
b = [1,zeros(1,D), alpha];
x = filter(b,1,y);
plot(y); hold on; plot(x)

%% REVERBERATION
close all; clc; clear;
load handel;

alpha = 0.3;
D = 4196;
b = [alpha, zeros(1, D), 1];
a = [1, zeros(1, D), -alpha];

x = filter(b, a, y);
subplot(2,1,1);
plot(y)
subplot(2,1,2);
plot(x)
sound(y, Fs)

%%
clear; close all; clc
% more advanced model for reverberation
D = 4196;
k = 1:3;
alpha = 0.9;
N = 4;
% b = zeros(N,1);
b = [];
for i = 1:N-1
    tmp(i) = alpha^(i-1);
    b = [b, tmp, zeros(1,D)];
end
tmp(i) = alpha^(i);
b = [b, tmp(i)];
a = 1;
load handel;
% plot(y)
x = filter(b,a,y);
% plot(x)
sound(x,Fs)


%% periodogram
clear; close all; clc
rng default
Fs = 1000;
t = 0:1/Fs:1-1/Fs;
x = cos(2*pi*100*t) + randn(size(t));

% plot_freq_spectrum(x, Fs, 1)
N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N))*abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(x):Fs/2;
plot(freq, 10*log10(psdx));
grid on; grid minor; box on;
title('Periodogram using FFT');
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')



%% elegant indexing of long column vector
clear; close all; clc
x = rand(1,10);
P = 10;
xtilde = x'*ones(1,P);
xtilde = xtilde(:);
xtilde = xtilde';
plot(xtilde)

%%

clear; clc; close all;
a = randn(7);
a = a(:);
plot(a)

%% signal manipulation
n = [-5:5];
x = 2 * impseq(-2, -5, 5) - impseq(4, -5, 5);
stem(n,x)






















