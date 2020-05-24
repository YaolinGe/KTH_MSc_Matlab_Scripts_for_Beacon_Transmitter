clear;close all;clc;

Fs = 160e3; B = 5e3; fc = 47e3;
% get sonar data file
y = load('data_tube_single_pulse.dat');
y_AP = load('data_tube_AP.dat');
% plot(y)
% plot(y_AP)


y = y - mean(y);
y_AP = y_AP - mean(y_AP);
y = y / max(abs(y));
y_AP = y_AP / max(abs(y_AP));


% illustrate the received echo from the tube
figure(1);  sgtitle('time series of received signal')
subplot(2,1,1);plot((0:length(y)-1)/Fs, y); title('single pulse'); xlim([0 length(y)/Fs]); 
xlabel('time [s]')
subplot(2,1,2);plot((0:length(y_AP)-1)/Fs, y_AP); title('full time series'); xlim([0 length(y_AP)/Fs])
xlabel('time [s]')

figure(2);
plot_freq_spectrum(y, Fs, 0, 0, 0, 1, 0)

% f = (0:length(y)-1)*Fs/length(y);

% Y =  abs(fft(y));
% figure(3)
% plot_peaks(f, Y)


%% CFAR for different Matlab simulation cases

clear;close all;clc;
Ns = 1000;
s = randn(Ns, 1);
s([100, 200, 300, 700]) = [8, 9, 4, 11];
y = load('data_tube_single_pulse.dat');
% y = load('data_tube_AP.dat');
% y =  y(1e4:3e4);
Ns = length(y);
% y = y - mean(y);
% y_AP = y_AP - mean(y_AP);
% y = y / max(abs(y));
% y = abs( y / max(abs(y)));
% y_AP = y_AP / max(abs(y_AP));

figure(1);
plot(y); title('time series data'); grid on; grid minor; box on;
xlabel('samples'); xlim([0 length(y)]);

T = 2000;
G = 200;

offset = 1;


% threshold calculation
[threshold, signal]= ThresWind(y, T, G, offset);
[threshold_var, signal_var]= ThresWindVar(y, T, G, offset);
[thresholdlong, signal_long]= ThresLong(y, offset);
[thresholdlong_var, signal_long_var]= ThresLongVar(y,offset);
% ========================================================================
% [CA_threshold_cfar, CA_signal_cfar]= CA_CFAR(y, T, G, offset);
% [CAGO_threshold_cfar, CAGO_signal_cfar]= CAGO_CFAR(y, T, G, offset);
% [CASO_threshold_cfar, CASO_signal_cfar]= CASO_CFAR(y, T, G, offset);
% [CAOS_threshold_cfar, CAOS_signal_cfar]= CAOS_CFAR(y, T, G, offset);
% CA_long= CA_Long(y, offset);
% ========================================================================


figure(2); 
plot(y); xlim([0, length(y)]); xlabel('samples'); 
hold on; grid on; box on; 
plot(1:length(threshold), threshold, 'g-.', 'linewidth', 2);
plot(1:length(threshold_var), threshold_var, 'r-.', 'linewidth', 2);
plot(1:length(thresholdlong), thresholdlong, 'c-.', 'linewidth', 2);
plot(1:length(thresholdlong_var), thresholdlong_var, 'k-.', 'linewidth', 2);
legend('signal', 'sliding window threshold (cell averaging)', 'sliding window threshold(cell variance)',...
    'long time frame averaging (cell averaging)', 'long time frame averaging (cell variance)');
% ========================================================================
% hold on; plot(cell2mat(circshift(threshold_cfar, G)), 'r--', 'linewidth', 2);
% plot(cell2mat(circshift(CA_threshold_cfar, G)), 'r--', 'linewidth', 2);
% plot(cell2mat(circshift(CAGO_threshold_cfar, G)), 'g-', 'linewidth', 2);
% plot(cell2mat(circshift(CASO_threshold_cfar, G)), 'b-', 'linewidth', 2);
% plot(cell2mat(circshift(CAOS_threshold_cfar, G)), 'k-.', 'linewidth', 2);
% plot([1:length(CA_long)], CA_long, 'c-.', 'linewidth', 2);
% subplot(2,1,2);
% plot(cell2mat(circshift(signal_cfar, (T+G))), 'g--', 'linewidth',2);
% ========================================================================



