function [y, t] = signal_dcFXP(x, fc, Fs, B)
ADCRES = pow2(12);
x_shift = sig_shiftFXP(x, fc, Fs);

M = 6;
fc = B/Fs;
fs = fc*1.1;
f = [0 fc fs 1];
a = [1 1 0 0];
n = 6;
fircoef = firls(n, f, a);
fircoef_ADC = sig2FXP(fircoef, ADCRES);
fircoef_ADCc = re2complex(fircoef_ADC);
fircoef_ADCc = rescale_minC(fircoef_ADCc, 100);

y=filterC(x_shift,fircoef_ADCc,length(x),7);
y=rescale_maxC(y,2^15-1);

p = 1;
q = Fs/B;

y.re = resample(y.re, p, q);
y.im = resample(y.im, p, q);

Fsnew = B;
dtB = 1/B;
t = (0:length(y.re)-1)/Fsnew;

end

function [y,t] = sig_shiftFXP(x, fc, fs)
ADCRES = pow2(12);
x_pad = filter_prepad(x,0,7);
xc = re2complex(x_pad);
t = (0:length(xc)-1)/fs;
dc.re=sig2FXP(cos(2*pi*fc*t),ADCRES); % 16bit
dc.im=sig2FXP(sin(-2*pi*fc*t),ADCRES); % 16bit
y=mult_complexC(dc,xc); % Store in 32 bit
end