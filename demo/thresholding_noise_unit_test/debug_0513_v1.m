clear;close all;clc;

%% Today's recipe for field_testing

%% OBJ1: test out centre frequency resolution
%% pulse and listen for centre frequencies resolution
clear;close all;clc;

y1 = data_acquisition('DB_test', 'STORAGE_VECT');
y_size = size(y1);
y_len = y_size(2);
figure(1)
sgtitle('pulse and listen time series comparison - centre frequencies')
for i = 1:20
%     for i = 1:16

    subplot(5,4,i);
    plot(y1(:,i));
    plot_grid();
%     title([num2str(i*5), 'kHz']);
    title([num2str(i*+29), 'kHz']);

end

figure(2)
Fs = 160e3;
y1 = y1 - mean(y1);
sgtitle('pulse and listen frequency spectrum comparison - centre frequencies')
for i = 1:20
% for i = 1:16

    subplot(5,4,i);
    pspectrum(y1(:,i), Fs);
    plot_grid();
    title([num2str(i+29), 'kHz']);

%     title([num2str(i*5), 'kHz']);
end

%% pulse and listen for ramping up delay calibration
clear; close all; clc;
y1 = data_acquisition('DB_test', 'STORAGE_VECT');
y_size = size(y1);
y_len = y_size(2);
% y = y([1:500], :);
figure(1)
sgtitle('pulse and listen start_delay comparison - centre frequencies 47kHz')
for i = 1:40
    subplot(8,5,i);
    plot(y1(:,i));
    plot_grid();
    title([num2str(i), '0 micro_secs']);
end

%% pulse and listen for start delay to bleed out the ringing effect
clear; close all; clc;
y1 = data_acquisition('DB_test', 'STORAGE_VECT');
y_size = size(y1);
y_len = y_size(2);
y1 = y1([1:500], :);
figure(1)
sgtitle('pulse and listen start_delay comparison - centre frequencies 47kHz')
for i = 1:30
    subplot(6,5,i);
    plot(y1(:,i));
    plot_grid();
    title([num2str(i*5), '0 micro_secs']);
    ylim([1000 3000])
end


%% Test the detector scale_factor and thresholding mechanisms
clear;close all;clc;

Nframe = 500;
scale_factor = 5:5:45;
y1 = data_acquisition('DB_test', 'STORAGE_VECT');
% y = data_acquisition('data_scale_factor_0515', 'STORAGE_VECT');
y_size = size(y1);
y_len = y_size(2);
% y1 = data_acquisition('data_scale_factor_0515', 'STORAGE_VECT_TEST');
y1 = data_acquisition('DB_test', 'STORAGE_VECT_TEST');
threshold_dc = y1([1:3:Nframe*3],:);
index_max = y1([2:3:Nframe*3],:);
abs_corr_time = y1([3:3:Nframe*3],:);

figure(1)
plot(threshold_dc)

N_back = 312;
figure(2)
for i = 1:y_len
    subplot(5,2,i);
    plot(y1(:,i), 'k-', 'linewidth', 1.2);
    plot_grid();
    hold on;
    threshold = expand_threshold(threshold_dc([end-N_back+1:end],i), N_back);
    plot(threshold)
    title(['scale is ', num2str(i*5)]);
    ylim([0 600])
end %for

%ROC curve + Pd and Pf calculation ==== too costly cannot be implemented
figure(3)
for i = 1:y_len
    pd = fitdist(y1([1:64],i), 'kernel', 'bandwidth', 4);
    x_vals = 0:0.1:150;
    ypdf = pdf(pd, x_vals);
    subplot(5,2,i)
    plot(x_vals, ypdf, 'k-', 'linewidth', 1.4)
    thres = mean(threshold_dc(end-N_back+1,i));
    title(['scale is ', num2str(i*5)]);
    xline(thres)
end

%% test range estimation
clear;close all;clc;
y1 = data_acquisition('DB_test', 'RANGE_EST');
% xlabel()
% ylabel()
plot(y1, 'ko')
title('range estimation samples')
yline(mean(y1), 'r', 'linewidth', 2)
legend('250 samples', ['trimed mean',num2str(trimmean(y1, 90)), 'm'])
figure
boxplot(y1)

