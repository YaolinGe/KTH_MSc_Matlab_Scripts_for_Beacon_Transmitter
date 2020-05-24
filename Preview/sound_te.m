clear
clc
close all
% blue whale
whaleFile = 'bluewhale.au';
[x,fs] = audioread(whaleFile);
plot(x);

xlabel('Sample number');
ylabel('amplitude');


player = audioplayer(x,fs);
% release(player)
play(player)
% pause(player)
% resume(player)
% stop(player)

moan = x(2.45e4:3.10e4);
t = 10*(0:1/fs:(length(moan)-1)/fs);
figure()
plot(t, moan)
xlabel('time seconds');
ylabel('amplitude');
xlim([0 t(end)]);

m = length(moan);
n = pow2(nextpow2(m));
y = fft(moan, n);
df = fs / n;
f = (0:n-1)*df/10;
power = abs(y).^2/n;
figure()
plot(f(1:floor(n/2)),power(1:floor(n/2)))
xlabel('frequency')
ylabel('power')


%%

y = abs(fft(x));
n = length(x);

f = (0:n-1)*df;
plot(f,y)
y = fftshift(y);
Y = y.^2;

figure()
f = (-n/2:(n-1)/2) * df;
plot(f, Y)


