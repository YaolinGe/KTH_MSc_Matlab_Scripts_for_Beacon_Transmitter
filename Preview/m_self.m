clear; clc; close all;

x = -1e3:1e3;
y = ones(length(x),1);
% for i = 2:2:length(y)
%     y(i) = -1;
% end
% stem(x,y)


n = pow2(nextpow2(length(y)));
Y = fft(y,n);
Y = fftshift(Y);
power = abs(Y).^2/n;

f = (-n/2:n/2-1)/n;
figure
plot(x,y)


figure
plot(f,power)


%%
n = 0:127;
x = 2 + cos(pi/4*n);
x0 = downsample(x,2,0);
x1 = downsample(x,2,1);

subplot(3,1,1)
stem(x,'filled');
subplot(3,1,2)
stem(x0,'filled')
subplot(3,1,3)
stem(x1,'filled')

%%
x = ones(1e1,1);
x(2:2:end) = -1;


x1 = downsample(x,2,0);

x2 = downsample(x,3,0);

figure()
subplot(3,1,1);
stem(x);
subplot(3,1,2);
stem(x1)
subplot(3,1,3);
stem(x2)