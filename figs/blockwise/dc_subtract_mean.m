%% BLOCK WISE IMPLEMENTATION
% DC STREAMING IMPLEMENTATION
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
        if (strcmp(s, '##START_DC_BUFFER##'))
            v_dc(:,j) = get_data_inbetween(file, '##END_DC_BUFFER##');
            %             flag = 1;
            j = j + 1;
        else
            if (strcmp(s, '##START_CPY##'))
                v_cpy(:,k) = get_data_inbetween(file, '##END_CPY##');
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

