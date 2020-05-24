clear;close all;clc

rng default
fc = 50e3;      % centre frequency, [kHz]
B = 5e3;        % bandwidth, [kHz]
fs = 160e3;     % sampling rate
dt = 1/fs;  
NFFT = 1024;    % number in fft
noise_amp = .1; % noise amplitude
scale = 4;
% noise = 1;
signal_amp = 1;% signal amplitude
residue = 1e3;  % 
% shift =  0;
% normalised = 0;
% logornot = 0;
% half = 1;

% =========================  Ref Signal generation ========================

% ==================== PART I: 
% create sinusoidal CW
Np = 100;
Tp = 1/fc;
Ts = Np * Tp; 
Ns = Ts * fs;
t = 0:1/fs:Ts-1/fs;
s_org = signal_amp*sin(2*pi*fc*t);
% s = s_org + noise_amp*wgn(1,length(t),0);
s = s_org;

% create m-sequence CW
baseVal = 2;
powerVal = nextpow2(Ns);
shift = 0;
whichSeq = 1;
sm_org = (mseq(baseVal,powerVal,shift,whichSeq))';
if pow2(powerVal)>length(t)
    sm_org(length(t)+1:end)=[];
else
    sm_org(pow2(powerVal):length(t)) = 0;
end %if
% sm = sm_org + noise_amp*wgn(1,length(t),0);
sm = sm_org;

% create LFM chirp
f0 = fc-B/2;
f1 = fc+B/2;
% scL = chirp(t, f0, t(end), f1) + noise_amp*wgn(1,length(t),0);
scL = chirp(t, f0, t(end), f1);

% create HFM chirp
f0 = fc-B/2;
f1 = fc+B/2;
% scH = chirp(t, f0, t(end), f1,'quadratic') + noise_amp*wgn(1,length(t),0);
scH = chirp(t, f0, t(end), f1,'quadratic');
% scH = chirp(t, f0, t(end), f1,'exponential');

% create human voice
% [s_yl, Fs] = audioread('Hello.m4a');
% s_yl = s_yl' + noise_amp*wgn(1,length(s_yl),0);

% Adele hello
% [s_ad, Fs] = audioread('Adele_Hello.wav');
% s_ad = s_ad' + noise_amp*wgn(1,length(s_ad),0);


figure(1); sgtitle('Signal types')
subplot(2,2,1);plot(t, s);title('sinusoidal');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,2);plot(t, sm);title('m-sequence');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,3);plot(t, scL);title('LFM chirp');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,4);plot(t, scH);title('HFM chirp');xlabel('t [s]');grid on;box on; grid minor;
% subplot(3,2,5);plot((0:length(s_yl)-1)/Fs, s_yl);title('YL sound');xlabel('t [s]');grid on;box on; grid minor;
% subplot(3,2,6);plot((0:length(s_ad)-1)/Fs, s_ad);title('Ad sound');xlabel('t [s]');grid on;box on; grid minor;


[sdc, ts, s_shift, s_filt] = signal_dc(s, fc, fs, B);

% figure(2);
% plot(t, abs(s)); hold on; plot(ts, abs(sdc), 'r-o')


% ======================= Ref Signal downsampling =======================

[sdc, ts] = signal_dc(s, fc, fs, B);
[smdc, ts] = signal_dc(sm, fc, fs, B);
[scLdc, ts] = signal_dc(scL, fc, fs, B);
[scHdc, ts] = signal_dc(scH, fc, fs, B);

figure(2); sgtitle('Downsampled reference signal')
subplot(2,2,1);plot(t, (s)); hold on; plot(ts, abs(sdc),'r-o');title('sinusoidal');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,2);plot(t, (sm)); hold on; plot(ts, abs(smdc),'r-o');title('m-sequence');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,3);plot(t, (scL)); hold on; plot(ts, abs(scLdc),'r-o');title('LFM chirp');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,4);plot(t, (scH)); hold on; plot(ts, abs(scHdc),'r-o');title('HFM chirp');xlabel('t [s]');grid on;box on; grid minor;

% ======================= bury into time series =========================

[x,tx] = bury(s,fs);
[xm,tx] = bury(sm,fs);
[xcL,tx] = bury(scL,fs);
[xcH,tx] = bury(scH,fs);

