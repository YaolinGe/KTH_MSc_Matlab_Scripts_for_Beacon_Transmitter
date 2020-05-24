clear; clc; close all;

fs = 47e3;
t = (0:1/fs:1)';
a = 1;
f = 2e3;
phi = 0;
x = a * cos(2*pi*f*t+phi);
% plot(t,x)


% sound(x,fs)
y = [zeros(length(x),1);x;ones(length(x),1)];
% stem(y)

[Y,lags] = xcorr(y,x);
stem(lags/fs,Y,'filled')
