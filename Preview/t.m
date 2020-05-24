clear
close all
clc


%% z-tranaform

syms a n

x = a ^ n;
X = ztrans(x)


x = sin(a*n);
X = ztrans(x)


x = heaviside(a);
X = ztrans(x)


x = dirac(a);
X = ztrans(x)


%% z-inverse transform


% paritial fraction

b = [1, 2];
a = [1, 2, 3];

[r,p,C] = residuez(b,a)

% long division

syms z n
X = z / (z - 0.5);
x = iztrans(X,z,n)


X = z^2 / (z-1)^2;
x = iztrans(X)



%% test DFT

x = rand(1,10);
X = fft(x, length(x));

dft(x,length(x))
plot(1:length(x), dft(x,length(x)))
hold on



plot(1:length(x), X)



%% test FFT

clear
close all
clc

N = 8; m = 3;
x = 1:N
x1 = dec2bin(x-1, m)
x2 = fliplr(x1)
x3 = bin2dec(x2)
y = x3 + 1

for i = 1: length(x1)
%     fprintf("the value is %b and %b", x1(i), x2(i))
end %ofr
 

syms a n
x = a^n;
X = ztrans(x)

x = 1 + a ^2 * n;
X = ztrans(x)


% x = [1, 2, 5, 7, 0, 1]
% X = ztrans(x)
% 
% x = heaviside(a)
% X = ztrans(x)


x = -10:10;
y = dirac(x);
y(isinf(y)) = 1;
stem(x,y)


Y = ztrans(y);













