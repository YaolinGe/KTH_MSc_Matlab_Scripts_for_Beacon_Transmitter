%% test downconvert simulation
clear;close all;clc
ADCRES = pow2(12);
INGAIN = .1;

Fs = 160e3; B = 5e3; f0 = 47e3;

dpath = 'C:\Users\geyao\Desktop\';
% filename = [dpath, 'PL_test_0322.txt'];
% dfile = get_data_sonarfile(filename,1);
% dfile = get_data_sonarfile([dpath, 'data_500.txt'],1);
dfile = get_data_sonarfile([dpath, 'test_dc_echo_tube.txt'],1);

dcfile = get_data_sonarfile([dpath, 'DC_test_tube.txt'],1); % signal ready to lp
% dclp = get_data_sonarfile([dpath, 'DC_test_tube.txt'],1); % lp result
DC = dcfile;
% dfile = get_data_sonarfile('test_dc_echo_tube.txt',1);
Npoints = length(dfile);
ADC = transpose(dfile(1:Npoints));
figure(1); 
% subplot(2,1,1); 
plot(ADC);
ADC = sig2ADC(ADC, ADCRES, INGAIN); 
ADC = ADC - mean(ADC); 
% subplot(2,1,2); plot(ADC);
Nadc = length(ADC);
ADCpad=filter_prepad(ADC,0,7);
ADCc = re2complex(ADCpad);
Nadcpad = length(ADCpad);

% Downconversion exponential signal
ADCdc.re=sig2FXP(cos(2*pi*(0:Nadcpad-1)*f0/Fs),ADCRES); % 16bit
ADCdc.im=sig2FXP(sin(-2*pi*(0:Nadcpad-1)*f0/Fs),ADCRES); % 16bit
figure(55); subplot(3,1,1)
plot_freq_spectrum(ADC, Fs, 0, 0, 0, 1, 0)

% ==================== test code ===================
% Ndcpad = length(DC(1:2:end));
% ADCdc.re=sig2FXP(cos(2*pi*(0:Ndcpad-1)*f0/Fs),ADCRES); % 16bit
% ADCdc.im=sig2FXP(sin(-2*pi*(0:Ndcpad-1)*f0/Fs),ADCRES); % 16bit
% % Downconvert
% DC_.re = DC(1:2:end)';
% DC_.im = DC(2:2:end)';
% INdc=mult_complexC(ADCdc,DC_); % Store in 32 bit
% INdc = rescale_minC(INdc, 100);
% ==================== test code ===================

% Downconvert
INdc=mult_complexC(ADCdc,ADCc); % Store in 32 bit
INdc = rescale_maxC(INdc, 100);

subplot(3,1,2);
plot_freq_spectrum(INdc.re, Fs,0, 0, 0, 1, 0)

% M = 6;
% fc = B/Fs;
% fs = fc * 1.1;
% f = [0 fc fs 1];
% a = [1 1 0 0];
% n = 6;
% fircoef = firls(n, f, a);

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

% filtering operation

% lp_r.re = dclp(1:2:end);
% lp_r.im = dclp(2:2:end);
% lp_r = rescale_maxC(lp_r,pow2(15)-1);

INdclp=filterC(INdc,fircoef_ADCc,Nadc,7);
INdclp=rescale_maxC(INdclp,2^15-1);
% % 
subplot(3,1,3);
plot_freq_spectrum(INdclp.re, Fs, 0, 0, 0, 1, 0)

% figure(10)
% % plot(absC(lp_r), 'ro-')
% hold on;
% plot(absC(INdclp), 'g*-')
% legend('hardware','matlab')

% figure(12);
% plot_freq_spectrum(lp_r.re)

% -============================ dedicated to testing =================
%
% figure(1)
% plot(INdc.re)
% INadc.re = dclp(1:2:end);
% INadc.im = dclp(2:2:end);
% INadc = rescale_minC(INadc, 100);
% hold on;
% plot(INadc.re(1:150))
% figure(2);
% plot(dcfile(1:2:end))
% figure(3);
% subplot(2,1,1); plot_freq_spectrum(dcfile(1:2:end),Fs, 1 , 0, 0, 0, 0)
% subplot(2,1,2); plot_freq_spectrum(dclp(1:2:end), Fs, 1, 0, 0, 0, 0)
% 
% figure(2);
% plot(INdc.re); hold on;
% % plot(ADC)
% plot(INadc.re);



