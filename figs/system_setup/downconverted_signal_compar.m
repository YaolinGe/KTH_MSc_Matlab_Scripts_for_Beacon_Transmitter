clear; close all; clc;
yreff = data_acquisition('data_dc_all', 'REFSIG_DC_FREQ');
yreft = data_acquisition('data_dc_all', 'REFSIG_DC_TIME');
ydc = data_acquisition('data_dc_all', 'DC_TIME');
yfdc = data_acquisition('data_dc_all', 'DC_FREQ');

ct = data_acquisition('data_dc_all', 'CORR_TIME');
cf = data_acquisition('data_dc_all', 'CORR_FREQ');

yt.re = ydc([1:2:end], 1);
yt.im = ydc([2:2:end], 1);
figure(1);
subplot(3,1,1);
plot(yt.re);
title('real part of the downconverted signal')
subplot(3,1,2);
plot(yt.im);
title('imag part of the downconverted signal')
subplot(3,1,3);
plot(absC(yt))
title('magnitude of the downconverted signal')

yf.re = yfdc([1:2:end], 1);
yf.im = yfdc([2:2:end], 1);

figure(2);
subplot(3,1,1);
plot(yf.re);
title('real part of the frequency spectrum of the downconverted signal')
subplot(3,1,2);
plot(yf.im);
title('imag part of the frequency spectrum of the downconverted signal')
subplot(3,1,3);
plot(absC(yf))
title('magnitude of the frequency spectrum')

y_ref.re = yreft([1:2:end], 1);
y_ref.im = yreft([2:2:end], 1);

figure(3);
subplot(3,1,1);
plot(y_ref.re);
title('real part of the time reversed downconverted reference signal')
subplot(3,1,2);
plot(y_ref.im);
title('imag part of the time reversed downconverted reference signal')
subplot(3,1,3);
plot(absC(y_ref))
title('magnitude of the time reversed downconverted reference signal')

yf_ref.re = yreff([1:2:end], 1);
yf_ref.im = yreff([2:2:end], 1);

figure(4);
subplot(3,1,1);
plot(yf_ref.re);
title('real part of the frequency spectrum of the downconverted signal')
subplot(3,1,2);
plot(yf_ref.im);
title('imag part of the frequency spectrum of the downconverted signal')
subplot(3,1,3);
plot(absC(yf_ref))
title('magnitude of the frequency spectrum')

corrt.re = ct([1:2:end], 1);
corrt.im = ct([2:2:end], 1);

figure(5);
subplot(3,1,1);
plot(corrt.re);
title('real part of the correlation between downconverted signals')
subplot(3,1,2);
plot(corrt.im);
title('imag part of the correlation between downconverted signals')
subplot(3,1,3);
plot(absC(corrt))
title('magnitude of the correlation between downconverted signals')

corrf.re = cf([1:2:end], 1);
corrf.im = cf([2:2:end], 1);
figure(6);
subplot(3,1,1);
plot(corrf.re);
title('real part of the frequency spectrum of the correlation between downconverted signals')
subplot(3,1,2);
plot(corrf.im);
title('imag part of the frequency spectrum of the correlation between downconverted signals')
subplot(3,1,3);
plot(absC(corrf))
title('magnitude of the frequency spectrum of the correlation between downconverted signals')

figure(7)
sgtitle('downconverted signal comparison')
subplot(3,1,1); 
plot(absC(yt)); plot_grid();
title('magnitude of downconverted received singal')
subplot(3,1,2); 
plot(absC(y_ref)); plot_grid();
title('magnitude of time reversed downconverted reference signal (MF gain)')
subplot(3,1,3); 
plot(absC(corrt)); plot_grid();
title('magnitude of correlated signal')
