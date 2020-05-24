close all
clear all
clc

Fs =  160e3;
fL = .3;    % lower cut frequency
fH =  .7;   % upper cut frequency
F = 12;     % fixed point, 12 bit 

N = 7;
w(:,1) = window(@rectwin, N);
w(:,2) = window(@triang, N);
w(:,3) = window(@hann, N);
w(:,4) = window(@hamming, N);
w(:,5) = window(@chebwin, N);
w(:,6) = window(@kaiser, N);

H = ones(N,1);

f = 0:1/N:1-1/N;
H(f<fL|f>fH) = 0;

h = real(ifft(H));
h = fftshift(h);
N = 1e4;
f = 0:1/N:1-1/N;
figure(1)
hold on
for i = 1:6
    tic;
    hw(:,i) = h.*w(:,i);
    hw(:,i) = round(hw(:,i)*2^F)/2^F; %consiering quantisation effect
    Hw = abs(fft(hw(:,i),N));
    plot(f, mag2db(Hw),'linewidth',1);
    t(i) = toc;
end

xlabel('normalised frequency')
ylabel('dB')
ylim([-150 20])
plot([fL fL], [-150 20],'k-.')
plot([fH fH], [-150 20],'k-.')
plot([0 1], [-40 -40], 'r-.','linewidth', 1.5)
title('passband filter comparison with quantisation effect')
legend('rect', 'triang', 'hann', 'hamming', 'chebwin', 'kaiser' )
text(.2, 10, 'low frequency limit')
text(.6, 10, 'high frequency limit')

figure(2)
stem(t, 'filled');
yshift = 5e-4;
text(1, t(1)+yshift, 'rect')
text(2, t(2)+yshift, 'triang')
text(3, t(3)+yshift, 'hann')
text(4, t(4)+yshift, 'hamming')
text(5, t(5)+yshift, 'chebwin')
text(6, t(6)+yshift, 'kaiser')
xlim([0 7])
title('time comparison for each window ca')
ylabel('seconds')

%%
clear; clc; close all;

Fs = 160e3;
fc =  .25;

N = 40;
w = window(@rectwin,N);
w = window(@hamming,N);
H = ones(N,1);
f = 0:1/N:1-1/N;
H(f>fc&f<(1-fc)) = 0;

h = real(ifft(H));
h = fftshift(h);

hw = h.*w;
Hw = abs(fft(hw,N*100));
f = 0:1/length(Hw):1-1/length(Hw);
plot(f, mag2db((Hw)));
ylim([-100 20])