%% Test out downconversion thing and matched filter

clear;close all;clc;
% downconversion part;
Fs = 160e3;
B = 5e3;
fc = 47*1e3;

% y = load('data_tube_AP.dat');
% y = load('data_air_long.dat');
y = load('data_air_single_pulse.dat');
y2 = load('data_tube_single_pulse.dat');
t = (0:length(y)-1)/Fs;
y = y - mean(y);

t2 = (0:length(y2)-1)/Fs;
% y2 = y2 - mean(y2);

% yex = y(2.62e5:2.65e5);
% fid = fopen('data_air_single_pulse.dat', 'w+');
% fprintf(fid, '%d\n', yex);
% fclose(fid);

% ========================================================================
% plot the receivd signal analysis
figure(1);
sgtitle('air received signal analysis')
subplot(2,2,1); plot(y); title('data from the air path(single pulse)');
xlim([0 length(y)]);
xlabel('samples')
subplot(2,2,2); pspectrum(y, Fs, 'spectrogram');
subplot(2,2, [3 4]);pspectrum(y, Fs);

figure(2);
sgtitle('tube received signal analysis')
subplot(2,2,1); plot(y2); title('data from the air path(single pulse)');
xlim([0 length(y2)]);
xlabel('samples')
subplot(2,2,2); pspectrum(y2, Fs, 'spectrogram');
subplot(2,2, [3 4]);pspectrum(y2, Fs);
% ========================================================================
% 

%%

% thr = 40;
% y(y<thr) = 0;

figure(1);
sgtitle('received signal analysis')
% subplot(3,2,[1 2]);
plot(y); title('data from the tube');


%%
xlim([0 length(y)]);
xlabel('samples')

subplot(3,2, 3); plot(y(1.7e4:2.1e4)); grid on; grid minor; box on; 
subplot(3,2, 4); plot(y(1.38e5:1.395e5));grid on; grid minor; box on; 
subplot(3,2, 5); plot(y(2.98e5:3.03e5));grid on; grid minor; box on;
subplot(3,2, 6); plot(y(4.17e5:4.22e5));grid on; grid minor; box on; 


%%
ydc = signal_dc(y, fc, Fs, B);

dcFs = B;
Ns = length(ydc.re);
tdc = (0:Ns-1)/dcFs;
ydc_plot = absC(rescale_maxC(ydc, max(abs(y))));

figure(2);
subplot(3,2,[1 2]); plot(t, abs(y)); hold on; plot(tdc, ydc_plot, 'ro-');
grid on; grid minor; box on;
title('downconverted received data analysis'); 
xlabel('time');


vdc1 = 500:700;
vdc2 = 4300:4380;
vdc3 = 9300:9500;
vdc4 = 1.3e4:1.32e4;

v1 = 1.7e4:2.1e4;
v2 = 1.38e5:1.395e5;
v3 = 2.98e5:3.03e5;
v4 = 4.17e5:4.22e5;

subplot(3,2, 3); plot(t(v1), abs(y(v1))); grid on; grid minor; box on; hold on; plot(tdc(vdc1), ydc_plot(vdc1), 'ro-')
subplot(3,2, 4); plot(t(v2),abs(y(v2)));grid on; grid minor; box on; hold on; plot(tdc(vdc2), ydc_plot(vdc2), 'ro-') 
subplot(3,2, 5); plot(t(v3),abs(y(v3)));grid on; grid minor; box on; hold on; plot(tdc(vdc3), ydc_plot(vdc3), 'ro-')
subplot(3,2, 6); plot(t(v4),abs(y(v4)));grid on; grid minor; box on; hold on; plot(tdc(vdc4), ydc_plot(vdc4), 'ro-')


%% Test out the downconverted signal with threshold

clear;close all;clc;
% downconversion part;
Fs = 160e3;
B = 5e3;
fc = 47e3;

% y = load('data_tube_AP.dat');
y = load('data_tube_single_pulse.dat');
t = (0:length(y)-1)/Fs;
y = y - mean(y);


