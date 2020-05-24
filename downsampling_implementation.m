clear; close all;
%% Naive implementation

clear; clc; close all;
f0=50e3;
Fs=160e3; dt=1/Fs;
NFFT=Fs*10;
sig=0.1;
scale = 4;

% Create signal and downconvert
Np=10; % Number of periods
Ts=(Np/f0); % Signal time length
Ns=Ts*Fs; % Number of signal samples
B=1/Ts; % Bandwidth
s=sin(2*pi*(0:Ns-1)*f0/Fs); % Create the transmit signal
Ns=length(s);

dc=exp(-1i*2*pi*(0:Ns-1)*f0/Fs); % Create downconversion signal
figure(1); subplot(3,1,1);
stem(s,'filled')
subplot(3,1,2);
stem(dc,'filled');

sdc=dc.*s; % Downconvert
subplot(3,1,3);
stem(sdc,'filled');
legend('s','dc','sdc')

figure(2); plot_freq_spectrum(sdc, Fs, 0, 0, 0, 0, 1)


% =========================================================================
% =========================================================================


% Create lp filter
% Ntaps=60; % Gives very smooth low pass down sampled signal
Ntaps=6;   % Gives an ok signal        
Fp  = B/2;       % Passband-edge at B/2 (edge of signal bandwidth)
Rp  = 0.0057565; % Corresponds to 0.01 dB peak-to-peak ripple (from matlab)
Rst = 1e-3;       % Corresponds to 80 dB stopband attenuation (from matlab)
filt = firceqrip(Ntaps,Fp/(Fs/2),[Rp Rst],'passedge'); % eqnum = vec of coeffs
fvtool(filt,'Fs',Fs,'Color','White') % Visualize filter
Nfilt=length(filt); 


Nrot=floor(Nfilt/2); % Number of taps rotated by filter


Nrot_end=ceil(Nfilt/2)-1;
sdcpad=filter_prepad(sdc,0,Nfilt); % Pad beginning with number of rotation taps
[sdcfilt,~]=filter(sdcpad,filt,Ns,Nfilt); % lp filter, naive implementation

% Plots
figure(7)
plot(s);
title('Signal in time')

figure(8)
plot(abs(sdc));
hold on; plot(abs(sdcfilt),'r--'); hold off;
title('Downconverted signal (unfiltered and filtered)')

figure(9)
f=(-NFFT/2:NFFT/2-1)*Fs/NFFT;
plot(f,abs(fftshift(fft(s,NFFT))));
title('Signal spectrum')

figure(10)
plot(f,abs(fftshift(fft(sdc,NFFT))),'b--');
hold on
plot(f,abs(fftshift(fft(sdcfilt,NFFT))));
title('Downconverted signal spectrum (unfiltered and filtered)')

% Create time signal  
x=[zeros(1,round(Fs*1*Ts)),s,zeros(1,round(Fs*2*Ts))];
x=x+randn(1,length(x))*sig;

figure(11);
plot((0:length(x)-1)*dt,abs(x));

xdcfilt=conv(x.*exp(-1i*2*pi*(0:length(x)-1)*f0/Fs),filt);
xdcfilt=filt_derot(xdcfilt,Ntaps);

hold on;
plot((0:length(xdcfilt)-1)*dt,abs(xdcfilt),'r--');
title('Received signal + downconverted');

p=1; q=floor(Fs/B); % Downconverted signal sampled at B Hz
Fslr=Fs/q; dtlr=1/Fslr;
% Resampled ref signal
xlr=resample(xdcfilt,p,q);
% Resampled input
slr=resample(sdcfilt,p,q);

scorr=conv(xlr,flipud(slr));

plot((0:length(scorr)-1)*dtlr,abs(scorr)*max(abs(xdcfilt))/max(abs(scorr)),'o-k');

noise_std = sqrt(var(scorr));
threshold = scale * noise_std;
yline(threshold);

[tmp,sigmid]=max(abs(scorr));
sigstart=sigmid-ceil(Ns*Fslr/Fs)/2;
sigend=sigmid+ceil(Ns*Fslr/Fs)/2;       % ?? what are these
xline((sigend-1)*dtlr,'k--');
xline((sigstart-1)*dtlr,'k--');
hold off;



