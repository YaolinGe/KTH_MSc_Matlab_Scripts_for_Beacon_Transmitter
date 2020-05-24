clear;close all;clc;

dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'capture_sd_10000.txt'];
filename1 = [dpath, 'capture_sd_00.txt'];
filename2 = [dpath, 'capture_sd_5000.txt'];
% filename3 = [dpath, 'capture.txt'];

y = get_data_sonarfile(filename, 1);
y1 = get_data_sonarfile(filename1, 1);
y2 = get_data_sonarfile(filename2, 1);
% y3 = get_data_sonarfile(filename3,1);

fs = 160e3;
% t_delay = 2000e-6;
% t_delay = 300e-6;

t_delay = (10000)*1e-6;
t = (0:length(y)-1)/fs+t_delay;

t_delay = 0;
t1 = (0:length(y1)-1)/fs+t_delay;

t_delay = 5845*1e-6;
t2 = (0:length(y2)-1)/fs+t_delay;

vsound = 343;
range = vsound * t/2;
range1 = vsound * t1/2;
range2 = vsound * t2/2;



figure(1); plot(range1(range1<5), y1(range1<5),'b',range2(range2<5), y2(range2<5),'g', range(range<5), y(range<5),'r'); grid on; grid minor; box on; 
title('Delay comparison'); xlabel('distance [m]'); ylabel('quantization level');
xlim([0 5]); 
legend('zero delay','5000 microseconds delay','10000 microseconds delay');
% legend('zero delay','5845 microseconds delay','10000 microseconds delay');
matlab2tikz('test.tex');
% figure(2);
% 
% plot(1:length(y),y);
% 
% figure(2);
% plot_freq_spectrum(y, fs, 0, 0, 1, 1, 1);
% 
% 
% figure(3);
% pspectrum(y, fs, 'spectrogram')