T = 15;
G = 8;

offset = 2;

ydc = signal_dc_block(y, fc, Fs, B);
% y = absC(ydc);
y = ydc;

% threshold calculation
[threshold, signal]= ThresWind(y, T, G, offset);
[threshold_var, signal_var]= ThresWindVar(y, T, G, offset);
[thresholdlong, signal_long]= ThresLong(y, offset);
[thresholdlong_var, signal_long_var]= ThresLongVar(y,offset);

figure(1); 
plot(y); xlim([0, length(y)]); xlabel('samples'); 
hold on; grid on; box on; 
plot(1:length(threshold), threshold, 'g-.', 'linewidth', 2);
plot(1:length(threshold_var), threshold_var, 'r-.', 'linewidth', 2);
plot(1:length(thresholdlong), thresholdlong, 'c-.', 'linewidth', 2);
plot(1:length(thresholdlong_var), thresholdlong_var, 'k-.', 'linewidth', 2);
legend('downconverted signal', 'sliding window threshold (cell averaging)', 'sliding window threshold(cell variance)',...
    'long time frame averaging (cell averaging)', 'long time frame averaging (cell variance)');



% ========================================================================
% [CA_threshold_cfar, CA_signal_cfar]= CA_CFAR(ydc, T, G, offset);
% [CAGO_threshold_cfar, CAGO_signal_cfar]= CAGO_CFAR(ydc, T, G, offset);
% [CASO_threshold_cfar, CASO_signal_cfar]= CASO_CFAR(ydc, T, G, offset);
% [CAOS_threshold_cfar, CAOS_signal_cfar]= CAOS_CFAR(ydc, T, G, offset);
% CA_long = CA_Long(ydc, offset);
% ========================================================================


% ========================================================================
% figure(2); 
% subplot(2,1,1); grid on; grid minor; box on;
% plot(ydc); xlim([0, length(ydc)]); xlabel('samples'); 
% subplot(2,1,2); plot((0:5000), y); grid on; grid minor; box on;
% hold on; plot(cell2mat(circshift(threshold_cfar, G)), 'r--', 'linewidth', 2);
% hold on; grid on; box on; 
% plot(cell2mat(circshift(CA_threshold_cfar, G)), 'r--', 'linewidth', 2);
% plot(cell2mat(circshift(CAGO_threshold_cfar, G)), 'g-', 'linewidth', 2);
% plot(cell2mat(circshift(CASO_threshold_cfar, G)), 'b-', 'linewidth', 2);
% plot(cell2mat(circshift(CAOS_threshold_cfar, G)), 'k-.', 'linewidth', 2);
% plot([1:length(CA_long)], CA_long, 'c-.', 'linewidth', 2);
% subplot(2,1,2);
% plot(cell2mat(circshift(signal_cfar, (T+G))), 'g--', 'linewidth',2);
% legend('signal', 'CA_CFAR', 'CAGO', 'CASO', 'CAOS', 'CA_Long')
% ========================================================================



%% CFAR SONAR IMPLEMENTATION
clear;close all;clc;

% acquire samples from the transducer
Fs = 160e3; B = 5e3; f0 = 47e3;
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'data_air_threshold.txt'];
file = fopen(filename);
s = fgetl(file);
i = 1;
j = 1;
k = 1;
l = 1;
while (ischar(s)&&~feof(file))
    if (strcmp(s,'##START_ADC_THRESHOLD##'))
        v_thres(:,i) = get_data_inbetween(file, '##END_ADC_THRESHOLD##');
        i = i + 1;
    else
        if (strcmp(s, '##START_ADC_PADDED##'))
            v(:,j) = get_data_inbetween(file, '##END_ADC_PADDED##');
            %             flag = 1;
            j = j + 1;
        else
%             if (strcmp(s, '##START_DC_BUFFER##'))
%                 v_dc(:,k) = get_data_inbetween(file, '##END_DC_BUFFER##');
%                 %             flag = 1;
%                 k = k + 1;
%             else
                if (strcmp(s, '##TEST_ADC_BUFFER##'))
                    v_t(:,l) = get_data_inbetween(file, '##END_TEST_BUFFER##');
                    %             flag = 1;
                    l = l + 1;
                end
