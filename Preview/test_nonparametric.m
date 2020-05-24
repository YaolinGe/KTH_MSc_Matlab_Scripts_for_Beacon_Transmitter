
clear;close all;clc;

x = wgn(32, 1, 20);
figure(1); subplot(3, 1,1);stem(x, 'filled');
X = xcorr(x); subplot(3, 1,2);stem(X, 'filled');

px = periodogram(x);
f = (0:(length(px)-1))/length(px);
y = mean(px);
subplot(3,1,3); plot(f, mag2db(px), 'k-.'); hold on; plot([f(1) f(end)], mag2db([y y]), 'k-')

yline(0);