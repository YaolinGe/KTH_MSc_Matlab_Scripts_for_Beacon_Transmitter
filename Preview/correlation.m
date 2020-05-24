clear
close all
clc


fs = 100;
t = 0:1/fs:10-1/fs;
x = 1.3 * sin(2*pi*15*t)...
    +1.7*sin(2*pi*40*(t-2))...
    +2.5*gallery('normaldata', size(t), 4);
plot(x)


Y = abs(fft(x));
n = length(x);
df = fs/n;
f = (0:n-1)*df;
power = Y.^2/n;
plot(f, power)

y0 = fftshift(Y);
f0 = (-n/2:n/2-1)*df;
power0 = y0.^2/n;
plot(f0, power0)

