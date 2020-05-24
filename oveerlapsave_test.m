clear;close all;clc;




% x = 1:100;
x = (mseq(2, 13, 1, 1))';
y = 1:5;
h = conv(y, x);

M = length(y);
n = 11;
L = n - M + 1;
Lenx = length(x);
y = [y, zeros(1,n-M)];
x = [zeros(1, M-1), x, zeros(1, n-1)];
K = floor((Lenx+M-1-1)/L);
Y = zeros(K+1, n);
for k = 0:K
    xk = x(k*L+1:k*L+n);
    Y(k+1, :) = cconv(xk, y, n);
end

Y1 = Y(:, M:n)';
Y1 = Y1(:)';

figure(1);
hold on;  stem(h); stem(Y1);

Y1(end) = [];
% Y1 == h


%%

clear;close  all;clc;
% x = 1:1e3;
x = mseq(2, 13, 1, 1);
y = 1:3;
Lenx = length(x);
n = 11;
M = length(y);
L = n - M + 1;
h = conv(x, y);

y = [y, zeros(1,n-M)];
x = [zeros(1, M-1), x, zeros(1, n-1)];
K = floor((Lenx + M-1-1)/L);
yk = zeros(K+1, n);
for k = 0:K
    xk = x(k*L+1:k*L+n);
    yk(k+1, :) = cconv(xk, y, n);
end


y1 =  yk(:, M:n)';
y1 = y1(:)';


MM = length(y1)-length(h)
y1(end-MM+1:end) = [];
y1 == h
figure(2); stem(y1); hold on; stem(h)




%%

clear;close all;clc;

x = (mseq(2, 13, 1, 1))';

f = [0 .25 .3 1];
a = [1 1 0 0];
n = 40;

h = firls(n, f, a);

H = conv(x, h);
M = length(h);
N = 50;
L = N - M + 1;
Lenx  = length(x);

h = [h, zeros(1, N-M)];
x = [zeros(1, M-1), x, zeros(1, N-1)];

K = floor((Lenx + M - 1 - 1)/L);

yk = zeros(K+1, N);
for k = 0:K
    xk = x(k*L+1:k*L+N);
    yk(k+1,:) = cconv(xk, h, N);
end

Y = yk(:, M:N)';
Y = Y(:)';
stem(Y); hold on; stem(H)





%%
clear;close all;clc

x = (mseq(2, 13, 1, 1))';
f = [0 .25 .3 1];
a = [1 1 0 0];
n = 40;

h = firls(n, f, a);
N = 50;
Lenx = length(x); M = length(h);  M1 =M - 1; L = N - M1;
h = [h zeros(1,N-M)];
%
x = [zeros(1,M1), x, zeros(1,N-1)]; K = floor((Lenx+M1-1)/(L));
Y = zeros(K+1,N);
% convolution with succesive blocks 
for k=0:K
 xk = x(k*L+1:k*L+N);
 Y(k+1,:) = cconv(xk,h,N);
end



Y= Y(:,M:N)';
y= (Y(:))';













































