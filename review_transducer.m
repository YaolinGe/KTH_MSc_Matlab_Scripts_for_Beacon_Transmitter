clear;close all;clc;


% =========================== Signal Import ===============================
% dpath='C:\Users\geyao\Desktop\';
% dpath='C:\Users\geyao\Desktop\';
Fs = 160e3;
dt = 1/Fs;
vsound = 343;
y_tube=get_data_sonarfile('capture_tube.txt',1);
% y=get_data_sonarfile([dpath,'capture.txt'],1);

% y=get_data_sonarfile('noise_background_old.txt',1);
y_air=get_data_sonarfile('capture_air.txt',1);

t = (0:length(y_tube)-1)/Fs;
range = vsound * t/2;
NFFT = pow2(10);
figure(1);
subplot(2,1,1);
% plot(range, y, 'DisplayName', 'ADC values');title('Sample datas from the tube');
% plot( range, y, 'DisplayName', 'ADC values');title('Sample data from the tube');
plot(range, y_tube, 'DisplayName', 'ADC values');title('Sample data from the tube');

ylabel('12 bit resolution'); xlabel('[m]');
subplot(2,1,2); 
plot(range, y_air, 'DisplayName', 'ADC values');title('Sample data from the tube');

figure(2);
plot_freq_spectrum(y_tube, Fs, 0, 0, 1, 1, 1)

figure(3); pspectrum(y_tube, Fs, 'spectrogram')
% ============================== Ref Signal ===============================

f0 = 47e3;
Nperiods = 100;
Ts = Nperiods/f0;
Ns = round(Ts*Fs);
t = (0:Ns-1)/Fs;
y_ref = sin(2*pi*f0*t)';
% Y_ref = abs(fftshift(fft(y_ref, NFFT)));
% f = (-NFFT/2:NFFT/2-1)*f0/Fs;

% figure(2);
% sgtitle('reference signal')
% subplot(1,2,1); plot(t*1e3, y_ref);title('time response');xlabel('time [ms]')
% subplot(1,2,2); plot(f, Y_ref);title('frequency response'); xlabel('frequency [Hz]')

% ============================ Correlation ================================

% autocorrelation
s = conv(y_tube, conj(flipud(y_ref)));
s = s - mean(s);

figure(4);
plot(s)

NFFT = pow2(10);
Nframe = NFFT - 2*Ns;
framestart = Ns + 1;
frameend = Ns + Nframe;
buffer = zeros(NFFT, 1);
Y_ref = fft(y_tube, NFFT);
N = ceil(length(y_tube)/Nframe)*Nframe;

y_tube = [y_tube;ones(N-length(y_tube), 1)*mean(y_tube)];
% yy = [ones(Nframe+round(1.5)*Ns, 1)*mean(y); y];
yy = [ones(NFFT, 1)*mean(y_tube); y_tube]; % fliped upside down version of original sequnece, for correlation
% N = ceil(length(y)/Nframe)*Nframe +  Nframe + 2*Ns;
N = ceil(length(y_tube)/Nframe)*Nframe + NFFT;
yy = [yy;ones(N-length(yy),1)*mean(yy)];
t = (0:length(y_tube)-1)/Fs;
range = t*vsound/2;

cc = zeros(length(y_tube),1);
i = 1;

while i+NFFT<length(yy)
    yy = flipud(circshift(flipud(yy), Nframe));
    buffer = yy(1:NFFT);
    buffer_freq  = fft(buffer);
    Cfft = buffer_freq .* conj(Y_ref);
    cfft = ifft(Cfft);
    cc(i:i+Nframe-1) = cfft(framestart:frameend);
    i = i + Nframe;
end

%% reference signal generation
clear;close all; clc
fc = 47e3;
Fs = 160e3;
B = 5e3;
Tp = 1/fc;
np = 100;
NFFT = 2048;
Tpulse = Tp * np;
Npulse = Tpulse*Fs;
f1 = fc - B/2;
f2 = fc + B/2;
chirp = generate_chirp(f1, f2, Fs, Tpulse, NFFT);

sine = generate_sine(fc, Fs, Tpulse, NFFT);
x = sine;
INPUTGAIN = 0.1;
ADCRES = pow2(12);
ADC = round((INPUTGAIN*(x/max(abs(x))/2))*ADCRES)
plot(ADC)
fid = fopen('DB_test.txt','w+');
fprintf(fid, "%d;\n",sine);
fclose(fid);
dc_simulation(0,'DB_test.txt')

% plot(chirp)

% pspectrum(chirp, Fs, 'spectrogram')
% spectrogram(chirp, Fs, [], [f1:.1:f2],Fs)
% spectrogram(chirp,50, 25, 1024, 'yaxis')

%% find the correlation

function chirp = generate_chirp(f1, f2, Fs, T, Nlen)

Np = T*Fs;
dt = 1/Fs;
w1 = f1*2*pi;
w2 = f2*2*pi;
t = 0;
i = 1;
while(1)
    t = i*dt;
    chirp(i) = cos(w1*t+(w2-w1)*t*t/2/T);
    i=i+1;
    if ~(i<=Np&&i<=Nlen)
        break;
    end %if
end %while

end %generate_chirp

function sine = generate_sine(fc, Fs, T, Nlen)
    Np = T * Fs;
    dt = 1/Fs;
    i = 1;
    while(1)
        sine(i) = sin(2*pi*fc*i*dt);
        i = i + 1;
        if ~(i<=Np && i<=Nlen)
            break;
        end %if
    end %while
    
end %sine