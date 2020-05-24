clear; clc; close all;

fs = 44100;
y = audioread('guitartune.wav');

sound(y,fs)
plot(y)
n = length(y);
Y = fft(y, n);
f = (0:1/n:1-1/n)*fs.';
magnitudeY = abs(Y);
phaseY = unwrap(angle(Y));
figure();
grid on; grid minor; box on;
plot(f, magnitudeY);
xlabel('');
ylabel('');
title('');
legend('','');



figure();
grid on; grid minor; box on;
plot(f,phaseY)
xlabel('');
ylabel('');
title('');
legend('','');