mode(y1)

figure
pd = fitdist(y1, 'kernel');
x_vals = -25:0.001:70;
y_pdf = pdf(pd, x_vals);
plot(x_vals, y_pdf, 'r-', 'linewidth', 2)
plot_grid();
[val ind] = max(y_pdf);
hold on;
p = plot([x_vals(ind) x_vals(ind)], [min(y_pdf) max(y_pdf)], 'k:', 'linewidth', 1.5);
legend(p, ['range estimation is ', num2str(x_vals(ind)), 'm'])


%%
% val = mean(y1);
% % temp = -val;
% temp = 1.784
% i = 1;
% while((temp - 0.15)>1e-1)
%     temp = temp / 2;
%     i = i + 1;
% end
% 
% for j = 1:i
%     temp_vect(j) = temp;
%     temp = temp * 2;
% end
% time = temp_vect / 1481;
% tm = time * 126e6;
% total = sum(tm)

%% test valcnt in the downconversion
clear;close all;clc;
valcnt = data_acquisition('DB_test', 'VALCNT');
valcnt = valcnt(:);
y1 = valcnt(1:2:end);
y2 = valcnt(2:2:end);
avg = mean(-y1+y2)
plot(y1, 'k-.', 'linewidth', 2); 
hold on; 
plot(y2, 'r-')
plot_grid();
legend('pre op', 'aft op');
title('speed analysis (valcnt)')

% yline(-avg);


%% Test out the frequency spectrum of signals
clear; close all; clc; Fs = 160e3; B = 5e3;
y1 = data_acquisition('DB_test', 'STORAGE_VECT');
y1 = y1(:);
y1 = to_complex(convert_to_complex(y1));
t = (0:length(y1)-1)/Fs;

yc = data_acquisition('DB_test', 'STORAGE_VECT_TEST');

subplot(2,2,1)
plot(yc)
plot_grid();
title('received echos')
subplot(2,2,2)
pspectrum(yc, Fs)
subplot(2,2,3)
plot(t, abs(y1))
title('downconverted correlated echos');
plot_grid();
subplot(2,2,4)
pspectrum(y1, B);

%% THRESHOLD BUFFER EVALUATION
clear;close all;clc;
y1 = data_acquisition('DB_test', 'STORAGE_VECT_TEST');
plot(y1(1:5000))
plot_grid();
title('threshold variation')

%% TEST THE EXCEEDANCE IN THE ADC BUFFER
clear;close all;clc;
y1 = data_acquisition('DB_test', 'STORAGE_VECT');
y1 = y1(:);

threshold = data_acquisition('DB_test', 'STORAGE_VECT_TEST');
for i = 1:300
    thres(:, i) = threshold(i) * ones(64,1);
end

thres = thres(:);
Fs = 160e3;
t = (0:300*64-1)/Fs;
f1 = figure
% subplot(2,1,1)
plot(y1(1:300*64))
hold on;
plot(thres, 'r-.', 'linewidth', 2)
title('signal exceedance analysis')

figure
thres = data_acquisition('DB_test', 'THRESHOLD');
plot(thres)
% subplot(2,1,2)
% for i = 1:300
%     xline((i-1)*64);
% end
% title('frames slices')
% print(f1, 'exceedance_frame_analysis', '-dpdf')

%% test of responding
clear;close all;clc;
y1 = data_acquisition('DB_test', 'STORAGE_VECT');
y2 = data_acquisition('data_pulse_listen_40kHz', 'STORAGE_VECT');

% figure
% plot(y)
% hold on;
% plot(y2)
% Fs = 160e3;
% y = y - mean(y);
% y2 = y2 - mean(y2);
% figure
% pspectrum(y, Fs)
% hold on;
% pspectrum(y2, Fs)
% set(gca, 'xscale', 'log', 'yscale', 'log')
% xlim([0 1e3])
% legend('60kHz','40kHz')
Fs = 160e3;

yref = generate_refsig_sine(10, 40e3);
con = conv(y1, fliplr(yref));
% con = y;
con = con(1:4000);
t = (0:length(con)-1)/Fs*343/2;
plot(t, con, 'k')
plot_grid();
xlabel('distance [m]')
% set(gca,'yscale', 'log')

