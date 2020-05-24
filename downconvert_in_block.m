function Xbase = downconvert_in_block(adc_1, adc_2, fc, Fs, B)
Nsample = 4096;
Nbpad = 3;
Nfwpad = 3;

ADCRES = pow2(12);
Scale = 1023;

% filter setup ============================================================

% Ntaps=60; % Gives very smooth low pass down sampled signal
Ntaps=6;   % Gives an ok signal        
Fp  = B/2;       % Passband-edge at B/2 (edge of signal bandwidth)
Rp  = 0.0057565; % Corresponds to 0.01 dB peak-to-peak ripple (from matlab)
Rst = 1e-3;       % Corresponds to 80 dB stopband attenuation (from matlab)
filt = firceqrip(Ntaps,Fp/(Fs/2),[Rp Rst],'passedge'); % eqnum = vec of coeffs
% fvtool(filt,'Fs',Fs,'Color','White') % Visualize filter
Nfilt=length(filt); 
filt_ADC = sig2FXP(filt, ADCRES);
filt_ADCc = re2complex(filt_ADC);
filt_ADCc = rescale_minC(filt_ADCc, 100);

% end of filter setup =====================================================

Nx1 = length(adc_1)-Nfwpad-Nbpad;
Nx2 = length(adc_2)-Nfwpad-Nbpad;

adc_1_c = re2complex(adc_1);
adc_2_c = re2complex(adc_2);

% adc_1_c = rescale_minC(adc_1_c, Scale);
% adc_2_c = rescale_minC(adc_2_c, Scale);

Nx1pad = length(adc_1_c.re);
Nx2pad = length(adc_2_c.re);

xdc1.re = sig2FXP(cos(2*pi*(0:Nx1pad-1)*fc/Fs),ADCRES); % 16bit
xdc1.im = sig2FXP(sin(-2*pi*(0:Nx1pad-1)*fc/Fs),ADCRES); % 16bit

xdc2.re = sig2FXP(cos(2*pi*(0:Nx2pad-1)*fc/Fs),ADCRES); % 16bit
xdc2.im = sig2FXP(sin(-2*pi*(0:Nx2pad-1)*fc/Fs),ADCRES); % 16bit

Xadc1 = mult_complexC(xdc1, adc_1_c);
Xadc2 = mult_complexC(xdc2, adc_2_c);

Xadc1 = rescale_maxC(Xadc1, Scale);
Xadc2 = rescale_maxC(Xadc2, Scale);

Xadclp1 = filterC(Xadc1, filt_ADCc, Nx1, Nfilt);
Xadclp2 = filterC(Xadc2, filt_ADCc, Nx2, Nfilt);

% Xadclp1 = rescale_maxC(Xadclp1, pow2(15)-1);
% Xadclp2 = rescale_maxC(Xadclp2, pow2(15)-1);

Xadclp1.re = filt_derot(Xadclp1.re, Ntaps);
Xadclp1.im = filt_derot(Xadclp1.im, Ntaps);

Xadclp2.re = filt_derot(Xadclp2.re, Ntaps);
Xadclp2.im = filt_derot(Xadclp2.im, Ntaps);

p=1; q=floor(Fs/B); % Downconverted signal sampled at B Hz
Fslr=Fs/q; dtlr=1/Fslr;

Xbase1.re = resample(Xadclp1.re, p, q);
Xbase1.im = resample(Xadclp1.im, p, q);
        
Xbase2.re = resample(Xadclp2.re, p, q);
Xbase2.im = resample(Xadclp2.im, p, q);
% 
Xbase1 = rescale_maxC(Xbase1, pow2(15)-1);
Xbase2 = rescale_maxC(Xbase2, pow2(15)-1);

Xbase = [absC(Xbase1), absC(Xbase2)];

end 