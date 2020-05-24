clear;close all;clc;

fs = 160e3;
dt = 1/fs;
fc = 47e3;
Np = 10;
Tp = 1/fc;
Ts = Np * Tp;

t = 0:dt:Ts-dt;

x = sin(2*pi*fc*t);

xh = hilbert(x);
xo = x + 1i*xh;


xt = exp(-1i*2*pi*fc*t).*xo;
figure(1);
plot(t, xo, 'k--'); hold on
plot(t, abs(xt))