%% threshold
clear;close all;clc;
y1 = data_acquisition('DB_test', 'THRESHOLD');
y1 = y1(:);
plot(y1)
plot_grid();
yline(mean(y1(1:690)))
title("threshold buffer")

%% test debug
clear;close all;clc;
Fs = 160e3;
fc = 40e3;
B = 5e3;
% y1 = to_complex(convert_to_complex(data_acquisition('DB_test', 'DC_VALS')));
% y2 = to_complex(convert_to_complex(data_acquisition('DB_test', 'DC_VALS_RESCALE')));
% y3 = to_complex(convert_to_complex(data_acquisition('DB_test', 'DC_VALS_LPFILT')));
% y4 = to_complex(convert_to_complex(data_acquisition('DB_test', 'DC_VALS_LPFILT_DOWNSAMPLED')));
% y5 = to_complex(convert_to_complex(data_acquisition('DB_test', 'DC_VALS_LPFILT_DOWNSAMPLED_RESCALE')));

figure(1);
subplot(2,1,1);
t = (0:length(y1)-1)/Fs;
plot(t, y1); 
subplot(2,1,2);
pspectrum(y1, Fs);

figure(2);
subplot(2,1,1);
t = (0:length(y2)-1)/Fs;
plot(t, y2); 
subplot(2,1,2);
pspectrum(y2, Fs);



%% test fixed_thresholding + matched filtering
clear;close all;clc;
Fs = 160e3;
y1 = data_acquisition('DB_test', 'CPY_BIAS');
y1 = to_complex(convert_to_complex(y1));
% y1 = y1(1:12000);
t = (0:length(y1)-1)/Fs;
subplot(2,1,1)
plot(y1)
subplot(2,1,2)
pspectrum(y1, Fs);


%%
figure
y1 = data_acquisition('DB_test', 'CPY');
y1 = to_complex(convert_to_complex(y1));
% y1 = y1(1:12000);
% t = (0:length(y)-1)/Fs;
subplot(2,1,1)
plot(y1)
subplot(2,1,2)
pspectrum(y1, Fs);

%%
figure
dc_component = data_acquisition('DB_test', 'DC_COMPONENT');
dc_component = to_complex(convert_to_complex(dc_component));
t = (0:length(dc_component)-1)/Fs;
% plot(t(1:100),dc_component(1:100))
% %%
subplot(2,1,1)
plot(t,abs(dc_component))
subplot(2,1,2)
pspectrum(dc_component, Fs);

%%
% clear;close all;clc;
Fs = 160e3;
figure
y1 = data_acquisition('DB_test', 'DC_VALS');
y1 = to_complex(convert_to_complex(y1));
t = (0:length(y1)-1)/Fs;
subplot(2,1,1)
plot(t,abs(y1))
subplot(2,1,2)
pspectrum(y1, Fs);

%%
clear;close all;clc;
Fs = 160e3;
figure
y1 = data_acquisition('DB_test', 'DC_VALS_RESCALE');
y1 = to_complex(convert_to_complex(y1));
t = (0:length(y1)-1)/Fs;
subplot(2,1,1)
plot(t,abs(y1))
subplot(2,1,2)
pspectrum(y1, Fs);

%%
figure
y1 = data_acquisition('DB_test', 'DC_VALS_LPFILT');
y1 = to_complex(convert_to_complex(y1));
t = (0:length(y1)-1)/Fs;
subplot(2,1,1)
plot(t,abs(y1))
subplot(2,1,2)
pspectrum(y1, Fs);

figure
y1 = data_acquisition('DB_test', 'DC_VALS_LPFILT_DOWNSAMPLED');
y1 = to_complex(convert_to_complex(y1));
t = (0:length(y1)-1)/Fs;
subplot(2,1,1)
plot(t,abs(y1))
subplot(2,1,2)
pspectrum(y1, Fs);

figure
y1 = data_acquisition('DB_test', 'DC_VALS_LPFILT_DOWNSAMPLED_RESCALE');
y1 = to_complex(convert_to_complex(y1));
t = (0:length(y1)-1)/Fs;
subplot(2,1,1)
plot(t,abs(y1))
subplot(2,1,2)
pspectrum(y1, Fs);

