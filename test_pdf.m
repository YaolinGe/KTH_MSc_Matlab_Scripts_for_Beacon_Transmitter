clear;close all;clc;

x = randn(5000,1)*2+1;
% z = sort(x);
% histogram(x)
% stem(z)

[f,h] = hist(x,100);
f = f/max(f);
% bar(h,f)
F = cumsum(f)/sum(f);
% stem(F)
u = 1; v = 4;
fg = exp(-(h-u).^2/(2*v))/sqrt(2*pi*v);
% stem(fg)

Fg = (1+erf((h-u)/sqrt(2*v)))/2;
figure(1); subplot(2,1,1); plot(h, f, h, fg, '--');
figure(1); subplot(2,1,2); plot(h, F, h, Fg, '-.');



%% 
clear;close all;clc
N = 1e3;
x = exprnd(10000,N,1);
histogram(x)
% stem(x)

%%
clear;close all;clc;

x = wgn(1e3,1,0);
histogram(x)

y = x.^2;

histogram(y)


clear;close all;clc;
y = get_data_sonarfile('data_air_test.txt', 1);

pd = fitdist(y, 'kernel');
x_vals = 2100:1:2600;
Y = pdf(pd, x_vals);
plot(x_vals, Y, 'linewidth', 2)


y = get_data_sonarfile('noise_background_old.txt', 1);
pd = fitdist(y, 'Normal');
x_vals = 2100:1:2600;
Y = pdf(pd, x_vals);
hold on;
plot(x_vals, Y, 'linewidth', 2)
plot_grid();
xlabel('ADC levels');
ylabel('density');
title('pdf of hypothesis testing');
legend('signal + noise pdf', 'noise pdf');


%%
clear;close all;clc;
y = get_data_sonarfile('data_air_test.txt', 1);

pd = fitdist(y, 'kernel', 'bandwidth', 40);
x_vals = 2100:1:2600;
Y = pdf(pd, x_vals);
plot(x_vals, Y, 'linewidth', 2)


y = get_data_sonarfile('noise_background_old.txt', 1);
pd = fitdist(y, 'kernel', 'bandwidth', 40);
x_vals = 2100:1:2600;
Y = pdf(pd, x_vals);
hold on;
plot(x_vals, Y, 'linewidth', 2)
plot_grid();
xlabel('ADC levels');
ylabel('density');
title('pdf of hypothesis testing');
legend('signal + noise pdf', 'noise pdf');




%%
clear;close all;clc;
[f,  h] = hist(y, 200);
F = cumsum(f)/sum(f);
f = f/(sum(f)*(h(2)-h(1)));


figure
subplot(2,1,1)
plot(h, f)
subplot(2,1,2)
plot(h, F)

load hospital;
x = hospital.Weight;
pd = fitdist(x, 'Normal');
x_vals = 50:1:250;
y = pdf(pd, x_vals);
plot(x_vals, y, 'linewidth', 2)


%% test of exponential dstribution
clear;close all;clc;
x = exprnd(1, 1e4, 1);
pd = fitdist(x, 'exponential');
% pd = fitdist(x, 'chi-squared');
xvals = linspace(0, 10, 1e3);
y = pdf(pd, xvals);
plot(y)


%%
clear;close all;clc;
mu = 1; % Population parameter
n = 1e3; % Sample size
ns = 1e4; % Number of samples

rng('default')  % For reproducibility
samples = exprnd(mu,n,ns); % Population samples
means = mean(samples); % Sample means


[phat,pci] = mle(means);

numbins = 50;
histogram(means,numbins,'Normalization','pdf')
hold on
x = min(means):0.001:max(means);
y = normpdf(x,phat(1),phat(2));
plot(x,y,'r','LineWidth',2)















