clear; clc; close all;

fc = 125e3;
% B = 20e3;
B = 0;

Fs = (2 * (fc + B/2))*1e2;

Np = 10;
Ts = Np / fc;
Ns = Ts * Fs;

t = (0:Ns-1)*(fc/Fs);

x = sin(2*pi*t);
plot(t,x)


figure
N = pow2(nextpow2(length(x)));
Y = fft(x,N);
f = (0:N-1)*(Fs/N);
power = abs(Y).^2/N;
plot(f,power)


x_dc = x .* exp(-1i*2*pi*0.5.*(0:Ns-1));

figure
plot(t,x_dc)


figure
N = pow2(nextpow2(length(x_dc)));
Y = fft(x_dc,N);
f = (0:N-1)*(Fs/N);
power = abs(Y).^2/N;
plot(f,power)



%%
clear; clc; close all;
fc = 15;
B = 5;
fs = 2*(fc + B/2)*10;

t = 0:1/fs:2;
n = 0:length(t)-1;

x = sin(2*pi*fc/fs*n);
figure
plot(t,x)

figure
N = pow2(nextpow2(length(x)));
Y = fft(x,N);
f = (0:N-1)*(fs/N);
power = abs(Y).^2/N;
plot(f,power)

x_dc = exp(1i*2*pi*(-15/fs).*n).*x;

figure
plot(t,x_dc)

figure
N = pow2(nextpow2(length(x_dc)));
Y = fft(x_dc,N);
f = (0:N-1)*(fs/N);
power = abs(Y).^2/N;
plot(f,power)






