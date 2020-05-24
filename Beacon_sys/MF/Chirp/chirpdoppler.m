%% Parameters
Fs=200e3;
% Fs=200e3;
dt=1/Fs;
f1=70e3;
f2=80e3;
fsine=90e3;
c_water=1480; % [m/s]
dopplerbank_len=10; % Length of the bank going up, and down 

fft_len=500; % Important for accuracy of dopplerbank, higher with longer fft

fcpu=150e6;
calcs_per_sample=(1/Fs)*fcpu/6; % 16/32 bit operations take 6 cpu cycles
disp(['Calculations per sample: ' num2str(calcs_per_sample)]);

Nchirp=100;
Nsine=100;

Tchirp=Nchirp/Fs;
Tsine=Nsine/Fs;

Nsilence=round(100*Tchirp*Fs);
silence=zeros(Nsilence,1);

%% Generate signals
chirp=generate_chirp(Fs,f1,f2,Tchirp);
sine=sin(2*pi*fsine*(0:dt:Tsine-dt))';

chirpw=chirp.*hann(length(chirp));
sinew=sine.*hann(length(sine));

signal=[silence;chirpw;sinew;silence];

%% Make some doppler shifted versions
[signals_up,signals_down]=dopplerbank(signal,dopplerbank_len,0.001);

signals=[flipud(signals_up);{signal};signals_down];
dv=zeros(length(signals),1);
df=zeros(length(signals),1);
for Idoppler=1:length(signals)
s=cell2mat(signals(Idoppler));

N=length(s);

%% Generate and add noise
ampfactor=0.3;
n=randn(N,1);
noise=ampfactor*(n/max(abs(n)));

s=s+noise;
s=s/max(abs(s)); % Normalise

%% Saturation
saturation_level=0.8;
s(s>saturation_level)=saturation_level;
s(s<(-1)*saturation_level)=(-1)*saturation_level;

%% Correlate the chirp
% c=conv(signal,flipud(chirpw))/length(chirpw);

%% Detection algorithm &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

buffer1=zeros(Nchirp,1);
buffer2=zeros(2*(Nchirp+Nsine),1);

corr=zeros(length(s),1);

correlation_trigger=0.15;
for i=1:length(s)
    buffer1=circshift(buffer1,1); buffer1(1)=s(i); % Read a new value from "adc"
%     corr(i)=(sum(buffer1.*flipud(chirpw)))/length(chirpw);
    corr(i)=(sum(buffer1.*flipud(chirpw)));
    if(corr(i)>correlation_trigger*length(chirpw))
        % Read a bunch of values after the correlator has triggerd
        buffer2=[buffer1;s(i:i+length(buffer2)-length(buffer1))]; 
        break;
    end
end

% Calculate correlation
correlation=conv(buffer2,flipud(chirpw))/length(chirpw);

% Remove extra points at the end, from the convolution sum
correlation(length(buffer2)+1:end)=[];

%% Calculate envelope 
c_abs=abs(correlation);
Nsymm=10;
% Number of forward/backward averages excluding u0
Nforward=Nsymm; Nbackward=Nsymm; 
Navg=Nforward+Nbackward; % Total averages excluding u0
% Pad the sequence with the averages before and after
sequence=[zeros(Nbackward,1);c_abs;zeros(Nforward,1)];
envel=zeros(length(buffer2),1);
for i=1:length(envel)
    % Average over Nforward+u0+Nbackward points, then normalise
    envel(i)=sum(sequence(i:i+Navg))/(Navg+1); 
end

%% Calculate envelope again to make it smoother
sequence=[zeros(Nbackward,1);envel;zeros(Nforward,1)];
envel2=zeros(length(buffer2),1);
for i=1:length(envel)
    % Average over Nforward+u0+Nbackward points, then normalise
    envel2(i)=sum(sequence(i:i+Navg))/(Navg+1); 
end

[a,t0]=max(envel2); % Find t0 when the sonar stopped pulsing
sine_r=buffer2(t0:end); % Received sine
fsine_r=abs(fft(sine_r,fft_len)); % FFT of received sine
fsine_r_save(Idoppler)={fsine_r/max(fsine_r)};
f=(0:length(fsine_r)-1)*Fs/length(fsine_r); % Create corresponding freq vector
[A,Ifsine_max]=max(fsine_r);
f_doppler=f(Ifsine_max);
% disp(['Original frequency of harmonic: ' num2str(fsine*10^-3) 'kHz']);
% disp(['Doppler shifted harmonic: ' num2str(f_doppler*10^-3) 'kHz']);
df(Idoppler)=fsine-f_doppler;
dv(Idoppler)=(fsine-f_doppler)*c_water/fsine;
% disp(['Relative velocity: ' num2str(dv) 'm/s']);

end

figure(11)
yyaxis left
plot(dv)
ylabel('dv [m/s]')
yyaxis right
plot(df/(10^3))
ylabel('df [kHz]')

% Doppler shifted detected harmonic signals
figure(13);
for j=1:length(fsine_r_save);hold on;plot(f,cell2mat(fsine_r_save(j)));hold off;
end

%% Plots
figure(1)
yyaxis left
plot(s)
ylabel('Received signal')

yyaxis right
plot(corr/length(chirpw))
ylabel('Chirp correlation')

% figure(1);
% plot(signal);
% title('Signal');
% 
% figure(2)
% yyaxis left
% plot(c);
% ylim([-0.2 0.2]);
% ylabel('Correlation');
% hold on;
% plot(envelope(c),'r');
% hold off;
% yyaxis right
% dc=diff(envelope(c));
% plot(max(c)*dc/max(dc));
% ylabel('(d/dt) * dt');
% title('Chirp correlation');
% 
% figure(3);
% f=Fs*(0:(length(signal)-1))/length(signal);
% S=abs(fft(signal));
% plot(f,S/max(S));
% title('FFT');

% Detection
figure(4)
yyaxis left
plot(buffer2);
yyaxis right
plot(correlation)
hold on
plot(envelope(correlation))
hold off
title('Detector');

figure(5)
yyaxis left
plot(c_abs)
ylabel('Correlation')
yyaxis right 
plot(envel2)
ylabel('Custom envelope')
% hold on
% plot(envel2);
% hold off
