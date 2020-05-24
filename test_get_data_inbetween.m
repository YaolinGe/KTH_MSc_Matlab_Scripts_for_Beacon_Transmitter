%% this section extracts corresponding values from the adc buffer
clear;close all;clc;
Fs = 160e3;

dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'DB_test.txt'];
file = fopen(filename);
s = fgetl(file);
i = 1;
j = 1;
k = 1;
l = 1;
m = 1;
while (ischar(s)&&~feof(file))
    if (strcmp(s,'##START_ADC_BUFFER##'))
        v(:,i) = get_data_inbetween(file, '##END_ADC_BUFFER##');
        i = i + 1;
    else
        if (strcmp(s, '##START_ADC_CPY##'))
            v_cpy(:,j) = get_data_inbetween(file, '##END_ADC_CPY##');
            %             flag = 1;
            j = j + 1;
        else
            if (strcmp(s, '##START_ADC_SHI##'))
                v_shi(:,k) = get_data_inbetween(file, '##END_ADC_SHI##');
                %             flag = 1;
                k = k + 1;
            else
                if (strcmp(s, '##START_ADC_LP##'))
                    v_lp(:,l) = get_data_inbetween(file, '##END_ADC_LP##');
                    %             flag = 1;
                    l = l + 1;
                else
                    if (strcmp(s, '##START_DC_BUFFER##'))
                        v_dc(:,m) = get_data_inbetween(file, '##END_DC_BUFFER##');
                        %             flag = 1;
                        m = m + 1;
                    end
                end
            end
        end %if
    end
    s = fgetl(file);
end

% save the received echo so to avoid to redo the operation over and over
% again
% v = v(:);
% dpath = 'C:\Users\geyao\Desktop\';
% % filename = [dpath, 'test_dc_echo_tube.txt'];
% % filename = [dpath, 'DB_test.txt'];
% filename = [dpath, 'DC_test_tube.txt'];
% fid = fopen(filename, 'w+');
% fprintf(fid, "%d;\n", v_dc);
% fclose(fid);
cpy.re = v_cpy(1:2:end);
cpy.im = v_cpy(2:2:end);

shi.re = v_shi(1:2:end);
shi.im = v_shi(2:2:end);

lp.re = v_lp(1:2:end);
lp.im = v_lp(2:2:end);

dc.re = v_dc(1:2:end);
dc.im = v_dc(2:2:end);

Fs = 160e3;
t = (0:length(cpy.re)-1)/Fs;
dcFs = 5e3;
tdc = (0:length(dc.re)-1)/dcFs;

figure(1); 
subplot(2,2,1);
plot(t, absC(rescale_minC(cpy, max(abs(v))))); hold on;
subplot(2,2,2);
plot(t, absC(rescale_minC(lp, max(abs(v)))), 'ro-');
subplot(2,2,3);
plot(t, lp.im, 'ro-');
subplot(2,2,4);
plot(tdc, absC(rescale_minC(dc, max(abs(v)))), 'ko-');


figure(2);
subplot(3,1,1);
plot_freq_spectrum(cpy.re, Fs, 0, 0, 0, 0, 0);
subplot(3,1,2);
plot_freq_spectrum(shi.im, Fs, 0, 0, 0, 0, 0);
subplot(3,1,3);
plot_freq_spectrum(lp.im, Fs, 0, 0, 0, 0, 0);


figure(3);
plot_freq_spectrum(lp.re, Fs, 0, 0, 0, 1, 0); hold on;
plot_freq_spectrum(lp.im, Fs, 0, 0, 0, 1, 0);


%% small debug
clear;close all;clc;
Fs = 160e3;

dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'data_200.txt'];
y = get_data_sonarfile(filename, 1);
plot(y);

plot_freq_spectrum(y, Fs, 0, 0, 1, 1, 0)

