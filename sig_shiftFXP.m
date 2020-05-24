function [y,t] = sig_shiftFXP(x, fc, fs)
ADCRES = pow2(12);
x_pad = filter_prepad(x,0,7);
xc = re2complex(x_pad);
t = (0:length(xc)-1)/fs;
dc.re=sig2FXP(cos(2*pi*fc*t),ADCRES); % 16bit
dc.im=sig2FXP(sin(-2*pi*fc*t),ADCRES); % 16bit
y=mult_complexC(dc,xc); % Store in 32 bit
end