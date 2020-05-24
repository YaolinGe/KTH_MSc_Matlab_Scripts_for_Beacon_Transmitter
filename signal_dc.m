function Xbase = signal_dc(x, fc, Fs, B)

%% signal_dc returns the downconverted version of the input signal

ADCRES = pow2(12);
Scale = 100;

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

if iscolumn(x)
    x = x';
end %if

% x = x - mean(x);
x = sig2FXP(x, ADCRES);
Nx = length(x);
xpad = filter_prepad(x, 0, Nfilt);
xc = re2complex(xpad);
xc = rescale_minC(xc, Scale);
Nxpad = length(xc.re);

xdc.re = sig2FXP(cos(2*pi*(0:Nxpad-1)*fc/Fs),ADCRES); % 16bit
xdc.im = sig2FXP(sin(-2*pi*(0:Nxpad-1)*fc/Fs),ADCRES); % 16bit


% x_shift = sig_shift(x, fc, fs);
% x_filt = LP(x_shift, 1);

Xdc = mult_complexC(xdc, xc);
Xdclp = filterC(Xdc, filt_ADCc, Nx, Nfilt);

Xdclp = rescale_maxC(Xdclp, pow2(15)-1);

Xdclp.re = filt_derot(Xdclp.re, Ntaps);
Xdclp.im = filt_derot(Xdclp.im, Ntaps);

p=1; q=floor(Fs/B); % Downconverted signal sampled at B Hz
Fslr=Fs/q; dtlr=1/Fslr;

Xbase.re = resample(Xdclp.re, p, q);
Xbase.im = resample(Xdclp.im, p, q);

end