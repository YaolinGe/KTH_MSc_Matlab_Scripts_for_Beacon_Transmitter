clear;close all;clc;

f = [0, 1, 5, 10, 30, 50, 100];
alpha = [0, 0.036, 0.1, 0.3, 2, 4, 10];
r = [0.1, 0.2, 0.5, 1, 2, 5, 10, 20, 50, 100];
for i = 1:length(alpha)
    TL(:, i) = 40*log(r) + alpha(i) * r;
end %for

plot(r, TL)
% set(gca, 'xscale', 'log')
% % % set(gca, 'yscale', 'log')
ylim([40 200])
xticks([0.1, 0.2, 0.5, 1, 2, 5, 10, 20, 50, 100]);