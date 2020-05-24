clear; clc; close all;

% rng default
x = triang(20);
y = [zeros(3,1);x]+0.3*randn(length(x)+3,1);

figure(1);
subplot(2,1,1);
stem(x,'filled');
axis([0 22 -1 2]);
title('Input signal');
subplot(2,1,2);
stem(y,'filled');
axis([0 22 -1 2]);
title('Output signal');


[xc, lags] = xcorr(y,x);

figure()
stem(xc)

[~, I] = max(abs(xc));

figure();
stem(lags, abs(xc), 'filled');
legend(sprintf('Maximum at lag %d', lags(I)));
title('Sample Cross-Correlation Sequence');


%% generate m-sequence signal

clear; clc; close all;

msq=mseq(2,3,1,2);                      % M-sequence signal
figure()
plot(msq);

hold on;
msq=mseq(2,3,10,2);                      % M-sequence signal
plot(msq)
msq=mseq(2,3,12,2);                      % M-sequence signal
plot(msq)
msq=mseq(2,3,17,2);                      % M-sequence signal
plot(msq)



%% ouput the M-sequence datafile

clear; clc; close all;

y = readmatrix('m_sequence.txt');
% n = pow2(nextpow2(length(y)));
n = pow2(10);
Y = fft(y, n);
power = abs(Y).^2/n;

f = (0:length(Y)-1)/length(Y);
plot(f, power)


%% play m-sequence


r = audioplayer(y,1024);
play(r)


































