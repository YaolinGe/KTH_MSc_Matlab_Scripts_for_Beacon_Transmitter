clear; clc; close all;

fs = 44100;
t = 0:1/fs:2;
N_sample = length(t);
noise = rand(N_sample,1)-0.5;
% plot(t,noise)

% sound(noise, fs)
n = pow2(nextpow2(N_sample));
X = xcorr(noise,noise);
X = fftshift(X);
figure();
grid on; grid minor; box on;
plot(X)
xlabel('');
ylabel('');
title('');
legend('','');

Y = fft(X, n);
Y = fftshift(Y);
f = (-n/2:n/2-1)*(fs/n);
power = abs(Y).^2/n;
figure()
plot(f, power)
yline(sqrt(var(Y)))