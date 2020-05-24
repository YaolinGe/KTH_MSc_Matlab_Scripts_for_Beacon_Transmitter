close all;  clear all; clc;
addpath(genpath('.')); % Add functions
vsound=1460; % Approximate speed of sound in water

%% Note ----
% This script requires Matlab 2019.  If older, just remove the use of
% sgtitle();
%%

% This script contains some code that calculates the correlation part of a
% detector, on real recorded data from the sonar. The other components of a
% detector is to define a threshold, and when the correlation signal
% exceeds the threshold some decision must be made of at what index the
% signal is located (e.g. with some function that finds a local maxima). 
% Even though this is sonar data, the fundamental elements are the similar 
% for a beacon, for both transmission and detection.

% Import sample file
recorded_echo_pool4m='square_tank_Fs160kHz.txt';
% recorded_echo_pool4m='ceilig_echo.txt';
% recorded_echo_pool4m='pwmsig.txt';
Fs=160e3;
dt=1/Fs;
y=get_data_sonarfile(recorded_echo_pool4m,1);

%% Plot sample data ------
% The transducer is both used as output (with high voltage AC) and input
% (weak acoustic signal), so the transducer is still ringing after having
% been switched from output to input. Right after the pulse has been
% transmitted, the transducer is grounded to bleed of the energy in the
% ringing. For this reason, the data doesn't start from right after the 
% pulsing has finished, and the sound at ~3m is the direct path echo from
% the bottom at 4m. The signal that can be seen at the beginning is the 
% ringing. There are a couple of artifacts at the end that you can ignore.
t=(0:length(y)-1)/Fs;
range=t*vsound/2;
figure(1)
plot(range,y,'DisplayName','ADC values'); title('Sample data from pool at ca 4 m');
ylabel('12 bit resolution'); xlabel('[m]')
% Some identifiers
hold on; 
[~,Iring]=min( abs( range-1.2 ) );
[~,Idirect]=min( abs( range-3.07 ) );
xline(range(Iring),'k--','DisplayName','End of ringing');
xline(range(Idirect),'k-.','DisplayName','Direct path');
hold off;
legend();

%% Autocorrelation
% Define FFT frame length 
NFFT=1024; % This is 4096 in the sonar (must be power of 2)
f=Fs*(0:NFFT-1)/NFFT; % Frequency vector for plots

% Create a reference signal to look for
F=47e3; 
Nperiods=25;
Ts=Nperiods/F;
Ns=round(Ts*Fs);
yref=sin((0:Ns-1)*dt*F*2*pi)'; % Time response 
Yref=fft(yref,NFFT); % Frequency response

% Plot reference signal
figure(2)
sgtitle('Reference signal')
subplot(1,2,1);
plot(yref);
title('Time response')
xlabel('Samples')
subplot(1,2,2);
plot(f,abs(Yref));
title('Frequency response')
xlabel('Frequency [Hz]')

% The function that we want to calculate: -----------------------
c=conv(y,flipud(yref)); % Convolution with flipped order is correlation
c=c-mean(c); % Center around 0 (for the plot)

figure()
plot(c);

% Typically a threshold would be set with some integer times the background
% noise standard deviation, like: 
scale=4;
% Detector is running on the correlation vector, so threshold needs to be
% based on it:
noise_std=sqrt(var(c)); % Standard deviation (std)
threshold=scale*noise_std; % Threshold value
% However the average needs be be over a very long time, in order for the
% threshold not to "jump" so much with the energy in the signal (i.e. so
% that it represents the "true" background noise). This can be a bit tricky
% to implement in a real systems, since you need to think about memory, and
% some variable types can overflow easily when adding too many large 
% numbers.

% Plot of the autocorrelation function (correlation of a signal with itself)
figure(3); 
subplot(2,1,1); 
plot(range,y);
title('Time response');
subplot(2,1,2); 
plot(range,abs(c(1:length(y))),'DisplayName','c'); xlabel('Range [m]')
hold on;
plot(range,ones(length(y),1)*threshold,'--','DisplayName',...
    ['threshold=',num2str(scale),'*std']); 
plot(range,ones(length(y),1)*noise_std,'k-.','DisplayName',...
    ['noise std']);
hold off;
legend();
title('Correlation');
% Correlating with the reference signal is basically a bandpass filter. In
% this data there are no noise sources other than echos, so all the sound
% is correlated with the reference signal. In the ocean however, there are
% a lot of different noise sources that get suppressed by this filter.
% However, as you can see, doing both input and output on the same
% transducer can be problematic, since the ringing gives a correlation peak 
% of similar magnitude as the echo. Note that this operation removes the  
% bias in the signal (since it's like a bandpass filter, the DC component 
% gets removed).