% =========================================================================
% =========================================================================

%% Sonar implementation
% ADC input

% clear;close all; clc;
ADCRES=2^12; 
INGAIN=.1;
% % Constructed signal
% ADC=sig2ADC(x,ADCRES,INGAIN); % Convert to ADC input

% Sampled signal (using signal generator into sonar)
% dpath = '/Users/yaolinge/OneDrive - NTNU/SD271X Master thesis/demo';
dfile=get_data_sonarfile('pwmsig.txt',1); % Downloaded data
Npoints=1000;
ADC=transpose(dfile(1:Npoints));

plot(ADC);

% Ntaps=60; % Gives very smooth low pass down sampled signal
Ntaps=6;   % Gives an ok signal        
Fp  = B/2;       % Passband-edge at B/2 (edge of signal bandwidth)
Rp  = 0.0057565; % Corresponds to 0.01 dB peak-to-peak ripple (from matlab)
Rst = 1e-3;       % Corresponds to 80 dB stopband attenuation (from matlab)
filt = firceqrip(Ntaps,Fp/(Fs/2),[Rp Rst],'passedge'); % eqnum = vec of coeffs
% fvtool(filt,'Fs',Fs,'Color','White') % Visualize filter
Nfilt=length(filt); 


ADC=ADC-mean(ADC); % Center around 0 (remove dc spectral component in a fast way)
filt_ADC=sig2FXP(filt,ADCRES); % Make into fixed point implmenetation (integers)

figure
pspectrum(ADC, Fs)

filt_ADCc=re2complex(filt_ADC); % Convert to sonar complex format
filt_ADCc=rescale_minC(filt_ADCc,100); % Rescale filter so smallest number is 100
Nadc=length(ADC);

% Prepad input (with sample values in the sonar implementation)
ADCpad=filter_prepad(ADC,0,Nfilt);

% Make the ADC signal complex valued
ADCc=re2complex(ADCpad);
Nadcpad=length(ADCpad);


% Downconversion exponential signal
ADCdc.re=sig2FXP(cos(2*pi*(0:Nadcpad-1)*f0/Fs),ADCRES); % 16bit
ADCdc.im=sig2FXP(sin(-2*pi*(0:Nadcpad-1)*f0/Fs),ADCRES); % 16bit

% Downconvert
INdc=mult_complexC(ADCdc,ADCc); % Store in 32 bit

figure
pspectrum(absC(INdc), Fs)
% (A rescale should be done here in the sonar, but I'm
%  not sure there is time)

% LP filter downconverted input (both complex)
INdclp=filterC(INdc,filt_ADCc,Nadc,Nfilt);

figure
pspectrum(absC(INdclp), Fs)

INdclp=rescale_maxC(INdclp,2^15-1);

figure(666); subplot(2,2,1); plot(INdclp.re); subplot(2,2,2); plot(INdclp.im);
% Either prepad or rotate filtered output
INdclp.re=filt_derot(INdclp.re,Ntaps); 
INdclp.im=filt_derot(INdclp.im,Ntaps); 
subplot(2,2,3); plot(INdclp.re); subplot(2,2,4); plot(INdclp.im);

% Resample the downconverted signal to B sampling rate
INbaseband.re=resample(INdclp.re,p,q);
INbaseband.im=resample(INdclp.im,p,q);
% (Rescale after resampling in sonar)
Fsnew=Fs*p/q; % =B 
dtB=1/B;
Nsb=length(INbaseband.re); % Length of baseband vector

figure(7)
plot((0:Nadc-1)*dt,abs(ADC));
hold on; 
plot((0:Nadc-1)*dt,absC(rescale_maxC(INdclp,max(abs(ADC)) )),'-or');
plot((0:Nsb-1)*dtB,absC(rescale_maxC(INbaseband,max(abs(ADC)) )),'-ok');
hold off;
title('ADC input and downconverted signal')

aend=1;

function [x_c]=re2complex(x)
x_c.re=x;
x_c.im=zeros(1,length(x));
end

