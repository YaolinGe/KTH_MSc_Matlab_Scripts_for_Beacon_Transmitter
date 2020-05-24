clear;close all;clc;
y1 = to_complex(convert_to_complex(data_acquisition('DB_test', 'DC_VALS')));
y2 = to_complex(convert_to_complex(data_acquisition('DB_test', 'DC_VALS_LPFILT')));
y3 = to_complex(convert_to_complex(data_acquisition('DB_test', 'DC')));
y4 = to_complex(convert_to_complex(data_acquisition('DB_test', 'DC_RESCALE')));
y5 = to_complex(convert_to_complex(data_acquisition('DB_test', 'DC_TIME')));
y6 = to_complex(convert_to_complex(data_acquisition('DB_test', 'CORR_TIME')));

figure(1)
sgtitle('time domain time series data')
subplot(3,2,1);
plot(abs(y1)); plot_grid();
title('downshifted')
subplot(3,2,2);
plot(abs(y2)); plot_grid();
title('downshifted low pass filtered')

subplot(3,2,3);
plot(abs(y3));plot_grid();
title('dc lp filtered resampled')

subplot(3,2,4);
plot(abs(y4));plot_grid();
title('dc lp filtered resampled rescaled')

subplot(3,2,5);
plot(abs(y5));plot_grid();
title('downconverted signals')

subplot(3,2,6);
plot(abs(y6));plot_grid();
title('downconverted correlated signals')
scale = 6;
threshold = thresholding(abs(y6), scale);
hold on;
plot(threshold)

% ============= FD
Fs = 160e3; B = 5e3;
figure(2)
sgtitle('frequency spectrum of the time series data')
subplot(3,2,1);
pspectrum(y1, Fs); plot_grid();
title('downshifted')
subplot(3,2,2);
pspectrum(y2, Fs); plot_grid();
title('downshifted low pass filtered')

subplot(3,2,3);
pspectrum(y3, Fs); plot_grid();
title('dc lp filtered resampled')

subplot(3,2,4);
pspectrum(y4, Fs); plot_grid();
title('dc lp filtered resampled rescaled')

subplot(3,2,5);
pspectrum(y5, Fs); plot_grid();
title('downconverted signals')

subplot(3,2,6);
pspectrum(y6, Fs); plot_grid();
title('downconverted correlated signals')

%% test of responding
clear;close all;clc;
% y = to_complex(convert_to_complex(data_acquisition('DB_test', 'STORAGE_VECT')));
y = data_acquisition('DB_test', 'STORAGE_VECT');

threshold = data_acquisition('DB_test', 'THRESHOLD');
threshold_dc = data_acquisition('DB_test', 'THRESHOLD_DC');
threshold_valcnt = data_acquisition('DB_test', 'THRESHOLD_VALCNT');

% thres = expand_threshold(data_acquisition('DB_test', 'STORAGE_VECT_TEST'), 150);
thres = expand_threshold(threshold_dc, 300);

figure
plot(y)
hold on;
plot(thres)

figure()
plot(threshold)
hold on;
plot(threshold_dc);
thres_avg = sum(thres) / threshold_valcnt;
plot([0 length(threshold)], [thres_avg thres_avg], 'ko-');
axis([0 length(threshold) min(threshold) max(threshold)]);

%% thresholding
clear;close all;clc;
y = data_acquisition('DB_test', 'VALCNT');
valcnt_pre = y(1:2:end);
valcnt_aft = y(2:2:end);
figure(1);
plot(valcnt_pre, 'k-');
plot_grid;
hold on;
plot(valcnt_aft, 'r');

%% test of storage
clear;close all;clc;

Nframe = 5000;
y = data_acquisition('DB_test', 'STORAGE_VECT');
y1 = data_acquisition('DB_test', 'STORAGE_VECT_TEST');
threshold_dc = y1(1:3:Nframe*3);
index_max = y1(2:3:Nframe*3);
abs_corr_time = y1(3:3:Nframe*3);

figure(1)
plot(threshold_dc)

figure(2);
subplot(2,1,1)
plot(y);
plot_grid();
hold on;
threshold_dc = expand_threshold(threshold_dc, Nframe);
plot(threshold_dc)
for i = 1:Nframe
    index_max(i) = index_max(i) + (i-1) * 64;
end %for
y(Nframe*64+1:end) = [];
y_re = reshape(y, 64, Nframe);
[y_max index] = max(y_re);
for i = 1:Nframe
    index(i) = index(i) + (i-1) * 64;
end %for
subplot(2,1,2)
plot(index, y_max, '*'); plot_grid();
hold on;
plot(index_max, abs_corr_time, 'o');
title('frame max comparison')

% figure(3);
% [val ind] = max(y);
% ids = ind - 10: ind + 10;
% plot(ids, y(ids));
% plot_grid();


%% env sampling
pd = fitdist(y, 'kernel', 'bandwidth', 4);
x_vals = 0:200;
ypdf = pdf(pd, x_vals);
plot(x_vals, ypdf)

%%
clear;close all;clc;
y = data_acquisition('DB_test', 'TRIGGER_INDEX');
plot(y)
z = diff(y);
figure
plot(z)
yline(mean(z))
mean(z)


%% test DB_test
clear;close all;clc;
y = data_acquisition('DB_test', 'RANGE_EST');
plot(y)
yline(mean(y))

figure
pd = fitdist(y, 'kernel');
x_vals = -50:0.001:50;
y_pdf = pdf(pd, x_vals);
plot(x_vals, y_pdf, 'r-', 'linewidth', 2)
plot_grid();
[val ind] = max(y_pdf);
hold on;
p = plot([x_vals(ind) x_vals(ind)], [min(y_pdf) max(y_pdf)], 'k:', 'linewidth', 1.5)
legend(p, ['range estimation is ', num2str(x_vals(ind)), 'm'])





