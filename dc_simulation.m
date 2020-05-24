function [ADC] = dc_simulation(index, filename)
ADCRES = pow2(12);
INGAIN = .1;
Fs = 160e3; 
B = 5e3; 
f0 = 50e3;

if index
    dpath = 'C:\Users\geyao\Desktop\';
    dfile = get_data_sonarfile([dpath, filename],1);
else
    dfile = get_data_sonarfile(filename,1);
end %if

Npoints = length(dfile);
ADC = transpose(dfile(1:Npoints));
ADC = sig2ADC(ADC, ADCRES, INGAIN);
ADC = ADC - mean(ADC);
Nadc = length(ADC);
ADCpad=filter_prepad(ADC,0,7);

ADCc = re2complex(ADCpad);
Nadcpad = length(ADCpad);

figure(10); subplot(3,2,1); plot(ADCc.re); 
subplot(3,2,2); plot_freq_spectrum(ADCc.re, Fs, 0, 0, 0, 1, 0)

% Downconversion exponential signal
ADCdc.re=sig2FXP(cos(2*pi*(0:Nadcpad-1)*f0/Fs),ADCRES); % 16bit
ADCdc.im=sig2FXP(sin(-2*pi*(0:Nadcpad-1)*f0/Fs),ADCRES); % 16bit

% Downconvert
INdc=mult_complexC(ADCdc,ADCc); % Store in 32 bit
INdc = rescale_maxC(INdc, 100);

subplot(3,2,3); plot(INdc.re); 
subplot(3,2,4); plot_freq_spectrum(INdc.re, Fs, 0, 0, 0, 1, 0)

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

subplot(3,2,5); plot(INdclp.re); 
subplot(3,2,6); plot_freq_spectrum(INdclp.re, Fs, 0, 0, 0, 1, 0)

p = 1;
q = Fs/B;

% Resample the downconverted signal to B sampling rate
INbaseband.re=resample(INdclp.re,p,q);
INbaseband.im=resample(INdclp.im,p,q);
Nsb = length(INbaseband.re);

Fsnew = B;
dtB = 1/B;
dt = 1/Fs;
plot((0:Nadc - 1)*dt, abs(ADC));
hold on;
plot((0:Nadc-1)*dt, absC(rescale_maxC(INdclp, max(abs(ADC)))), '-or');
plot((0:Nsb-1)*dtB, absC(rescale_maxC(INbaseband, max(abs(ADC)))),'-ok');

end