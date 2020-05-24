%% DC STREAMING IMPLEMENTATION
clear;close all;clc;

% acquire samples from the transducer
Fs = 160e3; B = 5e3; f0 = 50e3;
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'PL_DC_perfect_data.txt'];
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
        if (strcmp(s, '##START_DC_BUFFER##'))
            v_dc(:,j) = get_data_inbetween(file, '##END_DC_BUFFER##');
            %             flag = 1;
            j = j + 1;
        else
            if (strcmp(s, '##START_DC_VALS##'))
                v_dc(:,k) = get_data_inbetween(file, '##END_DC_VALS##');
                %             flag = 1;
                k = k + 1;
            else
                if (strcmp(s, '##TEST_ADC_BUFFER##'))
                    v_t(:,l) = get_data_inbetween(file, '##END_TEST_BUFFER##');
                    %             flag = 1;
                    l = l + 1;
                end
            end     
        end %if
    end
    s = fgetl(file);
end

v = v(:);
v_dc = v_dc(:);

figure(1); 
plot(v)
% figure(2)
% plot(v_dc)

fc = 47e3;
Fs = 160e3;
B = 5e3;
V = signal_dc(v, fc, Fs, B);

plot_dc_output(v, fc, v_dc, B)

figure(3);
z = absC(V);
sgtitle('downconversion comparison')
subplot(1,2,1)
% plot(z(1:256))
plot(z)
grid on; grid minor; box on;
% xlim([1, 256])
title('dc_vals from matlab')
subplot(1,2,2)
t = scale_dc(v_dc, V);
% plot(t(1:256))
plot(t)
grid on; grid minor; box on;
% xlim([1, 256])
title('dc_vals from the hardware')

% figure(4); subplot(1,2,1); plot_freq_spectrum(v_dc, B, 0, 0, 1, 1, 0);
% subplot(1,2,2); plot_freq_spectrum(z, B, 0, 0, 1, 1, 0)