% -============================ dedicated to testing =================


% subplot(3,1,3); plot_freq_spectrum(INdclp.re, Fs, 0, 0, 0, 1, 0)

p = 1;
q = Fs/B;

% Resample the downconverted signal to B sampling rate
INbaseband.re=resample(INdclp.re,p,q);
INbaseband.im=resample(INdclp.im,p,q);
Nsb = length(INbaseband.re);

Fsnew = B;
dtB = 1/B;
dt = 1/Fs;

figure(2);
plot((0:Nadc - 1)*dt, abs(ADC));
hold on;
p1=plot((0:Nadc-1)*dt, absC(rescale_maxC(INdclp, max(abs(ADC)))), '-or');
% plot((0:Nsb-1)*dtB, absC(rescale_maxC(INbaseband, max(abs(INbaseband.re)))),'-ok');
p2 = plot((0:Nsb-1)*dtB, absC(rescale_maxC(INbaseband, max(abs(ADC)))),'-ok');
% dc_hardware.re = DC(1:2:end);
% dc_hardware.im = DC(2:2:end);
% Ndc_hardware = length(dc_hardware.re);
p3 = plot((0:length(DC)-1)*dtB, DC*max(abs(ADC))/max(abs(DC)),'-og');
legend([p1,p2,p3],'lp_vals_matlab', 'downsampled_matlab', 'downsampled_hardware')


figure();
p3 = plot((0:length(DC)-1)*dtB, DC*max(abs(ADC))/max(abs(DC)),'-og');
% This is used to test the downsampling from the hardware
% clear;close all;clc;
% dpath = 'C:\Users\geyao\Desktop\';
% filename = [dpath, 't.txt'];
% y = get_data_sonarfile(filename, 1);
% Fs = 5000; 
% t = (0:length(y)-1)/Fs;
% ynorm = abs(y/max(abs(y)));
% figure(10)
% plot(t,ynorm,'ro-')
% % plot(t,abs(y),'ro-')

%% TEST OF DOWNSAMPLING SIMULATION
clear;close all;clc;

% ADC = dc_simulation('test_dc_echo_tube.txt')

ADC = dc_simulation('data_200.txt');
dpath = 'C:\Users\geyao\Desktop\';
Fs = 160e3; B = 5e3; f0 = 50e3;
% filename = [dpath, 'DB_test.txt'];
filename = [dpath, 'DC_test_tube.txt'];
y = get_data_sonarfile(filename, 1);
Fs = 5e3;
dt = 1/Fs;
N = length(y);
plot((0:N-1)*dt, abs(y)*max(abs(ADC))/max(abs(y)),'-*g');





%% This section used to check the long time echo acquisition, it takes a long 
%% duration to find the period of the autoping mode, 
clear;close all;clc;
dpath = 'C:\Users\geyao\Desktop\';
% filename = [dpath, 'capture_long.txt'];
filename = [dpath, 'capture.txt'];

y = get_data_sonarfile(filename, 1);
y = y(1:2:end);
Fs = 160e3;
t = (0:length(y)-1)/Fs;
vsound = 343;
range = vsound * t /2;
plot(range, y); title('receiver echo detection'); xlabel('distance [m]'); ylabel('12 bit ADC');
% plot(y(110000:130000)); title('receiver echo detection'); xlabel('sample'); ylabel('12 bit ADC');

% figure(2); plot_freq_spectrum(y, Fs, 0, 0, 0, 1, 1)


%% test of correlation
clear;close all;clc;
Fs = 160e3;
dpath = 'C:\Users\geyao\Desktop\';
% filename = [dpath, 'capture_long.txt'];
filename = [dpath, 'sig_ref.txt'];
y = get_data_sonarfile(filename, 1);
figure(1); 
plot(y);

filename = [dpath, 'capture.txt'];
yf = get_data_sonarfile(filename, 1);
f = (0:length(yf(1:2:end))-1)*Fs/length(yf(1:2:end));
figure(2);
subplot(2,1,1);
plot(f, abs(yf(1:2:end)))
subplot(2,1,2);
plot(f, abs(yf(2:2:end)));