figure
y1 = data_acquisition('DB_test', 'CORR_TIME');
y1 = to_complex(convert_to_complex(y1));
t = (0:length(y1)-1)/Fs;
subplot(2,1,1)
plot(t,abs(y1))
subplot(2,1,2)
pspectrum(y1, Fs);
%%
clear;close all;clc;
y = data_acquisition('DB_test', 'THRESHOLD')
plot(y)

figure
y = data_acquisition('DB_test_beacon', 'THRESHOLD')
plot(y)

%%
clear;close all;clc;
y = data_acquisition('DB_test', 'STORAGE_VECT_TEST');
threshold_dc = y(1:2:end);
plot(threshold_dc)

index_exceedance = y(2:2:end)
figure
plot(index_exceedance)

%%
clear;close all;clc;
y = data_acquisition('DB_test', 'RAW_DATA')
plot(y)

%%
clear;close all;clc;
y = data_acquisition('DB_test', 'ADC_BUFFER')
plot(y)

%% test of data analysis
clear;close all;clc;
y = data_acquisition('DB_test', 'STORAGE_VECT');
% y = data_acquisition('data_transmitter_side', 'STORAGE_VECT');
% y1 = data_acquisition('DB_test_beacon', 'STORAGE_VECT');
% y = y(1:5000);
B = 5e3;
figure(1)
t = (0:length(y)-1)/B;
plot(t, y); plot_grid();
xline(59*64/5e3)
xline(60*64/5e3)
title('abs_corr_vals')
% Nframe = 312;
Nframe = length(y)/64;
% y_test = data_acquisition('data_transmitter_side', 'STORAGE_VECT_TEST');
y_test = data_acquisition('DB_test', 'STORAGE_VECT_TEST');
% y_test = data_acquisition('DB_test_beacon', 'STORAGE_VECT_TEST');
threshold_dc = y_test(1:2:Nframe*2);
index_max = y_test(2:2:Nframe*2);
% abs_corr_time = y_test(3:3:Nframe*3);

threshold_dc = threshold_dc(end-Nframe+1:end);
% index_max = index_max(end-Nframe+1:end);
% abs_corr_time = abs_corr_time(end-312+1:end);
hold on;
Y = expand_threshold(threshold_dc, Nframe);
ty = (0:length(Y)-1)/B;
plot(ty, Y, 'r', 'linewidth', 1.5);
% N = length(y)/64;
% for i = 1:N
%     xline((i-1)*64)
% end

% Nframe = 312;
% figure(2);
% subplot(2,1,1)
% plot(y);
% plot_grid();
% hold on;
% threshold_dc = expand_threshold(threshold_dc, 312);
% plot(threshold_dc, 'r', 'linewidth', 1.5)
% for i = 1:Nframe
%     index_max(i) = index_max(i) + (i-1) * 64;
% end %for
% y(Nframe*64+1:end) = [];
% y_re = reshape(y, 64, Nframe);
% [y_max index] = max(y_re);
% for i = 1:Nframe
%     index(i) = index(i) + (i-1) * 64;
% end %for
% subplot(2,1,2)
% plot(index, y_max, '*'); plot_grid();
% hold on;
% plot(index_max, abs_corr_time, 'o');
% title('frame max comparison')


%% showing the importance of avoiding the interference, lift the scale factor
%% make the threshold skip over the first exceedance
clear;close all;clc;
y = data_acquisition('data_DB_test', 'STORAGE_VECT');
y_test = data_acquisition('data_DB_test', 'STORAGE_VECT_TEST');

% y = data_acquisition('data_transmitter_1st_hardware', 'STORAGE_VECT');
% y = data_acquisition('DB_test_beacon', 'STORAGE_VECT');
y = y(13*64:15*64);
B = 5e3;
plot(y)
hold on;
threshold_dc = y_test(1:2:end);
thres = expand_threshold(threshold_dc(13:15),3);
plot(thres)

%%
clear;close all;clc;
% y1 = data_acquisition('DB_test_beacon', 'THRESHOLD');
y = data_acquisition('DB_test', 'THRESHOLD');

plot(y)

%%
clear;close all;clc;
y1 = data_acquisition('DB_test_beacon', 'THRESHOLD');
figure
plot(y1)

