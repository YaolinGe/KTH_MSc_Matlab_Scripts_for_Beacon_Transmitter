clear; clc; close all;


Tp = 2;
W = 5e2 ;
taup = 1;
fs = max(100,10*W);
t = (0:1/fs:Tp)';


s = exp(1i*2*pi*(-t*W/2+(W/(2*Tp))*t.^2));


figure();
grid on; grid minor; box on;
plot(t,real(s))
xlabel('');
ylabel('');
title('');
legend('','');


% s = s/sqrt(s'*s);
figure();
grid on; grid minor; box on;
plot(t,s)
xlabel('');
ylabel('');
title('');
legend('','');

x = [zeros(round(fs*taup*1.5),1);s;zeros(round(fs*taup*1.5),1)];

figure();
grid on; grid minor; box on;
stem(x)
xlabel('');
ylabel('');
title('');
legend('','');

y = filter(conj(s(end:-1:1)),1,x);

figure();
grid on; grid minor; box on;
stem(y)
xlabel('');
ylabel('');
title('');
legend('','');

y = y(length(s):end);

figure();
grid on; grid minor; box on;
plot(y)
xlabel('');
ylabel('');
title('');
legend('','');



tau = (0:length(y)-1)/fs;
figure()
plot(tau,abs(y))



figure();
grid on; grid minor; box on;
plot(t,real(s))
xlabel('');
ylabel('');
title('');
legend('','');

sound(real(s),fs)



%%

clear; clc; close all;
fc = 1e3;
fs = 44.1e3;
t = 0:1/fs:2;

A = 10;
B = 5e2;
tau = 1;
phi = 0;
y = A * cos(2*pi*(fc-B/2)*t+pi*(B/tau).*t.^2+phi);


figure();
grid on; grid minor; box on;
plot(t,y)
xlabel('');
ylabel('');
title('');
legend('','');
% sound(y,fs)


%%

clear; clc; close all;

fs = 5e3;
t = (0:1/fs:10)';
phi = 0;
c = 1;
f0 = 5e3;
x = sin(phi + 2*pi*(c/2*t.^2+f0*t));


figure();
grid on; grid minor; box on;
plot(t,x)
xlabel('');
ylabel('');
title('');
legend('','');
sound(x,fs)


%%
clear; clc; close all;

x = ones(10,1);
y = [zeros(10,1);x;zeros(10,1)];
figure()
stem(y,'filled')

[y_cor,lags] = xcorr(y);

n = pow2(nextpow2(length(y)));
Y = fft(y,n);

f = (-n/2:n/2-1)/n;
% Y = fftshift(Y);
power = abs(Y).^2/n;

figure()
plot(f,power)



y_corr = ifft(power);

figure()
plot(lags, y_cor)
hold on
plot(y_corr)



%%
clear; clc; close all;
x = 1:10;
X = fft(x);
y = ifft(X);

 

