% Same operation with FFT ------------------
% In the sonar, this operation is done with FFT, since it is quicker. The
% input signal needs to be sliced up into NFFT sizes, and processed with
% some overlap, since the correlation is not valid at the edges of the
% output. It's a little bit more complicated to implement, but the 
% microprocessor has some hardware specifically to do the FFT quickly, so
% it saves a lot of computational time and is absolutely necessary in order
% to do these calculations in real-time. This function is already 
% implemented in the hardware :)  
Nframe=NFFT-2*Ns;   % Number of valid correlation samples
framestart=Ns+1;    % First index of valid samples 
frameend=Ns+Nframe; % Last index of valid samples
buffer=zeros(NFFT,1); % Input buffer

% Do some padding (just for matlab, in order to align the vectors for the plot)
N=ceil(length(y)/Nframe)*Nframe;
y=[y;ones(N-length(y),1)*mean(y)];

yy=[ones(Nframe+round(1.5)*Ns,1)*mean(y);y]; 
N=ceil(length(y)/Nframe)*Nframe+Nframe+2*Ns;
yy=[yy;ones(N-length(yy),1)*mean(yy)];
t=(0:length(y)-1)/Fs;
range=t*vsound/2;

cc=zeros(length(y),1); % Correlation vector
i=1;
% This is very similar to how the matched filter detector is implemented in
% the hardware:
while(i+NFFT<=length(yy))
    yy=flipud(circshift(flipud(yy),Nframe));    % Time passes
    buffer=yy(1:NFFT);                          % Buffer input values
    buffer_freq=fft(buffer);                    % FFT of the buffer
    Cfft=buffer_freq.*conj(Yref);               % Correlation (in freq. dom.)
    cfft=ifft(Cfft);                            % Return to time domain
    cc(i:i+Nframe-1)=cfft(framestart:frameend); % Store valid values
    i=i+Nframe;                                 % Advance to the next data frame
end

% As can be seen in below figure, it is possible to calculate correlation
% in both time and frequency and to get the same output. In order to
% understand why the convolution isn't valid at the edges after doing the
% IFFT, I recommend the video on "Convolution" in this youtube playlist: 
% http://bit.ly/2p6R8uo
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

%% M-sequences
% There are signals that have better auto-correlation properties than a
% sinusoid, e.g. m-sequences. This code illustrates it:
msq=mseq(2,7,1,2);                      % M-sequence signal
wait=zeros(round(.5*length(msq)),1);    % Padding for the plot
r=[wait;msq;wait];                      % Time signal
z=conv(r+0.1*randn(length(r),1),flipud(msq)); % Autocorrelation
z(end-(length(msq)-2):end)=[];          % Remove extra values from conv.
Msq=fft(r,5000);                        % FFT of M-seq

% Plot of the M-sequence signal, its autocorrelation and frequency 
% response. The idea of the sequence is that it is "pseudo-random", and 
% has a "white" frequency response. The function that would have the best
% properties for determining when something happens is the impulse
% function. It is however infeasible to transmitt an extremely short, high
% amplitude pulse (hardware, physics etc.). The impulse function has a flat
% frequency response (FFT of the impulse function is 1), which is similar
% to what AWGN noise has ("white" refers to the noise having a flat
% frequency response, just like the impulse function). The M-sequence has a
% white freq. response, just like noise, even when it's a long time signal.
% This is good for implementation since we don't have to push out all the
% energy in the signal in a very short impulse, while still having similar
% properties as an impulse. One thing that we haven't mentioned yet is the
% effect on Doppler (relative motion between the transmitter and receiver),
% which will decorrelate the transmitted sequence with the one that you are
% looking for. The longer the signal, the more sensitive it will become to 
% this effect. So, the signal can't be too long. One last good property of
% this signal is that it is generated with square waveforms, which is how
% the hardware generates its signals (see documentation).
figure(5);
sgtitle('Autocorrelation of M-sequence')
subplot(3,1,1);
plot(r);
title('Time response')
xlim([0 length(z)])
ylabel('Amplitude')
subplot(3,1,2);
plot(abs(z));
xlim([0 length(z)])
xlabel('[n]'); ylabel('Auto-Correlation')

f=(0:length(Msq)-1)/length(Msq); % Frequency for plotting
subplot(3,1,3);
plot(f,abs(Msq)/max(abs(Msq)));
xlim([0 0.5]);
title('Normalised frequency response');
xlabel('$\nu$','Interpreter','latex')
