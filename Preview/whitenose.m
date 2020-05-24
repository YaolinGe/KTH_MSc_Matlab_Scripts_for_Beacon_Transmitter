clear; clc; close all;

noise = wgn(1000, 1, 0);
stem(noise)
var(noise)

n = pow2(nextpow2(length(noise)));
x = fft(noise, n);
x = abs(x);
x = fftshift(x);
X = x.^2;
df = 1/n;
f = (-n/2:(n-1)/2)*df;
figure()
plot(f, X)



y2 = wgn(1000, 1, -100, 'complex');
var(y2)