%% thresholding
clear;close all;clc;
% y1 = data_acquisition('DB_test_beacon', 'VALCNT');
y = data_acquisition('DB_test', 'VALCNT');

valcnt_pre = y(1:2:end);
valcnt_aft = y(2:2:end);
figure(1);
plot(valcnt_pre, 'ko-');
plot_grid;
hold on;
plot(valcnt_aft, 'r*');

%%
clear;close all;clc;
y = data_acquisition('DB_test', 'STORAGE_VECT');
y_test = data_acquisition('DB_test', 'STORAGE_VECT_TEST');
threshold_dc = y_test(1:2:end);

% y = y(32*64:37*64);
% threshold_dc = expand_threshold(threshold_dc(32:37), 5);
Fs = 160e3;
B = 5e3;
t = (0:length(y)-1)/B;
vs = 1481;
r = t * vs / 2;
% plot(t, abs(y))
figure
% plot(t, y)
plot(y)
hold on;
% plot(threshold_dc)
Nframe = 64;
N = floor(length(y)/Nframe);
for i = 1:N
    xline((i-1)*Nframe);
end
% xline(35*64/160e3);
% xline(36*64/160e3);

% % ylim([0 4000])

%%
clear;close all;clc;
% y1 = data_acquisition('DB_test_beacon', 'STORAGE_VECT_TEST');
y = data_acquisition('DB_test', 'STORAGE_VECT_TEST');
% Nframe = 300;
% y= y(1:Nframe*2);
threshold_dc = y(1:2:end);
index_exceedance = y(2:2:end);
plot(threshold_dc)
figure(2)
plot(index_exceedance)
% ylim([0 4000])

%%
clear;close all;clc;
Fs = 160e3;
% y = data_acquisition('DB_test_beacon', 'RAW_DATA');
y = data_acquisition('DB_test', 'RAW_DATA');
Nframe = 2118;
% y1 = y1(1:Nframe);
plot(y)
N = length(y)/Nframe;
for i = 1:N
    xline((i-1)*Nframe)
end

% y = data_acquisition('DB_test_beacon', 'ADC_BUFFER');
y = data_acquisition('DB_test', 'THRESHOLD');
y = circshift(y, -323);
% hold on;
% plot(y2(end-2117:end))

y = circshift(y, 323);
figure;
plot(y)




% figure
% y = y(1:2118);
% Fs = 160e3;
% pspectrum(y, Fs, 'spectrogram')


%%
clear;close all;clc;
Fs = 160e3;
% y = data_acquisition('DB_test_beacon', 'RAW_DATA');
y = data_acquisition('DB_test', 'RAW_DATA');
Nframe = 2118;
% y1 = y1(1:Nframe);
y(1:Nframe) = 0;
% plot(y, 'o-')
plot(y)

% N = length(y)/Nframe;
% for i = 1:N
%     xline((i-1)*Nframe)
% end

%%
clear;close all;clc;
y = data_acquisition('DB_test_beacon', 'STORAGE_VECT');
plot(y)
y_test = data_acquisition('DB_test_beacon', 'STORAGE_VECT_TEST');
threshold_dc = y_test(1:2:end);
Nframe = 300;
thres = expand_threshold(threshold_dc, Nframe);
hold on;
plot(thres)

%%
y = data_acquisition('DB_test_beacon', 'ADC_BUFFER');
% y = data_acquisition('DB_test', 'THRESHOLD');
y = circshift(y, -323);
% hold on;
% plot(y2(end-2117:end))

y = circshift(y, 323);
figure;
plot(y)



% figure
% y = y(1:2118);
% Fs = 160e3;
% pspectrum(y, Fs, 'spectrogram')


%%
clear;close all;clc;
Fs = 160e3;
% y = data_acquisition('DB_test_beacon', 'RAW_DATA');
y1 = data_acquisition('DB_test', 'RAW_DATA');
% B = 5e3;
% t = (0:length(y)-1)/B;
% plot(t, y)

N = floor(length(y1)/2054);
for i = 1:N
    subplot(3,3,i);
    plot(y1((i-1)*2054+1:i*2054));
    ylim([-2000 2000])
end

