% function [Xbase, x1re, x1im, x2re, x2im, x3re, x3im, x4re, x4im] = downconvert_adc_buffer(adc_buffer_prepad, fc, Fs, B)
function [Xbase, Xadc, Xadclp, x3, x4] = downconvert_adc_buffer(adc_buffer_prepad, fc, Fs, B)

Nbpad = 3;
Nfwpad = 3;

rescale_dc_fxp = 511;
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
filt_ADC = sig2FXP(filt, ADCRES*2048*2048);
filt_ADCc = re2complex(filt_ADC);
% disp("1st rescale")
% disp(filt_ADCc.re)
filt_ADCc = rescale_maxC(filt_ADCc, 2048);
% disp(filt_ADCc.re)

% end of filter setup =====================================================

Nx = length(adc_buffer_prepad)-Nfwpad-Nbpad;

adc_c = re2complex(adc_buffer_prepad);

Nxpad = length(adc_c.re);

xdc.re = sig2FXP(cos(2*pi*(0:Nxpad-1)*fc/Fs),rescale_dc_fxp); % 16bit
xdc.im = sig2FXP(sin(-2*pi*(0:Nxpad-1)*fc/Fs),rescale_dc_fxp); % 16bit

% disp('===================================================')

% disp('max value of xdc.re is '); disp(max(xdc.re));
% disp('max value of xdc.im is '); disp(max(xdc.im));
% disp('max value of adc_c.re is '); disp(max(adc_c.re));
% disp('max value of adc_c.im is '); disp(max(adc_c.im));

Xadc = mult_complexC(xdc, adc_c);
% disp('max value of Xadc.re is '); disp(max(Xadc.re));
% disp('max value of Xadc.im is '); disp(max(Xadc.im));

% disp("2nd rescale")

Xadc = rescale_maxC(Xadc, Scale);
% disp('max value of Xadc.re is '); disp(max(Xadc.re));
% disp('max value of Xadc.im is '); disp(max(Xadc.im));

% x1re = Xadc.re;
% x1im = Xadc.im;

% disp("filt_ADCc is listed as follows");
% disp(filt_ADCc.re)
% disp(filt_ADCc.im)

Xadclp = filterC(Xadc, filt_ADCc, Nx, Nfilt);
% x2re = Xadclp.re;
% x2im = Xadclp.im;

% Xadclp = rescale_maxC(Xadclp, Scale);

% disp('max value of filt_ADCc.re is '); disp(max(filt_ADCc.re));
% disp('max value of filt_ADCc.im is '); disp(max(filt_ADCc.im));
% 
% disp('max value of Xadclp.re is '); disp(max(Xadclp.re));
% disp('max value of Xadclp.im is '); disp(max(Xadclp.im));
% 
% disp('===================================================')

% Xadclp.re = filt_derot(Xadclp.re, Ntaps);
% Xadclp.im = filt_derot(Xadclp.im, Ntaps);

p=1; q=floor(Fs/B); % Downconverted signal sampled at B Hz
Fslr=Fs/q; dtlr=1/Fslr;

% Xadclp_abs = absC(Xadclp);
% Xbase = resample(Xadclp_abs, p, q);

Xbase.re = resample(Xadclp.re, p, q);
Xbase.im = resample(Xadclp.im, p, q);
x3.re = Xbase.re;
x3.im = Xbase.im;
% disp("3rd rescale")

Xbase = rescale_maxC(Xbase, Scale);
x4.re = Xbase.re;
x4.im = Xbase.im;

Xbase = absC(Xbase);
end 