%% TEST CORRELATION
clear;close all;clc;

Np = 10;

Fs = 160e3;
fc = 47e3;
T = 1/fc;
Tpulse = T * Np;
Npulse = Tpulse * Fs;

t = (0:Npulse -1)/Fs;
y_ref = sin(2*pi*fc*t);
RES = pow2(11);
figure(1)
plot(y_ref)
% y = sig2ADC(y, RES, 1) + 2500;
% plot(y)
%                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
amp = 0.1;

y = [zeros(1024,1);y_ref';zeros(1024,1)];
y = y + amp * wgn(length(y), 1, 0);

y_ref = sig2ADC(y_ref, RES, 1) + 2500;
y_ref = y_ref';

y = sig2ADC(y, RES, 1) + 2500;
figure(2)
plot(y)

B = 5e3;
ydc = signal_dc_block(y, fc, Fs, B);
figure(3)
plot(ydc)

NFFT = 2048;
Y = fft(y, NFFT);
Yref = fft(y_ref, NFFT);
YC = Y .* Yref;
yc = ifft(YC);

figure(4)
% [yc, lags] = xcorr(y, y_ref);
subplot(2,1,1)
plot(yc)

% out_put_data(1, 'data_sine_np', y);

ycc = data_acquisition('DB_test', 'CORR_FREQ');
ycr.re = ycc(1:2:end);
ycr.im = ycc(2:2:end);
subplot(2,1,2)
plot(absC(ycr))

%%
clear;close all;clc;

Np = 10;

Fs = 160e3;
fc = 47e3;
T = 1/fc;
Tpulse = T * Np;
Npulse = Tpulse * Fs;

t = (0:Npulse -1)/Fs;
y_ref = sin(2*pi*fc*t);
RES = pow2(11);
figure(1)
plot(y_ref)

% plot(y)
amp = 0.1;

y = [zeros(1024,1);y_ref';zeros(1024,1)];
y = y + amp * wgn(length(y), 1, 0);
y = sig2ADC(y, RES, 1) + 2500;

y_ref = sig2ADC(y_ref, RES, 1) + 2500;
y_ref = y_ref';
plot(y_ref)
plot(y)

figure
[ycc, lags] = xcorr(y, y_ref);
plot(lags,ycc)


RES = pow2(11);
y_ref = sig2ADC(y_ref, RES, 1) + 2500 ;

NFFT = 2048;
y_ref = [y_ref;zeros(NFFT,1)];


Y_ref = fft(flipud(y_ref));
figure
plot(abs(Y_ref))
figure
subplot(2,1,1)
plot(y_ref)
subplot(2,1,2)
plot_freq_spectrum(y_ref, Fs, 0, 0, 0, 1, 0)
% pspectrum(y_ref, Fs)

subplot(2,1,1)
hold on;
plot(flipud(y_ref));
subplot(2,1,2)
hold on;
plot_freq_spectrum(flipud(y_ref), Fs, 0, 0, 0, 1, 0)

% y = sig2ADC(y, RES, 1) + 2500;
% plot(y)
% amp = 0.1;
% 
% y = [zeros(1024,1);y_ref';zeros(1024,1)];
% y = y + amp * wgn(length(y), 1, 0);


%% test of downconversion
clear; close all;clc;

Fs = 160e3;
fc = 47e3;
B = 5e3;
dt = 1/Fs;
t = 0:dt:0.001;

x = sin(2*pi*fc * t);
subplot(2,2,1)
plot(t,x)
title('original time series')
subplot(2,2,2)
plot_freq_spectrum(x, Fs, 0, 0, 0, 0, 0)
title('original frequency spectrum')

y = x .* exp(-1i*2*pi*fc*t);
subplot(2,2,3)
plot(t,y)
title('baseband shifted time series')

subplot(2,2,4)
plot_freq_spectrum(y, Fs, 0, 0, 0, 0, 0)
title('baseband shifted frequency spectrum')

%% GENERATE REFSIG TIME
ini();
% y = data_acquisition('DB_test', 'DC_BUFFER');
% y = y(:);
% plot(y)

Fs = 160e3;
% fc = 47e3;
fc = 70e3;
B = 5e3;
dt = 1/Fs;
np  = 10;
Tp = 1/fc;
Tpulse = Tp * np;
Npulse = floor(Tpulse * Fs);

t = (0:Npulse-1)*dt;
x = sin(2*pi*fc * t);
% NFFT = 2048;
% x = [zeros(1, 3), x, zeros(1, NFFT-length(x))];
plot(t, abs(x)); hold on;
xdc = signal_dc(x, fc, Fs, B);

% xdc = signal_dc_block(x, fc, Fs, B);
tdc = (0:length(xdc.re)-1)/B;
plot(tdc, absC(xdc)*max(abs(x))/max(absC(xdc)), 'ko')

%% TEST DOWNCONVERTED REFSIG TIME

clear;close all;clc;
y = data_acquisition('result_refsig_dc', 'REFSIG_TIME_16C');
ydc = data_acquisition('result_refsig_dc', 'REFSIG_DC_TIME_RE');

yc.re = ydc(1:2:end);
yc.im = ydc(2:2:end);

y = y(1:2:end);
Fs = 160e3;
t = (0:length(y)-1)/Fs;
plot(t, abs(y)); hold on;


B = 5e3;
tdc = (0:length(yc.re)-1)/B;
plot(tdc,absC(yc) * max(abs(y))/max(absC(yc)), 'ro-')
xlim([0, 0.002])
title('downconverted ref signal from the hardware');
grid on; grid minor; box on;
xlabel('time [s]')


%%
clear;close all;clc;
% yt = data_acquisition('DB_test', 'REFSIG_TIME_16C');
yf = data_acquisition('DB_test', 'REFSIG_DC_FREQ');
ydc = data_acquisition('DB_test', 'REFSIG_DC_TIME');

% y.re = yt(1:2:end);
% y.im = yt(2:2:end);

yc.re = yf(1:2:end);
yc.im = yf(2:2:end);

ycc.re = ydc(1:2:end);
ycc.im = ydc(2:2:end);

plot(absC(yc))
hold on;
yccc = zeros(length(ycc.re), 1);

for i = 1:length(yc.re)
    yccc(i) = ycc.re(i) + 1i * ycc.im(i);
end

Yc = fft(yccc);
plot(abs(Yc)*max(absC(yc))/max(abs(Yc)))
grid on; grid minor; box on;
title('fft of refsig time');
legend('Hardware', 'Matlab')

figure
plot(absC(ycc))

%% TEST OF DOWNCONVERSION FOR ALL COMPONENTS

clear; close all; clc;
yreff = data_acquisition('data_dc_all', 'REFSIG_DC_FREQ');
yreft = data_acquisition('data_dc_all', 'REFSIG_DC_TIME');
ydc = data_acquisition('data_dc_all', 'DC_TIME');
yfdc = data_acquisition('data_dc_all', 'DC_FREQ');

ct = data_acquisition('data_dc_all', 'CORR_TIME');
cf = data_acquisition('data_dc_all', 'CORR_FREQ');

yt.re = ydc([1:2:end], 1);
yt.im = ydc([2:2:end], 1);
figure(1);
subplot(3,1,1);
plot(yt.re);
title('real part of the downconverted signal')
subplot(3,1,2);
plot(yt.im);
title('imag part of the downconverted signal')
subplot(3,1,3);
plot(absC(yt))
title('magnitude of the downconverted signal')

yf.re = yfdc([1:2:end], 1);
yf.im = yfdc([2:2:end], 1);

figure(2);
subplot(3,1,1);
plot(yf.re);
title('real part of the frequency spectrum of the downconverted signal')
subplot(3,1,2);
plot(yf.im);
title('imag part of the frequency spectrum of the downconverted signal')
subplot(3,1,3);
plot(absC(yf))
title('magnitude of the frequency spectrum')

y_ref.re = yreft([1:2:end], 1);
y_ref.im = yreft([2:2:end], 1);

figure(3);
subplot(3,1,1);
plot(y_ref.re);
title('real part of the time reversed downconverted reference signal')
subplot(3,1,2);
plot(y_ref.im);
title('imag part of the time reversed downconverted reference signal')
subplot(3,1,3);
plot(absC(y_ref))
title('magnitude of the time reversed downconverted reference signal')

yf_ref.re = yreff([1:2:end], 1);
yf_ref.im = yreff([2:2:end], 1);

figure(4);
subplot(3,1,1);
plot(yf_ref.re);
title('real part of the frequency spectrum of the downconverted signal')
subplot(3,1,2);
plot(yf_ref.im);
title('imag part of the frequency spectrum of the downconverted signal')
subplot(3,1,3);
plot(absC(yf_ref))
title('magnitude of the frequency spectrum')

corrt.re = ct([1:2:end], 1);
corrt.im = ct([2:2:end], 1);

figure(5);
subplot(3,1,1);
plot(corrt.re);
title('real part of the correlation between downconverted signals')
subplot(3,1,2);
plot(corrt.im);
title('imag part of the correlation between downconverted signals')
subplot(3,1,3);
plot(absC(corrt))
title('magnitude of the correlation between downconverted signals')

corrf.re = cf([1:2:end], 1);
corrf.im = cf([2:2:end], 1);
figure(6);
subplot(3,1,1);
plot(corrf.re);
title('real part of the frequency spectrum of the correlation between downconverted signals')
subplot(3,1,2);
plot(corrf.im);
title('imag part of the frequency spectrum of the correlation between downconverted signals')
subplot(3,1,3);
plot(absC(corrf))
title('magnitude of the frequency spectrum of the correlation between downconverted signals')

figure(7)
sgtitle('downconverted signal comparison')
subplot(3,1,1); 
plot(absC(yt)); plot_grid();
title('magnitude of downconverted received singal')
subplot(3,1,2); 
plot(absC(y_ref)); plot_grid();
title('magnitude of time reversed downconverted reference signal (MF gain)')
subplot(3,1,3); 
plot(absC(corrt)); plot_grid();
title('magnitude of correlated signal')

%% TEST OF Matched filtering dc fixed threshold
ini();

y = input_data('data_air_test');
yref = input_data('data_refsig_dc_time');
vref = return_complex(yref);
plot(absC(vref))

c = matched_filter_dc(y);
storage_vector = zeros(2048*4, 1);
storage_vector(1:length(y)) = y;
k = reshape(storage_vector, 4, 2048);

%% CORRELATION OKAY
clear;close all;clc;
y = input_data('data_air_test_long');
% y = input_data('data_noise_pulse_train');
% y = input_data('data_noise');

fc = 47e3; Fs = 160e3; B = 5e3;
ydc = matched_filter_dc(y, fc, Fs, B);
for i = 1:length(ydc)
    ym(:, i) = absC(ydc(i));
end
ym = ym(:);

scale = 1;
threshold = sqrt(var(ym)) * scale;
subplot(3,1,1)
plot(ym)
title('correlation in time (Matlab)')
yline(threshold);
grid on; grid minor; box on;
yc = signal_dc(y, fc, Fs, B);
subplot(3,1,2)
plot(absC(yc))
title('dc signal blocks in time (Matlab)')
grid on; grid minor; box on;
subplot(3,1,3);
plot_data('data_air_test_long')

%% TEST OF CORRELATION FROM THE HARDWARE
clear;close all;clc;
y = data_acquisition('DB_test', 'DC_TIME');
yc = data_acquisition('DB_test', 'CORR_TIME');
y = y(:);
yc = yc(:);
yr.re = y(1:2:end);
yr.im = y(2:2:end);
subplot(2,1,1)
plot(absC(yr))
title('dc received signals'); grid on; grid minor; box on;
ycr.re = yc(1:2:end);
ycr.im = yc(2:2:end);
subplot(2,1,2)
plot(absC(ycr));
title('correlated signals'); grid on; grid minor; box on;
figure()

%% test dc_components 
clear;close all;clc;
Fs = 160e3;
y = data_acquisition('DB_test', 'DC_COMP');
y = y(:);
yr = convert_to_complex(y);
subplot(2,2,1)
plot(yr.re)
title('real')
subplot(2,2,2)
plot(yr.im)
title('imag')

subplot(2,2,3)
yc = to_complex(yr);
t = (0:length(yc)-1)/Fs;
plot(t, yc)
title('abs')

subplot(2,2,4)
pspectrum(yc, Fs)

%% test of correlation with one complex value
clear;close all;clc;
x = 2500;
y = input_data('data_air_test');
subplot(2,1,1)
plot(y)
[c, lags] = xcorr(x, y);
c = flipud(c);
subplot(2,1,2)
plot(lags, c)

%% test of beacon
clear;close all;clc;
% y = data_acquisition('DB_test', 'STORAGE_VECT');
Fs = 160e3; fc = 70e3; B=5e3;
y = input_data('data_beacon');
N = 6;
Nframe = 2048;
y = y(1:Nframe*N);
y = y - mean(y);
subplot(2,1,1)
plot(y)
plot_grid();
hold on;
for i = 1:N
%     xline((i-1)*Nframe);
    v = [(i-1)*Nframe min(y); i*Nframe min(y); i*Nframe max(y); (i-1)*Nframe max(y)];
    f = [1 2 3 4];
    patch('Faces', f, 'Vertices', v, 'FaceColor', 'black', 'FaceAlpha', .3);
end
axis([0 i*Nframe min(y) max(y)]);
xlabel('samples');
ylabel('ADC level')
title('prefiltered received echo analysis')
legend('Probability of cut off is ~17%')
subplot(2,1,2)
pspectrum(y, Fs)


%% test valcnt in the downconversion
clear;close all;clc;
valcnt = data_acquisition('DB_test', 'VALCNT');
valcnt = valcnt(:);
y1 = valcnt(1:2:end);
y2 = valcnt(2:2:end);
avg = mean(-y1+y2)
plot(y1, 'k-.', 'linewidth', 2); 
hold on; 
plot(y2, 'r-')
plot_grid();
legend('pre op', 'aft op');
title('speed analysis (valcnt)')

% yline(-avg);

%% Test out the frequency spectrum of signals
clear; close all; clc; Fs = 160e3; B = 5e3;
y = data_acquisition('DB_test', 'STORAGE_VECT');
y = y(:);
y = to_complex(convert_to_complex(y));
t = (0:length(y)-1)/Fs;

yc = data_acquisition('DB_test', 'STORAGE_VECT_TEST');

subplot(2,2,1)
plot(yc)
plot_grid();
title('received echos')
subplot(2,2,2)
pspectrum(yc, Fs)
subplot(2,2,3)
plot(t, abs(y))
title('downconverted correlated echos');
plot_grid();
subplot(2,2,4)
pspectrum(y, B);


%% threshold
clear;close all;clc;
y = data_acquisition('DB_test', 'THRESHOLD');
y = y(:);
plot(y)
plot_grid();
yline(mean(y(1:690)))
title("threshold buffer")


%% THRESHOLD BUFFER EVALUATION
clear;close all;clc;
y = data_acquisition('DB_test', 'STORAGE_VECT_TEST');
plot(y(1:5000))
plot_grid();
title('threshold variation')

%% TEST THE EXCEEDANCE IN THE ADC BUFFER
clear;close all;clc;
y = data_acquisition('DB_test', 'STORAGE_VECT');
y = y(:);

threshold = data_acquisition('DB_test', 'STORAGE_VECT_TEST');
for i = 1:300
    thres(:, i) = threshold(i) * ones(64,1);
end

thres = thres(:);
Fs = 160e3;
t = (0:300*64-1)/Fs;
f1 = figure
% subplot(2,1,1)
plot(y(1:300*64))
hold on;
plot(thres, 'r-.', 'linewidth', 2)
title('signal exceedance analysis')

figure
thres = data_acquisition('DB_test', 'THRESHOLD');
plot(thres)
% subplot(2,1,2)
% for i = 1:300
%     xline((i-1)*64);
% end
% title('frames slices')
% print(f1, 'exceedance_frame_analysis', '-dpdf')


%% storage_vector computation
clear;close all;clc;
y = data_acquisition('DB_test', 'STORAGE_VECT');
y = y(:);

subplot(2,2,1)
plot(y)
title('mf filtered output');
plot_grid();
fc = 70e3; Fs = 160e3; B = 5e3;
Nlen = 300;

subplot(2,2,2)
z = y;
[val, ind] = max(z);

ids = sort(unique(abs(ind-100:ind+100)+1));

plot(z(ids));%%

plot_grid();
title('close up of peak signals')
sgtitle('signal detection analysis');

threshold = data_acquisition('DB_test', 'STORAGE_VECT_TEST');
hold on;

ids = round(Nlen - 20000/64) + round(ids/64);
plot(threshold(ids), 'k-.', 'linewidth', 1.5);
legend('dc correlated signals', 'adapted threshold')

subplot(2,2,3);
threshold_buffer = data_acquisition('DB_test', 'THRESHOLD');
plot(threshold_buffer, 'k', 'linewidth', 1.2);
hold on
% plot([1:length(threshold_buffer)], mean(threshold_buffer) * ones(1TimTime , length(threshold_buffer)), 'k:', 'linewidth', 4)
plot_grid();
title('threshold buffer');
Nbuffer = round(ind/64);
Nlen = length(threshold_buffer);


v1 = [0 0; Nlen-Nbuffer 0; Nlen-Nbuffer max(threshold_buffer); 0 max(threshold_buffer)];
f1 = [1 2 3 4];
patch('Faces', f1, 'Vertices', v1, 'FaceColor', 'yellow', 'FaceAlpha', .3);
v2 = [Nlen-Nbuffer 0; Nlen 0; Nlen max(threshold_buffer); Nlen-Nbuffer max(threshold_buffer)];
f2 = [1 2 3 4];
patch('Faces', f2, 'Vertices', v2, 'FaceColor', 'green', 'FaceAlpha', .3);
axis([0 Nlen 0 max(threshold_buffer)])

subplot(2,2,4)
y = data_acquisition('DB_test', 'STORAGE_VECT_TEST');
plot_grid();
plot(y(1:3000))



%% TEST THE RINGING EFFECT BLEEDING
clear;close all;clc;

f1 = figure;
sgtitle('delay comparison')
for i = 1:6
    str = ['data_delay_',num2str(i*1000)]
    temp = data_acquisition(str, 'STORAGE_VECT');
    temp = temp(1:1000);
    subplot(6,1,i);
    plot(temp); plot_grid();
    axis([-10 1000 0 4500])
    ylabel(num2str(i*1000))
end %for
% y = data_acquisition('DB_test', 'STORAGE_VECT');
% plot(y)
% plot_grid();
% print(f1, 'delay_comp_final', '-dpdf');

%% frequency spectrum analysis

clear;close all;clc;
Fs = 160e3;
% y = input_data('DB_test');
y = data_acquisition('DB_test', 'STORAGE_VECT_TEST');
subplot(2,2,1)
t = (0:length(y)-1)/Fs;
plot(t, y)
plot_grid();
subplot(2,2,2)
pspectrum(y, Fs, 'spectrogram')
subplot(2,2,[3 4])
pspectrum(y, Fs)

%% REFSIG GENERATION
clear;close all;clc;
fc = 47e3;
Fs = 160e3;
np = 10;
B = 5e3;
yref = generate_refsig_sine(np, fc);
plot(yref)
ydc = signal_dc(yref, fc, Fs, B);
hold on;
plot(absC(ydc)*max(abs(yref))/absC(ydc), 'ro')
% figure
stem(yref, 'filled')


%% DATA PL ANALYSIS
clear;close all;clc;
Fs = 160e3;
figure
sgtitle('pulse and listen signal analysis')
for i = 5:5:75
    subplot(5,3,i/5);
    y = input_data(['data_freq_', num2str(i)]);
    y = y - mean(y);
%     plot(y);
%     pspectrum(y, Fs, 'spectrogram');
    pspectrum(y, Fs);

    plot_grid();
    title([num2str(i), 'kHz']);
end

%%
clear;close all;clc;
Fs = 160e3;
y1 = input_data('data_air_test_long');
y2 = data_acquisition('DB_test', 'CORR_TIME');
y2 = y2(:);
y1 = y1 - mean(y1);
% y2 = circshift(y2, -100)

fc = 47e3;
Fs = 160e3;
Fs_new = 5e3;
B = 5e3;
yref = generate_refsig_sine(10, 47e3);
yref_dc = signal_dc(yref, fc, Fs, B);

t = (0:length(y1)-1)/Fs;
tdc = (0:length(y2)-1)/Fs_new;
plot(t, abs(y1));
hold on;
plot(tdc, y2 * max(abs(y1)) / max(abs(y2)))

%%
clear;close all;clc;
Fs = 160e3;
B = 5e3;
y = data_acquisition('DB_test', 'DC_VALS');
Y = convert_to_complex(y);
y1 = data_acquisition('DB_test', 'DC_VALS');
Y1 = convert_to_complex(y1);
y2 = data_acquisition('DB_test', 'DC_VALS_LPFILT');
Y2 = convert_to_complex(y2);
y3 = data_acquisition('DB_test', 'DC');
Y3 = convert_to_complex(y3);
y4 = data_acquisition('DB_test', 'DC_RESCALE');
Y4 = convert_to_complex(y4);

figure(1)
subplot(2,2,1)
plot(absC(Y1));
title('DC VALS')

subplot(2,2,2)
plot(absC(Y2));
title('DC VALS LPFILT')

subplot(2,2,3)
plot(absC(Y3));
title('DC')

subplot(2,2,4)
plot(absC(Y4));
title('DC RESCALE')

figure(2);
subplot(2,2,1);
pspectrum(to_complex(Y), Fs);

subplot(2,2,2);
pspectrum(to_complex(Y1), Fs);

subplot(2,2,3);
pspectrum(to_complex(Y2), B);

subplot(2,2,4);
pspectrum(to_complex(Y3), B);

%%  
clear;close all;clc;
fc = 47e3;
Fs = 160e3;
Fs_new = 5e3;
B = 5e3;
y = input_data('data_air_test');
% y = input_data('data_500');
t = (0:length(y)-1)/Fs;
% y = y - mean(y);
figure
plot(t, abs(y))

[ydc, ypad, Yadc, Yadclp, Ydc3, Ydc4 ]= signal_dc_block(y, fc, Fs, B);
% ydc = signal_dc(y, fc, Fs, B);
tdc = (0:length(ydc)-1)/B;
hold on;
plot(tdc, abs(ydc)*max(abs(y))/max(abs(ydc)), 'ko-')
% check_pad(ypad, 3, 3)

%
% y = depad(ypad, 3, 3);
% y = y';
% y = y(:);

ys = y' .* exp(-1i*2*pi*fc*(0:length(y)-1)/Fs);
figure
subplot(4,1,1)
pspectrum(y, Fs)
subplot(4,1,2)
pspectrum(absC(Yadc), Fs)
% plot_freq_spectrum(absC(Yadc), Fs, 0, 0, 1, 0, 0)
subplot(4,1,3)
% plot_freq_spectrum(absC(Yadclp), Fs, 0, 0, 1, 0, 0)
pspectrum(absC(Yadclp), Fs)
subplot(4,1,4)
pspectrum(ys, Fs)

%%
clear; close all; clc;
y = data_acquisition('DB_test', 'CORR_TIME');
y = y(:);
yc = convert_to_complex(y);
plot(absC(yc))

figure
subplot(2,1,1)
plot(yc.re)
subplot(2,1,2)
plot(yc.im)

%% DC signals analysis
clear;close all;clc;
Fs = 160e3;
y2 = data_acquisition('DB_test', 'DC_VALS_LPFILT');
Y2 = to_complex(convert_to_complex(y2));

figure
pspectrum(Y2, Fs, 'twosided', true);

Fs = 160e3;
B = 5e3;
p = 1;
q = floor(Fs/B);
Fslr = Fs/q;
dtlr = 1 / Fslr;

Xbase.re = downsample_input(real(Y2), p, q);
Xbase.im = downsample_input(imag(Y2), p, q);

xbase = to_complex(Xbase);

figure
subplot(1,2,1)
pspectrum(xbase, B)

Xbase.re = resample(real(Y2), p, q);
Xbase.im = resample(imag(Y2), p, q);
xbase = to_complex(Xbase);

subplot(1,2,2)
pspectrum(xbase, B)

y_cpy = data_acquisition('DB_test', 'STORAGE_VECT_TEST');

figure
pspectrum(y_cpy, Fs, 'twosided', true)
title('CPY')

y_dc_vals = data_acquisition('DB_test', 'DC_VALS');
y_dc_vals = y_dc_vals(:);
Ydc = convert_to_complex(y_dc_vals);
ydc = to_complex(Ydc);

figure
pspectrum(ydc, Fs, 'twosided', true)
title('DC_VALS')


%% Determination of complex signals
clear;close all;clc;
Fs = 160e3;
N = 8e2;
T = N / Fs;
t = 0:1/Fs:T;
fc = 47e3;
y = exp(1i*2*pi*fc*t);
y = round(y * 1024);

yr.re = real(y);
yr.im = imag(y);
% ydc = exp(-1i*2*pi*fc*t);
% yrc = to_complex(yr);
% figure
% subplot(2,1,1)
% plot(yr.re)
% subplot(2,1,2)
% plot(yr.im)

figure
subplot(2,1,1)
pspectrum(y, Fs)
xdc.re = sig2FXP(cos(2*pi*t*fc),511); % 16bit
xdc.im = sig2FXP(sin(-2*pi*t*fc),511); % 16bit

% xdc.re = cos(2*pi*t*fc); % 16bit
% xdc.im = sin(-2*pi*t*fc); % 16bit

% ydcr.re = real(ydc);
% ydcr.im = imag(ydc);

ydc = mult_complexC(xdc, yr);
Ydc = to_complex(ydc);
subplot(2,1,2)
pspectrum(Ydc, Fs)

figure
subplot(2,1,1)
pspectrum(y, Fs)
ydc = y .* exp(-1i*2*pi*fc*t);

subplot(2,1,2)
pspectrum(ydc, Fs)


%% FFT of abs verification, cannot just directly use the absolute
% value, it is better to use the original complex signals
clear;close all;clc;
Fs = 300;
t = 0:1/Fs:5;
fc = 10;

y = exp(1i*2*pi*fc*t);
subplot(3,1,1)
plot(t, y)
subplot(3,1,2)
plot(t, real(y))
subplot(3,1,3)
plot(t, imag(y))


figure
y1 = cos(2*pi*fc*t);
% y1 = exp(1i*2*pi*fc*t);
subplot(2,3,1)
pspectrum(y1, Fs, 'twosided', true)
title('cos')
subplot(2,3,2)
pspectrum(abs(y1), Fs, 'twosided', true)
title('abs cos')
subplot(2,3,3)
plot(y1(1:10));
title('y1')

y2 = sin(2*pi*fc*t);
% y2 = exp(-1i*2*pi*fc*t);
subplot(2,3,4)
pspectrum(y2, Fs, 'twosided', true)
title('sin')
subplot(2,3,5)
pspectrum(abs(y2), Fs, 'twosided', true)
title('abs sin')
subplot(2,3,6)
plot(y2(1:100));











