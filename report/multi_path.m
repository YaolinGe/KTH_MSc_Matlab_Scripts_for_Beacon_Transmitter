clear;close all;clc;

x = [1 3 7 10 30]*10;
y = [2 1.5 2.2 1.2 1.3];

t = 0:0.1:40;
ty = zeros(1, length(t));
for i = 1:length(x)
    ty(x(i)) = y(i);
end
ty = ty + 0.1*wgn(1, length(ty), 0);
plot(t,ty, 'k-', 'linewidth', 1.2); plot_grid();
title('time series');
xlabel('time [ms]')
ylabel('')








