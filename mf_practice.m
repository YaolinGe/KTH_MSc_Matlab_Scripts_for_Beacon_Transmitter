clear; clc; close all;

% recorded_data = 'square_tank_Fs160kHz.txt';
recorded_data = 'ceilig_echo.txt';
Fs = 160e3;
y = get_data_sonarfile(recorded_data,1);


vsound = 343;
t = (0:length(y)-1)/Fs;
range = vsound * t/2;

figure
plot(range, y)


N = pow2(nextpow2(length(y)));
f = (-N/2:N/2-1)*(Fs/N);

Y = fft(y,N);
Y = fftshift(Y);
figure
plot(f, abs(Y).^2/N)



%%
vsound = 1460;       % speed of sound, [m/s]
dt = 1/Fs;          % time gap
t = (0:length(y)-1)/Fs;
range = t * vsound/2;

% sound(y,Fs)
% figure()
% plot(range,y)

% NFFT = pow2(nextpow2(length(y)));
NFFT = 2^10;
f = (-NFFT/2:NFFT/2-1)*(Fs/NFFT);

F = 47e3;
Nperiods = 25;
Ts = Nperiods/F;
Ns = round(Ts*Fs);
yref = sin((0:Ns-1)*dt*F*2*pi)';
Yref = fft(yref, NFFT);
Y = fftshift(Yref);
power = abs(Y).^2/NFFT;

% figure
% plot(f, power)
% figure
% plot(c)

figure
sgtitle('Reference signal');
subplot(2,1,1)
plot(yref)
subplot(2,1,2)
plot(f,power)

tic;
c = conv(y, flipud(yref));
c = c - mean(c);
t1 = toc;

figure
plot(abs(c))

scale = 8;
noise_std = sqrt(var(c));
threshold = scale * noise_std;
yline(threshold);



Nframe = NFFT - 2*Ns;
framestart = Ns + 1;
frameend = Ns + Nframe;
buffer = zeros(NFFT, 1);

N = ceil(length(y)/Nframe) * Nframe;


figure
subplot(3,1,1)
plot(y)


y = [y;ones(N-length(y),1)*mean(y)];
yy = [ones(Nframe+round(1.5)*Ns,1)*mean(y);y];

subplot(3,1,2)
plot(yy)


N = ceil(length(y)/Nframe)*Nframe+Nframe+2*Ns;
yy = [yy; ones(N-length(yy),1)*mean(yy)];
t = (0:length(y)-1)/Fs;
range = t*vsound/2;

subplot(3,1,3)
plot(yy)

cc = zeros(length(y),1);
i = 1;

tic;
while(i+NFFT<=length(yy))
    yy = flipud(circshift(flipud(yy),Nframe)); % time passes
    buffer = yy(1:NFFT);
    buffer_freq = fft(buffer);
    Cfft = buffer_freq.*conj(Yref);
    cfft = ifft(Cfft);
    cc(i:i+Nframe-1) = cfft(framestart:frameend);
    i = i + Nframe;
end
t2 = toc;

figure(4); 
subplot(3,1,1); 
plot(range,y);
title('Time response');
subplot(3,1,2); 
plot(range,abs([c;ones(length(y)-length(c),1)*mean(c)])); 
title('Correlation')
subplot(3,1,3); 
plot(range,abs(real(cc(1:length(y))))); xlabel('Range [m]')
title('FFT correlation');


fprintf('The time correlation takes %f second\n', t1);
fprintf('The freq correlation takes %f second\n', t2);



%%
clear; clc; close all;

msq = mseq(2,7,1,1);
wait = zeros(round(.5*length(msq)),1);
r = [wait; msq; wait];
noise = 0.1*wgn(length(r),1,0);
plot(noise)
r = noise + r;
figure
plot(r)

z = conv(r, flipud(msq));
z(end-(length(msq)-2):end)=[];
z = z - mean(z);
figure
plot(z)

Msq = fft(r,5000);
% figure
f=(0:length(Msq)-1)/length(Msq); % Frequency for plotting
% plot(f,abs(Msq)/max(abs(Msq)))

scale = 4;
noise_std = sqrt(var(z));
detect_thr = scale * noise_std;
yline(detect_thr);

% Fs = 160e3;
% sound(r, Fs)


%%







