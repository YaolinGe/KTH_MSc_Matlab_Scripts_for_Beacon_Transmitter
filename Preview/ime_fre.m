clear; clc; close all;

x = (-30:30)';
y = zeros(length(x),1);

ind = logical(abs(x)<=30);
y(ind) = 1;



figure();
grid on; grid minor; box on;
stem(x,y,'filled')
xlabel('');
ylabel('');
title('');
legend('','');


n = pow2(nextpow2(length(y)));
Y = fft(y,n);
Y = fftshift(Y);
% n = length(Y);
YY = abs(Y).^2/n;

f = (-n/2:n/2-1)./n;

figure();
grid on; grid minor; box on;
plot(f,YY)
xlabel('');
ylabel('');
title('');
legend('','');