function y=rescale_maxC(y,maxvaly)
maxy=0;
for i=1:length(y.re)
    if(abs(y.re(i))>maxy)
        maxy=abs(y.re(i));
    end
end

for i=1:length(y.im)
    if(abs(y.im(i))>maxy)
        maxy=abs(y.im(i));
    end
end

if maxy>maxvaly
%     scale=ceil(maxvaly/maxy); % to avoid overflow
    for i=1:length(y.re)
        y.re(i)=(y.re(i)*maxvaly)/maxy;
        y.im(i)=(y.im(i)*maxvaly)/maxy;
    end
end

end

function y=rescale_minC(y,minvaly)
miny=2^31-1;
for i=1:length(y.re)
    if( abs(y.re(i))<miny && abs(y.re(i))~=0 )
        miny=abs(y.re(i));
    end
end

for i=1:length(y.im)
    if( abs(y.im(i))<miny && abs(y.im(i))~=0 )
        miny=abs(y.im(i));
    end
end

if miny>minvaly
    for i=1:length(y.re)
        y.re(i)=(y.re(i)*minvaly)/miny;
        y.im(i)=(y.im(i)*minvaly)/miny;
    end
end
y.re=round(y.re);
y.im=round(y.im);
end

function [xpad]=filter_prepad(x,padval,Nfilt)
% IN THE SONAR THE PADDING NEEDS TO BE SAMPLED VALUES
Nrot=floor(Nfilt/2); % Number of taps rotated by filter
Nrot_end=ceil(Nfilt/2)-1;
xpad=[ones(1,Nrot)*padval,x,ones(1,Nrot_end)*padval];
end

function [ADC]=sig2ADC(x,ADCRES,INPUTGAIN)
% Convert analog signal to sampled complex sonar fixed point representation
% ADC=round((INPUTGAIN*(x/max(abs(x))/2)+0.5)*ADCRES); % Convert to ADC input
ADC=round((INPUTGAIN*(x/max(abs(x))/2))*ADCRES); % Convert to ADC input

end

function [ADC]=sig2FXP(x,FXP_RES)
% Convert analog signal to sampled complex sonar fixed point representation
ADC=round( (x/max(abs(x))/2)*FXP_RES ); % Convert to ADC input
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

function xabs=absC(x)
    xabs=sqrt((x.re).^2+(x.im).^2);
end

function [res,Nvalid]=correlateC(data,filt,Ndata,Nfilt)

% res=zeros(1,Ndata+2-2*Nfilt);
res=zeros(1,Ndata);
intersum=zeros(1,Nfilt);

iires=1; % Index of result
for i=1:Ndata
    if(i==Ndata)
        a=1;
    end
    intersum(:)=mult_complexC(data(i:i+Nfilt-1),fliplr(filt)); %% FLIPPED ORDER
%         intersum(:)=data(i:i+Nfilt-1).*filt;
    res(iires)=sum(intersum);
    iires=iires+1;
%     i
end
Nvalid=iires-1;
end

function [res]=filterC(data,filt,Ndata,Nfilt)

% res=zeros(1,Ndata+2-2*Nfilt);
res=re2complex(zeros(1,Ndata));
intersum=re2complex(zeros(1,Nfilt));

% iires=1; % Index of result
for i=1:Ndata
    if(i==Ndata)
        a=1;
    end
    dataslice.re=data.re(i:i+Nfilt-1); 
    dataslice.im=data.im(i:i+Nfilt-1); 
    intersum(:)=mult_complexC(dataslice,filt);
%         intersum(:)=data(i:i+Nfilt-1).*filt;
    res=assign_complex(res,i,sum_complexC(intersum));
%     iires=iires+1;
%     i
end
% Nvalid=iires-1;
end

function output=assign_complex(output,index,value)
    output.re(index)=value.re;
    output.im(index)=value.im;
end

function res=sum_complexC(val)
    res.re=sum(val.re);
    res.im=sum(val.im);
end

% Vector & single value function
function res=mult_complexC(in1,in2)
    res.re=in1.re.*in2.re-in1.im.*in2.im;
    res.im=in1.re.*in2.im+in1.im.*in2.re;
end





































