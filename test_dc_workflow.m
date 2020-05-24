clear;close all;clc;


% ========================== receiver data ================================


% Acquire data ============================================================
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'DB_dc_data.txt'];
file = fopen(filename);
s = fgetl(file);
i = 1;
j = 1;
k = 1;
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
            if (strcmp(s, '##START_DC_BUFFER##'))
                v_dc(:,k) = get_data_inbetween(file, '##END_DC_BUFFER##');
                %             flag = 1;
                k = k + 1;
            end
        end %if
    end
    s = fgetl(file);
end

% Simulation of downsampling ==============================================
Fs = 160e3; B = 5e3; f0 = 47e3;
ADCRES = pow2(12);
INGAIN = .1;
dfile = get_data_sonarfile([dpath, 'test_dc_echo_tube.txt'],1); % input data to simulate
DC = v_dc;
Npoints = length(dfile);
ADC = transpose(dfile(1:Npoints)); % ADC input ready 
ADC = sig2ADC(ADC, ADCRES, INGAIN); 
ADC = ADC - mean(ADC); 
Nadc = length(ADC);
ADCpad=filter_prepad(ADC,0,7);
ADCc = re2complex(ADCpad);
Nadcpad = length(ADCpad);

% Downconversion exponential signal
ADCdc.re=sig2FXP(cos(2*pi*(0:Nadcpad-1)*f0/Fs),ADCRES); % 16bit
ADCdc.im=sig2FXP(sin(-2*pi*(0:Nadcpad-1)*f0/Fs),ADCRES); % 16bit
figure(1); subplot(3,1,1)
plot_freq_spectrum(ADC, Fs, 0, 0, 0, 1, 0); title("original PSD")

% Downshift
INdc=mult_complexC(ADCdc,ADCc); % Store in 32 bit
INdc = rescale_maxC(INdc, 100);
subplot(3,1,2);
plot_freq_spectrum(INdc.re, Fs,0, 0, 0, 1, 0); title("downshifted PSD");

% Lowpass filtering
% Ntaps=60; % Gives very smooth low pass down sampled signal
Ntaps=6;   % Gives an ok signal        
Fp  = B/2;       % Passband-edge at B/2 (edge of signal bandwidth)
Rp  = 0.0057565; % Corresponds to 0.01 dB peak-to-peak ripple (from matlab)
Rst = 1e-3;       % Corresponds to 80 dB stopband attenuation (from matlab)
fircoef = firceqrip(Ntaps,Fp/(Fs/2),[Rp Rst],'passedge'); % eqnum = vec of coeffs
% fvtool(filt,'Fs',Fs,'Color','White') % Visualize filter
Nfilt=length(fircoef); 
filt_ADC=sig2FXP(fircoef,ADCRES); % Make into fixed point implmenetation (integers)

fircoef_ADC = sig2FXP(fircoef, ADCRES);
fircoef_ADCc = re2complex(fircoef_ADC);
fircoef_ADCc = rescale_minC(fircoef_ADCc, 100);

INdclp=filterC(INdc,fircoef_ADCc,Nadc,7);
INdclp=rescale_maxC(INdclp,2^15-1);

subplot(3,1,3);
plot_freq_spectrum(INdclp.re, Fs, 0, 0, 0, 1, 0); title("lowpass filtered PSD");

% Resample the signal so to 
p = 1;
q = Fs/B;
INbaseband.re=resample(INdclp.re,p,q);
INbaseband.im=resample(INdclp.im,p,q);
Nsb = length(INbaseband.re);
Fsnew = B;
dtB = 1/B;
dt = 1/Fs;
figure(2);
plot((0:Nadc - 1)*dt, abs(ADC)); hold on;
p1=plot((0:Nadc-1)*dt, absC(rescale_maxC(INdclp, max(abs(ADC)))), '-or');
p2 = plot((0:Nsb-1)*dtB, absC(rescale_maxC(INbaseband, max(abs(ADC)))),'-ok');
p3 = plot((0:length(DC)-1)*dtB, DC*max(abs(ADC))/max(abs(DC)),'-og');
legend([p1,p2,p3],'lowpassed Matlab', 'Downsampled Matlab', 'Downsampled Hardware')




%% ========================= receiver data ================================
clear;close all;clc;
% Acquire data ============================================================
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'DB_test.txt'];
file = fopen(filename);
s = fgetl(file);
Fs = 160e3;
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

y = v;
fid = fopen([dpath, 'DB_ref_test.txt'], 'w+');
fprintf(fid, "%d;\n",y);
fclose(fid);

cpy.re = v_cpy(1:2:end);
cpy.im = v_cpy(2:2:end);

shi.re = v_shi(1:2:end);
shi.im = v_shi(2:2:end);

lp.re = v_lp(1:2:end);
lp.im = v_lp(2:2:end);

dc.re = v_dc(1:2:end);
dc.im = v_dc(2:2:end);

dcFs = 5e3;
t = (0:length(y)-1)/Fs;
figure(1); subplot(4,2,1); plot(y); title('ref signal original'); xlabel('samples');
subplot(4,2,2); plot_freq_spectrum(y, Fs, 0, 0, 0, 1, 0);
t = (0:length(shi.re)-1)/Fs;
subplot(4,2,3); plot(t, absC(shi)); title('prepadded signal'); xlabel('samples');
subplot(4,2,4); plot_freq_spectrum(shi.re, Fs, 0, 0, 0, 1, 0);
t = (0:length(lp.re)-1)/Fs;
subplot(4,2,5); plot(t, absC(lp), 'ro-'); title('prepadded signal'); xlabel('samples');
subplot(4,2,6); plot_freq_spectrum(lp.re, Fs, 0, 0, 0, 1, 0);
tdc = (0:length(dc.re)-1)/dcFs;
subplot(4,2,7); plot(tdc, absC(dc)); title('prepadded signal'); xlabel('samples');
subplot(4,2,8); plot_freq_spectrum(dc.re, Fs, 0, 0, 0, 1, 0);


figure(2); hold on;
t = (0:length(y)-1)/Fs;
plot(t, abs(y)); title('ref signal original'); xlabel('samples');
t = (0:length(lp.re)-1)/Fs;
% plot(t, absC(rescale_maxC(lp, max(abs(y)))), 'ro-'); title('lowpassed signal'); xlabel('samples');
plot(t, absC(lp)*max(abs(y))/max(absC(lp)), 'ro-'); title('lowpassed signal'); xlabel('samples');
t = (0:length(dc.re)-1)/dcFs;
% plot(t, absC(rescale_maxC(dc, max(abs(y)))), 'ko-'); title('downsampled signal'); xlabel('samples');
plot(t, absC(dc)*max(abs(y))/max(absC(dc)), 'ko-'); title('downsampled signal'); xlabel('samples');

%%
clear;close all;clc;
y = get_data_sonarfile('DB_test.txt',1);
plot(y); 
Fs = 160e3;
figure();plot_freq_spectrum(y, Fs, 0, 0, 0, 1, 0)
dc_simulation('DB_test.txt')