%             end     
        end %if
    end
    s = fgetl(file);
end
filename = [dpath, 'data_air_prefiltered.txt'];
y_ref = get_data_sonarfile(filename, 1);
figure(1); hold on; grid on; grid minor; box on;
title('received signal detection threshold comparison')
xlabel('samples');ylabel('12bit ADC level')
plot(y_ref);
T = 200;
G = 10;
offset = 1;
[threshold, signal]= ThresWind(y_ref, T, G, offset);
plot(threshold, 'r-.', 'linewidth', 1.5);

v_thres = v_thres(:);
plot(2*v_thres, 'b-.', 'linewidth', 1.5)
plot(v, 'y-.', 'linewidth', 1.5)

legend('signal', 'matlab_threshold', 'hardware_threshold')

%% CFAR SONAR IMPLEMENTATION
clear;close all;clc;

% acquire samples from the transducer
Fs = 160e3; B = 5e3; f0 = 47e3;
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'DB_test.txt'];
y = get_data_sonarfile(filename, 1);
filename = [dpath, 'data_air_prefiltered.txt'];
% filename = [dpath, 'data_air_single_pulse.txt'];
y_ref = get_data_sonarfile(filename, 1);
y_ref = y_ref - mean(y_ref);
t_ref = (0:length(y_ref)-1)/Fs;

y_ref_dc = signal_dc(y_ref, f0, Fs, B);
t_ref_dc = (0:length(y_ref_dc.re)-1)/B;

figure(1); hold on; grid on; grid minor; box on;
plot(t_ref, abs(y_ref));
plot(t_ref_dc, absC(rescale_maxC(y_ref_dc, max(abs(y_ref)))), 'ro-');

%%

T = 200;
G = 10;
offset = 1;
[threshold, signal]= ThresWind(y_ref, T, G, offset);
plot(threshold, 'r-.');
% plot(circshift(y, -T-G), 'b-.')
plot(2*y, 'b-.')

% fid = fopen([dpath, 'data_air_single_pulse.txt'], 'w+');
% fprintf(fid, '%d;\n', y_ref(1000:3000));
% fclose(fid);

%%
clear;close all;clc;
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'data_air_prefiltered.txt'];
y = get_data_sonarfile(filename, 1);
y1 = y(1:4096);
y2 = y(4097:end);
y2 = [y2; zeros(4096-length(y2),1)]
fc = 47e3; Fs = 160e3; B = 5e3;

Y1 = signal_dc(y1, fc, Fs, B);
Y2 = signal_dc(y2, fc, Fs, B);

Y = [absC(Y1), absC(Y2)];
% subplot(2,1,2)
figure
plot(Y, 'ko-'); hold on;
% figure
% plot(absC(Y1)); hold on;


%%%
clear;close all;clc;
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'DB_test.txt'];
% filename = [dpath, 'data_air_adcpadded.txt'];
y = get_data_sonarfile(filename, 1);
% figure
plot(y*max(absC(Y1))/max(abs(y)), 'r*-')
legend('Matlab downconversion', 'Hardware downconversion');
xlabel('samples');
title('Signal downconversion comparison')


%%
clear;close all;clc;
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'DB_test.txt'];
y = get_data_sonarfile(filename, 1);

filename = [dpath, 'data_air_PL.txt'];
y_ref = get_data_sonarfile(filename, 1);

figure(1);
plot(y_ref); title('pulse and listen signal time series');

fc = 47e3;
Fs = 160e3;
B = 5e3;
ydc = signal_dc(y_ref, fc, Fs, B);
figure(2); sgtitle('downconversion comparison matlab(upper) and hardware (lower)')
subplot(2,1,1);
t = absC(ydc);
plot(t)
subplot(2,1,2);
z = y*max(absC(ydc))/max(y);
plot(y)

figure(3);
plot_freq_spectrum(absC(ydc), B, 0, 0, 0, 1, 0)

%% DC STREAMING IMPLEMENTATION
clear;close all;clc;