figure
for i = 1:N
    subplot(3,3,i)
    pspectrum(y1((i-1)*2054+1:i*2054), Fs)
end

figure
t = (0:length(y1)-1)/Fs;
t = t;
r = t * 1481 / 2;
plot(y1)
xline(0*64)
xline(1*64)
xline(2*64)
xline(85*64)
xline(86*64)
xline(87*64)
xline(88*64)
xline(246*64)
xline(247*64)
xline(248*64)

% xline(77*64)
% xline(79*64)

%% test of adc buffer
clear;close all;clc;
y = data_acquisition('DB_test', 'ADC_BUFFER');
plot(y)

%% test DB_test
clear;close all;clc;
% y = data_acquisition('DB_test', 'RANGE_EST');
y1 = get_data_sonarfile(['C:\Users\geyao\Desktop\', 'range_est_1.txt'],1);

plot(y1)
yline(mean(y1))

figure
pd = fitdist(y1, 'kernel');
x_vals = 0:0.1:5000;
y_pdf = pdf(pd, x_vals);
plot(x_vals, y_pdf, 'r-', 'linewidth', 2)
plot_grid();
[val ind] = max(y_pdf);
hold on;
p = plot([x_vals(ind) x_vals(ind)], [min(y_pdf) max(y_pdf)], 'k:', 'linewidth', 1.5)
legend(p, ['range estimation is ', num2str(x_vals(ind)), 'm'])


%% test of trigger index
clear;close all;clc;
y1 = data_acquisition('DB_test_beacon', 'TRIGGER_INDEX');
figure(1);
subplot(2,1,1)
plot(y1, 'k', 'linewidth', 2);
plot_grid();
title('trigger index variation during whole process');
subplot(2,1,2)
plot(diff(y1), 'r-', 'linewidth', 2);
title('slope of the trigger index variation curve')
plot_grid();
dpath = 'D:\onedrive\OneDrive - NTNU\SD271X Master thesis\Code\figs\test_0515\debug';

% save_fig_data(dpath, 'trigger_index', y);


%% test the time calculation for the transmitter
clear;close all;clc;
y1 = data_acquisition('DB_test', 'CORR_TIME');
threshold_dc = expand_threshold(data_acquisition('DB_test', 'THRESHOLD'),1);
index_exceedance = data_acquisition('DB_test', 'INDEX');
sgtitle('detected signal waveform - transmitter side')
subplot(2,1,1)
plot(y1, 'k', 'linewidth', 1.2);
plot_grid();
hold on;
plot(threshold_dc, 'r-', 'linewidth', 1.5)
xline(index_exceedance+1)
subplot(2,1,2)
stem(y1, 'filled', 'linewidth', 1.2);
plot_grid();
hold on;
plot(threshold_dc, 'r-', 'linewidth', 1.5)
xline(index_exceedance+1)

%% test the time calculation for the beacon
clear;close all;clc;
y1 = data_acquisition('DB_test_beacon', 'CORR_TIME');
y1 = y1(:);
N = length(y1) / 64;
threshold_dc = expand_threshold(data_acquisition('DB_test_beacon', 'THRESHOLD'), N);
index_exceedance = expand_index(data_acquisition('DB_test_beacon', 'INDEX'), N);
sgtitle('detected signal waveform - beacon side')
subplot(2,1,1)
plot(y1, 'k', 'linewidth', 1.2);
hold on;
plot_grid();
plot(threshold_dc, 'r-', 'linewidth', 1.5)
for i = 1:length(index_exceedance)
    xline(index_exceedance(i)+1)
end
subplot(2,1,2)
stem(y1, 'filled');
hold on;
plot_grid();
plot(threshold_dc, 'r-', 'linewidth', 1.5)
for i = 1:length(index_exceedance)
    xline(index_exceedance(i)+1)
end


%% file moving
clear;close all;clc;
mkdir C:\Users\geyao\Desktop\data_beacons\range_est_3;
copyfile C:\Users\geyao\Desktop\DB_test.txt C:\Users\geyao\Desktop\data_beacons\range_est_3
copyfile C:\Users\geyao\Desktop\DB_test_beacon.txt C:\Users\geyao\Desktop\data_beacons\range_est_3




