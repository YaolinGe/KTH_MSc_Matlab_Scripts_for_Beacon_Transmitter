clear;close all;clc;

% fix the random number generator
rstream = RandStream.create('mt19937ar','seed',2009);

Ntrial = 1e3;             % number of Monte-Carlo trials
snrdb = 0:5:15;                % SNR in dB
snr = db2pow(snrdb);      % SNR in linear scale
spower = 1;               % signal power is 1
npower = spower./snr;           % noise power
namp = sqrt(npower/2)';    % noise amplitude in each channel
s = ones(1,Ntrial);       % signal  
n = namp.*(randn(rstream,1,Ntrial)+1i*randn(rstream,1,Ntrial));  % noise


% received signal
x = s + n;

%%
figure(1)
plot(1:Ntrial, x);title('received signal');

% mf coefficient
mf = 1;

% apply the matched filter (correlation)
y = mf'*x;

z = real(y);
figure(1); hold on; plot(z)

Pfa = 1e-3;
snrthreshold = db2pow(npwgnthresh(Pfa, 1, 'coherent'))

Pfa = .5*(1-erf(sqrt(snrthreshold)))


%

mfgain = mf'*mf % in orderr to find the true SNR, threshold

% To match the equation in the text above
% npower - N
% mfgain - M
% snrthreshold - SNR
% https://www.mathworks.com/help/phased/examples/signal-detection-in-white-gaussian-noise.html
threshold = sqrt(npower*mfgain*snrthreshold)

Pd = sum(z>threshold)/Ntrial

x = n;
y = mf'*x;
z = real(y);

Pfa = sum(z>threshold)/Ntrial
figure(2);
rocsnr(snrdb,'SignalType','NonfluctuatingCoherent','MinPfa',1e-4);



%%
% simulate the signal
x = s.*exp(1i*2*pi*rand(rstream,1,Ntrial)) + n;
y = mf'*x;

z = abs(y);
snrthreshold = db2pow(npwgnthresh(Pfa, 1,'noncoherent'));

mfgain = mf'*mf;
threshold = sqrt(npower*mfgain*snrthreshold);

Pd = sum(z>threshold)/Ntrial
x = n;
y = mf'*x;
z = abs(y);
Pfa = sum(z>threshold)/Ntrial

rocsnr(snrdb,'SignalType','NonfluctuatingNoncoherent','MinPfa',1e-4);
























