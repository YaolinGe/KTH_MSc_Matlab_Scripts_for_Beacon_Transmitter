clear; clc; close all;

dirac = 1;
x = -3e3:3e3;
x = x';

I = find(x==0);
y = zeros(length(x), 1);
y(I) = dirac;
stem(x,y,'filled')

n = pow2(nextpow2(length(y)));
Y = fft(y, n);
power = abs(Y).^2/n;

f = (-n/2:n/2-1)/n;
figure();
grid on; grid minor; box on;
plot(f,power/max(power))
xlabel('');
ylabel('');
title('');
legend('','');


%%
clear; clc; close all;
r = audiorecorder;
recordblocking(r,3);
fs = 8e3;

y = getaudiodata(r);
sound(y,fs)

plot(y)
%% 
plot(y)


%%

clear; clc; close all;

% [y, fs] = audioread('tet.m4a');
[y, fs] = audioread('dolphin.mp3');
plot(y)

% sound(y,fs)

n = pow2(nextpow2(length(y)));
Y = fft(y,n);
Y = fftshift(Y);
power = abs(Y).^2/n;
f = (-n/2:n/2-1)*(fs/n);
sound(y,fs)
figure();
grid on; grid minor; box on;
plot(f,power)
xlabel('');
ylabel('');
title('');
legend('','');
