clear;close all;clc;

% acquire samples from the transducer
Fs = 160e3; B = 5e3; f0 = 47e3;
% dpath = 'C:\Users\geyao\Desktop\';
% y = get_data_sonarfile([dpath, 'DB_test.txt'],1);

% test out the downconversion of noise

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
        if (strcmp(s, '##START_DC_CONV##'))
            v_conv(:,j) = get_data_inbetween(file, '##END_DC_CONV##');
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

% v = v(:);
% v1 = v(1:2:end);
% v2 = v(2:2:end);
% v3 = v_t(:);
% figure(1);
% plot(v(1:100));
% subplot(3,1,2);plot(v2)
% subplot(3,1,3);plot(v3)

%% TEST DATA
clear;close all;clc;
dpath = 'C:\Users\geyao\Desktop\';
% tic;
% y = get_data_sonarfile([dpath, 'data_tube_AP.txt'],1);
% toc
tic;
y = load([dpath, 'data_tube_AP.dat']);
toc
% plot(y(1.7e4:2.2e4))
plot(y)

%% 
fid = fopen([dpath, 'data_tube_single_pulse.dat'], 'w+');
fprintf(fid, "%d\n", y(1.7e4:2.2e4));
fclose(fid)
fid = fopen('data_tube_AP.dat', 'w+');
fprintf(fid, "%d\n", y);
fclose(fid)



%% CFAR sonar implementation_ initial simulation
clear;close all;clc;
% CFAR for sonar data
y = get_data_sonarfile('data_200.txt', 1);
y = y - mean(y);
y = y / max(abs(y));
y = y(50:end);
% y = y * 3/max(abs(y));
N = 1e4;
s = [zeros(0.5*N, 1); y; zeros(0.5*N, 1); y; zeros(0.5*N, 1); y;zeros(0.5*N, 1); y; zeros(0.5*N, 1)];
s = s + 0.1*wgn(length(s),1,0);
subplot(2,1,1);
plot(s);
xlim([0 length(s)])
offset = 3;
noise_std = sqrt(var(s));
threshold_fixed = noise_std * offset;
hold on; plot([0, length(s)], [threshold_fixed, threshold_fixed],'k-.', 'linewidth', 2.0);


% CFAR implemenetation

Ns = length(s);

% training samples
T = 2000;

% guard samples
G = 400;

% offset valus, for the desired SNR
offset = 4;

% create vector to hold threshold valus
threshold_cfar = [];

% signal after thresholding
signal_cfar = [];


% to slide the window to obtain the threshold and filtered signal
for i = 1:(Ns-(G+T+1))
    
    noise_level = s(i:i+T-1);
    
    threshold = sqrt(var(noise_level))*offset;
    threshold_cfar = [threshold_cfar, {threshold}];
    
    % pick the CUT T+G away from the noise cells
    signal = s(i+T+G);
    
    if (signal<threshold)
        signal = 0;
    end %if
    
    signal_cfar = [signal_cfar, {signal}];
    
end

plot(cell2mat(circshift(threshold_cfar, G)), 'r-', 'linewidth', 1.5);
legend('signal', 'fixed threshold', 'CFAR threshold')
title('comparison between CFAR and fixed thresholds')
subplot(2,1,2); title('detection')
plot(cell2mat(circshift(signal_cfar, (T+G))), 'g*-', 'linewidth', 1.5);

