% acquire samples from the transducer
Fs = 160e3; B = 5e3; f0 = 50e3;
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'DB_test.txt'];
file = fopen(filename);
s = fgetl(file);
i = 1;
j = 1;
k = 1;
l = 1;
while (ischar(s)&&~feof(file))
    if (strcmp(s,'##START_ADC_BUFFER##'))
        v(:,i) = get_data_inbetween(file, '##END_ADC_BUFFER##');
        i = i + 1;
    else
        if (strcmp(s, '##START_ADC_BUFFER_CPY##'))
            v_cy(:,j) = get_data_inbetween(file, '##END_ADC_BUFFER_CPY##');
            %             flag = 1;
            j = j + 1;
        else
            if (strcmp(s, '##START_CPY##'))
                v_cpy(:,k) = get_data_inbetween(file, '##END_CPY##');
                %             flag = 1;
                k = k + 1;
            else
                if (strcmp(s, '##START_DC_BUFFER##'))
                    v_dc(:,l) = get_data_inbetween(file, '##END_DC_BUFFER##');
                    %             flag = 1;
                    l = l + 1;
%                 else
%                     if (strcmp(s, '##START_CPYC_F##'))
%                         v_f(:,l) = get_data_inbetween(file, '##END_CPYC_F##');
%                         %             flag = 1;
%                         l = l + 1;
%                     else
%                         if (strcmp(s, '##START_IND_BACK##'))
%                             v_back(:,l) = get_data_inbetween(file, '##END_IND_BACK##');
%                             %             flag = 1;
%                             l = l + 1;
%                         end
%                     end
                end
            end     
        end %if
    end
    s = fgetl(file);
end


%% BLOCK WISE IMPLEMENTATION
% DC STREAMING IMPLEMENTATION
clear;close all;clc;
Fs = 160e3; B = 5e3; f0 = 50e3;
[v, v_dc, v_cpy] = data_acquisition('DB_test');
v_dc = v_dc(:);
% v_block = v_block(:);
v = v(:);

figure(1);
subplot(2,1,1);
plot(v);
subplot(2,1,2);
pspectrum(v, Fs)

fc = 47e3;
Fs = 160e3;
B = 5e3;
V = signal_dc(v, fc, Fs, B);

% dpath = 'C:\Users\geyao\Desktop\';
% filename = [dpath, 'data_PL_20000.txt'];
% x = get_data_sonarfile(filename, 1);
x = v;
Fs = 160e3; B = 5e3; fc = 47e3;
Xbase = signal_dc_block(x, fc, Fs, B);
tbase = (0:length(Xbase)-1)/B;

plot_dc_output(v, fc, v_dc, B)
plot(tbase, Xbase*2000/max(abs(Xbase)), 'g*-');

block = (0:4096/32/2:length(Xbase))/B;
for i = 1:length(block)
    xline(block(i));
end

figure(5);
subplot(2,1,1);
pspectrum(absC(V), B)
subplot(2,1,2)
pspectrum(Xbase, B)

v_cpy = v_cpy(:);
figure()
plot(v_cpy)

out_put_data(dpath, 'data_PL_dc', v_dc);

%% DOWNCONVERSION SENSITIVITY TEST
clear;close all;clc;
fc = 47e3;
Fs = 160e3;
B = 5e3;

y = input_data('data_PL_20000');
[Xbase, Xpad, adc_buffer, overlapsave] = signal_dc_block(y, fc, Fs, B);

tbase = (0:length(Xbase)-1)/B;

% plot(tbase, Xbase, 'g*-');
X = Xpad;
X = X';
X = X(:);

figure(1); plot(sig2FXP(y, pow2(12)));
hold on;
plot(X)

figure()
Xbase = Xbase(:);
plot(Xbase)

%% TEST THRESHOLDING
clear;close all;clc;
y = input_data('data_air_test');
% noise = data_acquisition('DB_test', 'NOISE');
% thresholds = data_acquisition('DB_test', 'THRESHOLD');

T = 20;
G = 2;
offset = 1;
threshold = ThresWind(y, T, G, offset);

figure(1);
plot(abs(y));
hold on;
plot(threshold)

% thresholds = data_acquisition('DB_test', 'THRESHOLD');
% thresholds = thresholds(:);
% plot(thresholds);