figure(3); sgtitle('Buried received signal')
subplot(2,2,1);plot(tx, x);title('sinusoidal');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,2);plot(tx, xm);title('m-sequence');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,3);plot(tx, xcL);title('LFM chirp');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,4);plot(tx, xcH);title('HFM chirp');xlabel('t [s]');grid on;box on; grid minor;


% ======================= Received Signal downsampling ====================

[xdc, ts] = signal_dc(x, fc, fs, B);
[xmdc, ts] = signal_dc(xm, fc, fs, B);
[xcLdc, ts] = signal_dc(xcL, fc, fs, B);
[xcHdc, ts] = signal_dc(xcH, fc, fs, B);

figure(4); sgtitle('Downsampled received signal')
subplot(2,2,1);plot(tx, (x)); hold on; plot(ts, abs(xdc),'r-o');title('sinusoidal');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,2);plot(tx, (xm)); hold on; plot(ts, abs(xmdc),'r-o');title('m-sequence');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,3);plot(tx, (xcL)); hold on; plot(ts, abs(xcLdc),'r-o');title('LFM chirp');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,4);plot(tx, (xcH)); hold on; plot(ts, abs(xcHdc),'r-o');title('HFM chirp');xlabel('t [s]');grid on;box on; grid minor;


% ============================ Matched filter =============================

dt = 1/B;
[scorr, tc] = MF_corr(sdc, xdc, B);
[smcorr, tc] = MF_corr(smdc, xmdc, B);
[scLcorr, tc] = MF_corr(scLdc, xcLdc, B);
[scHcorr, tc] = MF_corr(scHdc, xcHdc, B);

figure(5); sgtitle('Correlation')
subplot(2,2,1);plot(tx, abs(x)); hold on; plot(ts, abs(xdc),'r-o'); plot(tc, abs(scorr)*max(abs(sdc))/max(abs(scorr)),'k-*');title('sinusoidal');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,2);plot(tx, abs(xm)); hold on; plot(ts, abs(xmdc),'r-o');plot(tc, abs(smcorr)*max(abs(smdc))/max(abs(smcorr)),'k-*');title('m-sequence');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,3);plot(tx, abs(xcL)); hold on; plot(ts, abs(xcLdc),'r-o');plot(tc, abs(scLcorr)*max(abs(scLdc))/max(abs(scLcorr)),'k-*');title('LFM chirp');xlabel('t [s]');grid on;box on; grid minor;
subplot(2,2,4);plot(tx, abs(xcH)); hold on; plot(ts, abs(xcHdc),'r-o');plot(tc, abs(scHcorr)*max(abs(scHdc))/max(abs(scHcorr)),'k-*');title('HFM chirp');xlabel('t [s]');grid on;box on; grid minor;



% ======================== CMF & QMF detector =============================

xu = mean(x);
xmu = mean(xm);
xcLmu = mean(xcL);
xcHmu = mean(xcH);

xlambda = var(x);
xmlambda = var(xm);
xcLlambda = var(xcL);
xcHlambda = var(xcH);

xsigma = sqrt(xlambda);
xmsigma = sqrt(xmlambda);
xcLsigma = sqrt(xcLlambda);
xcHsigma = sqrt(xcHlambda);

% detection threshold based on normal distribution
Pf = .3;
xh = norminv(1-Pf,xmu, xsigma);
xmh = norminv(1-Pf,xmu, xmsigma);
xcLh = norminv(1-Pf,xcLmu, xcLsigma);
xcHh = norminv(1-Pf,xcHmu, xcHsigma);


% ========================== Decision making ==============================

xT = abs(scorr).^2/xlambda;
xmT = abs(smcorr).^2/xmlambda;
xcLT = abs(scLcorr).^2/xcLlambda;
xcHT = abs(scHcorr).^2/xcHlambda;

xT = xT/max(xT);
xmT = xmT/max(xmT);
xcLT = xcLT/max(xcLT);
xcHT = xcHT/max(xcHT);

