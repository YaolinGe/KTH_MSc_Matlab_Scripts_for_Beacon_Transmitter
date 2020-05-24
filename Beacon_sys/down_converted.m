clear; clc; close all;

f0 = 50e3;
Fs = 160e3;
dt = 1/Fs;
NFFT = Fs * 10;
sig = 0;

% create signal and downconvert it
Np =  10;       % number of cycles
Ts =  Np/f0;    % time duration
Ns = Ts * Fs;   % number of samples
B = 1/Ts;       % bandwidth

t = 0:1/Fs:Ts-1/Fs;
% s = sin(2*pi*(0:Ns-1)*f0/Fs);
s = sin(2*pi*f0*t);

figure(1)
plot(t,s)
title('sinusoidal signal sample')
xlabel('time');
grid on; grid minor; box on;

s_dc = exp(-1i*2*pi*f0*t).*s;
figure(2);hold on;
plot_freq_spectrum(s, Fs, 0, 0, 0, 1);
plot_freq_spectrum(s_dc, Fs, 0,0,0,1)
annotation('textarrow',[.55 .6],[.7 .7], 'string', 'Original PSD' )
annotation('textarrow',[.76 .73],[.7 .7], 'string', 'Aliased PSD' )
annotation('textarrow',[.2 .15],[.7 .7], 'string', 'DownShifted PSD' )

fwind = @hamming;
fc = B/Fs/2;
N = 7;

F=[0 .1 .2 .5];
A=[1 1 0 0];

hw=firls(N,F,A);

hw = LowPassFIRFilter(fwind, fc, N);
%hw = hw./max(hw);
s_dc_lp = FIRfiltering(s, hw, 1);

figure(3)
plot_freq_spectrum(s_dc_lp, Fs, 0,1,0,1)

N_s = length(s_dc_lp);
figure(4)
% stem(s_dc_lp)
stem(hw, 'filled')
fvtool(hw,'Fs',Fs,'color','white');

N = pow2(nextpow2(length(s)));
S = fft(s);
N = length(s);
f = (0:N-1)*Fs/N;
power = abs(S).^2/N;
figure
plot(f,power)
plot(t,s)

dc_s = exp(-1i*2*pi*(0:Ns-1)*(f0)/Fs);


N = pow2(nextpow2(length(dc_s)));
S = fft(dc_s);
N = length(dc_s);
f = (0:N-1)*Fs/N;
power = abs(S).^2/N;
figure
plot(f,power)

s_dc = dc_s .* s;
% N = pow2(nextpow2(length(s_dc)));
S = fft(s_dc,N);
N = length(s_dc);
f = (0:N-1)*Fs/N;
power = abs(S).^2/N;
figure
plot(f,power)


%%


figure
subplot(3,1,1)
plot((0:Ns-1),s)
subplot(3,1,2)
plot((0:Ns-1),dc_s)
subplot(3,1,3)
plot((0:Ns-1),s_dc)


% create lp filter

Ntaps = 6;
Fp = B/2;
Rp = 0.0057565;
Rst = 1e-3;
filt = firceqrip(Ntaps, Fp/(Fs/2),[Rp Rst], 'passedge');
% fvtool(filt, 'Fs', Fs, 'Color', 'White');
Nfilt = length(filt);



Nrot = floor(Nfilt/2);

Nrot_end = ceil(Nfilt/2)-1;

s_dc_pad = filter_prepad(s_dc, 0, Nfilt);

[s_dc_filt, ~] = filter(s_dc_pad, filt, Ns, Nfilt);

figure
stem(s_dc_filt, 'filled')

figure
plot(s);
title('signal in time');

figure
plot(abs(s_dc));
hold on; 
plot(abs(s_dc_filt), 'r--');
hold off;
title('downconverted signal (unfiltered and filtered)');
% S = fft(s_dc_filt);
% n = length(S);
% power = abs(S).^2/n;
% f = (0:n-1)*Fs/n;
% figure
% plot(f,power)

figure(9)
f=(-NFFT/2:NFFT/2-1)*Fs/NFFT;
plot(f,abs(fftshift(fft(s,NFFT))));
title('Signal spectrum')

figure(10)
plot(f,abs(fftshift(fft(s_dc,NFFT))),'b--');
hold on
plot(f,abs(fftshift(fft(s_dc_filt,NFFT))));
title('Downconverted signal spectrum (unfiltered and filtered)')


% create time signal based on the downconverted version
x = [zeros(1, round(Fs*1*Ts)), s, zeros(1, round(Fs*2*Ts))];
x = x + randn(1, length(x))*sig;
% figure
% stem(x, 'filled')

figure
stem((0:length(x)-1)*dt, abs(x), 'filled')

x_dc_filt = conv(x.*exp(-1i*2*pi*(0:length(x)-1)*f0/Fs), filt);

% figure
% stem((0:length(x_dc_filt)-1)*dt,(x_dc_filt), 'filled')

x_dc_filt = filt_derot(x_dc_filt, Ntaps);
% figure
hold on; 
plot((0:length(x_dc_filt)-1)*dt, abs(x_dc_filt), 'r--');
title('received signal + downconverted');


% downconverted signal sampled at B Hz
p = 1; q = floor(Fs/B);     % if p>q, upsampling,p<q downsampling
Fslr = Fs/q; 
dtlr = 1/Fslr;
% resample ref signal
xlr = resample(x_dc_filt, p, q);

% resample input
slr = resample(s_dc_filt, p, q);

scorr = conv(xlr, flipud(slr));

figure
plot((0:length(scorr)-1)*dtlr, abs(scorr)*max(abs(x_dc_filt))/max(abs(scorr)),'o-k');
[tmp, sigmid] = max(abs(scorr));
sigstart = sigmid - ceil(Ns*Fslr/Fs)/2;
sigend = sigmid + ceil(Ns*Fslr/Fs)/2;
xline((sigend-1)*dtlr, 'k--');
xline((sigstart-1)*dtlr, 'k--');
hold off


%%
% clear; clc; close all;
%sonar implemeentation

ADCRES = 2^12;
INGAIN = .1;
dfile = get_data_sonarfile('pwmsig.txt',1);

Npoints = 1000;
ADC = transpose(dfile(1:Npoints));

ADC = ADC - mean(ADC);
filt_ADC = sig2FXP(filt, ADCRES);





function [xpad]=filter_prepad(x,padval,Nfilt)
% IN THE SONAR THE PADDING NEEDS TO BE SAMPLED VALUES
Nrot=floor(Nfilt/2); % Number of taps rotated by filter
Nrot_end=ceil(Nfilt/2)-1;
xpad=[ones(1,Nrot)*padval,x,ones(1,Nrot_end)*padval];
end

function [res,Nvalid]=filter(data,filt,Ndata,Nfilt)

% res=zeros(1,Ndata+2-2*Nfilt);
res=zeros(1,Ndata);
intersum=zeros(1,Nfilt);

iires=1; % Index of result
for i=1:Ndata
    if(i==Ndata)
        a=1;
    end
    intersum(:)=data(i:i+Nfilt-1).*filt;
    res(iires)=sum(intersum);
    iires=iires+1;
%     i
end
Nvalid=iires-1;
end


function y=filt_derot(y_rotated,Ntaps)
Nrot=floor(Ntaps/2);
% Compensate for filter offset 
if(length(y_rotated(:,1))<length(y_rotated(1,:)))
    y=fliplr(circshift(fliplr(y_rotated),Nrot));
else
    y=flipud(circshift(flipud(y_rotated),Nrot));
end
y(end-Nrot+1:end)=0;
end