figure(3);
plot_freq_spectrum(y, Fs, 0, 0, 0, 1, 0)

%%
% This is section is used to find the downconverted version of the
% reference signal from the hardware
clear;close all;clc;
Fs = 160e3;
dpath = 'C:\Users\geyao\Desktop\';
% filename = [dpath, 'capture_long.txt'];
filename = [dpath, 'dc_ref.txt'];
dfile = get_data_sonarfile(filename, 1);
filename2 = [dpath, 't.txt'];
y2 = get_data_sonarfile(filename2, 1);
yre = dfile(1:2:end);
yim = dfile(2:2:end);
yabs = sqrt(yre.^2+yim.^2);
% yangle = atan(yi)
figure(1); 
subplot(2,2,1)
plot(yre);title("dc ref signal real part")
subplot(2,2,2)
plot(yim); title("dc ref signal imag part")
subplot(2,2,3)
% plot_freq_spectrum(yre, Fs, 0, 0, 0,1,0)
plot_freq_spectrum(yabs, Fs, 0, 0, 0,1,0)
title("dc ref signal PSD")

subplot(2,2,4)
plot(y2); title("oritinal reference signal")
% figure(3);
% plot_freq_spectrum(yabs,Fs, 0, 0, 0, 1, 0)

filename = [dpath, 'lp_data.txt'];
dfile = get_data_sonarfile(filename, 1);
y_lp = dfile;
figure(2);
subplot(2,2,1);
% plot(abs(y_lp(1:2:end)),'ro-');
plot(y_lp(1:2:end),'ro-');

subplot(2,2,2);
plot_freq_spectrum(y_lp(1:2:end), Fs, 0, 0, 0, 1, 0)
subplot(2,2,3);
plot(y_lp(2:2:end),'ro-');
% plot(abs(y_lp(2:2:end)),'ro-');

subplot(2,2,4);
plot_freq_spectrum(y_lp(2:2:end), Fs, 0, 0, 0, 1, 0)

filename = [dpath, 'capture.txt'];
dfile = get_data_sonarfile(filename, 1);
figure(3); 
plot(dfile(1:2:end))

%% This is used to determine the downsampling of the received echo
clear;close all;clc;
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'ref_data.txt'];
y1 = get_data_sonarfile(filename, 1);
y1 = y1 - mean(y1);
Fs = 160e3;
t = (0:length(y1)-1)/Fs;
range = t * 343/2;
figure(1); plot(range, abs(y1/max(y1)))
filename = [dpath, 'rece_dc.txt'];
y2 = get_data_sonarfile(filename, 1);
y2re = y2(1:2:end);
y2re = y2re - mean(y2re);
Fs_new = 5e3;
t = (0:length(y2re)-1)/Fs_new;
range = t * 343/2;
hold on; plot(range,abs(y2re/max(y2re)))

%% This section mainly validates the downconverion for the adc_buffer
% clear;close all;clc;
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, 'data_200.txt'];
y = get_data_sonarfile(filename, 1);
Fs = 160e3;
% plot_freq_spectrum(y, Fs, 0, 0, 0, 1, 0)
figure(1);plot(y)

% filename = [dpath, 'capture.txt'];
% y_test = get_data_sonarfile(filename, 1);
% plot(y_test(1:end))
figure(66)
filename = [dpath, 'rece_dc.txt'];
y_dc = get_data_sonarfile(filename, 1);
subplot(2,2,1)
plot(y_dc(1:2:end))
title("rece_dc")

filename = [dpath, 'rece_lp.txt'];
y_lp = get_data_sonarfile(filename, 1);
subplot(2,2,2)
plot(y_lp(1:2:end))
title("rece_lp")


filename = [dpath, 'rece_glean.txt'];
y_glean = get_data_sonarfile(filename, 1);
subplot(2,2,3)
plot(y_glean(1:2:end))
title("rece_glean")


filename = [dpath, 'rece_shift.txt'];
y_shift = get_data_sonarfile(filename, 1);
subplot(2,2,4)
plot(y_shift(1:2:end))
title("rece_shift");