figure(6); sgtitle('Decision making detection')
subplot(2,2,1); plot(tc, xT, 'k-*'); hold on; plot([tc(1) tc(end)], [xh xh], 'r--'); plot(tc(xT>xh), xT(xT>xh), 'go', 'markersize', 10); xlabel('time [s]'); title('sinusoidal')
subplot(2,2,2); plot(tc, xmT, 'k-*'); hold on; plot([tc(1) tc(end)], [xmh xmh], 'r--'); plot(tc(xmT>xmh), xT(xmT>xmh), 'go', 'markersize', 10); xlabel('time [s]'); title('M-sequence')
subplot(2,2,3); plot(tc, xcLT, 'k-*'); hold on; plot([tc(1) tc(end)], [xcLh xcLh], 'r--'); plot(tc(xcLT>xcLh), xcLT(xcLT>xcLh), 'go', 'markersize', 10); xlabel('time [s]'); title('LFM')
subplot(2,2,4); plot(tc, xcHT, 'k-*'); hold on; plot([tc(1) tc(end)], [xcHh xcHh], 'r--'); plot(tc(xcHT>xcHh), xcHT(xcHT>xcHh), 'go', 'markersize', 10); xlabel('time [s]'); title('HFM')

xPf = length(xT(xT>xh))/length(xT)
xmPf = length(xmT(xmT>xmh))/length(xmT)
xcLPf = length(xcLT(xcLT>xcLh))/length(xcLT)
xcHPf = length(xcHT(xcHT>xcHh))/length(xcHT)



% power spectrum
figure(7); sgtitle('PSD comparison')
subplot(2,2,1);pspectrum(s, fs);title('sinusoidal');xlabel('frequency');grid on;box on; grid minor;
subplot(2,2,2);pspectrum(sm, fs);title('m-sequence');xlabel('frequency');grid on;box on; grid minor;
subplot(2,2,3);pspectrum(scL, fs, 'spectrogram');title('LFM chirp');
subplot(2,2,4);pspectrum(scH, fs, 'spectrogram');title('HFM chirp');
%%

% bandpass the transmitted signal
% win = @hamming;
% fL = (f0-B/2-residue)/Fs;
% fH = (f0+B/2+residue)/Fs;
% N = 40;
% hw = BandPassFIRFilter(win, fL, fH, N);

% bandpass filter the input signal
tic;
nhw = 0:length(hw);
ns = 0:length(s);
[y, ny] = conv_m(hw,nhw, s, ns);
ty = (ny/fs)';
t_TD = toc;

%bandpass the signal in frequency domain
tic;
HW = fft(hw, NFFT);
S = fft(s, NFFT);
y_f = real(fftshift(ifft(HW.*S)));
y_f(abs(y_f-0)<(1e-6)) = [];
% y_f = [0; y_f];
ty_f = 0:1/fs:(length(y_f)-1)/fs;
t_FD = toc;


% compare calculation in FD and TD
figure(567);
stem([1, 2], [t_TD t_FD], 'filled'); grid on; box on; grid minor;
xlim([0 3])
text(.9, t_TD+.05*t_TD, 'Time domain')
text(1.9, t_FD+.05*t_FD, 'Frequency domain')
title('Time consumption comparison between TD and FD')

%plot the pulsee
figure(1);
sgtitle('Time response of transmitted signal')
subplot(3,1,1); plot(t,s); xlabel('time [s]'); title('unfiltered signal')
subplot(3,1,2); plot(ty,y);hold on; plot(ty_f, y_f)
xlabel('time [s]'); title('bandpass filtered signal')

figure(2);
plot_freq_spectrum(y, fs, shift, normalised, logornot, half)

% downconvert the bandpassed signals

y_dc = real(y .* exp(-1i*2*pi*fc*ty));


% Lowpass filter

wind = @hamming;
fc = (B/2+residue)/fs;
N = 40;
hw = LowPassFIRFilter(wind, fc, N);

nhw = 0:length(hw);
ny_dc = 0:length(y_dc);
[y_dc_lpf, ny] = conv_m(hw, nhw, y_dc, ny_dc);
y_dc_lpf(abs(y_dc_lpf-0)<1e-3) = [];
ty = 0:1/fs:(length(y_dc_lpf)-1)/fs;
figure(1); subplot(3,1,3); plot(ty, y_dc_lpf); hold on; 
% hold on; plot(t, s_org); 
title('downconverted + LP signal')

figure(2); hold on;plot_freq_spectrum(y_dc_lpf, fs, shift, normalised, logornot, half)
legend('original frequency', 'low passed frequency');


 % Resample the signal using lower frequency
 Fs_new = B;
 p = 1; q = fs/Fs_new;
 s_lr = resample(y_dc_lpf, p, q);
 t_lr = (0:length(s_lr)-1)/Fs_new;
 figure(1); subplot(3,1,3);plot(t_lr, s_lr, 'o')
 legend('Fs', 'Fs_{new}')
 



 




















