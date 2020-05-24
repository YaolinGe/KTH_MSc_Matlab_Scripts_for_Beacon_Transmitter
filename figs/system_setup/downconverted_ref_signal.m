%%
clear;close all;clc;
y = data_acquisition('DB_test', 'REFSIG_TIME_16C');
ydc = data_acquisition('DB_test', 'REFSIG_DC_TIME_RE');

yc.re = ydc(1:2:end);
yc.im = ydc(2:2:end);

y = y(1:2:end);
Fs = 160e3;
t = (0:length(y)-1)/Fs;
plot(t, abs(y)); hold on;


B = 5e3;
tdc = (0:length(yc.re)-1)/B;
plot(tdc,absC(yc) * max(abs(y))/max(absC(yc)), 'ro-')
xlim([0, 0.002])
title('downconverted ref signal from the hardware');
grid on; grid minor; box on;
xlabel('time [s]')

%%
clear;close all;clc;
ydc = data_acquisition('refsig_dc_freq', 'DC_TIME');
y.re = ydc(1:2:end);
y.im = ydc(2:2:end);

yc = y.re + 1i * y.im;

Y = fft(yc);
f = (0:length(Y)-1)/length(Y);

plot(f, abs(Y)); hold on;

yf = data_acquisition('refsig_dc_freq', 'DC_FREQ');

yfdc.re = yf(1:2:end);
yfdc.im = yf(2:2:end);

f = (0:length(yfdc.re)-1)/length(yfdc.re);
plot(f, absC(yfdc) * max(abs(Y))/ max(absC(yfdc)))
title('frequency spectrum from Hardware')
grid on; grid minor; box on;
legend('Matlab', 'Hardware')