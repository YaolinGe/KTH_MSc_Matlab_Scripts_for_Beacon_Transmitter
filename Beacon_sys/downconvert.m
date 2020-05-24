function [y_dc, fslr] = downconvert(y, fc_dc, fs, B)
%% [y_dc] = downconvert(y, fc, fc_dc)
%% returns the downcoverted version of the input signal

y_dc = (exp(-1i*2*pi*(0:length(y)-1)*fc_dc/fs))' .* y;

% Low pass the signal via lp filter
% Ntaps=60; % Gives very smooth low pass down sampled signal
Ntaps=6;   % Gives an ok signal        
Fp  = B/2;       % Passband-edge at B/2 (edge of signal bandwidth)
Rp  = 0.0057565; % Corresponds to 0.01 dB peak-to-peak ripple (from matlab)
Rst = 1e-3;       % Corresponds to 80 dB stopband attenuation (from matlab)
filt = (firceqrip(Ntaps,Fp/(fs/2),[Rp Rst],'passedge'))'; % eqnum = vec of coeffs
% fvtool(filt,'Fs',Fs,'Color','White') % Visualize filter
Nfilt=length(filt); 
Ns = length(y);
y_dc = filter_pad(y_dc, Nfilt); %pad zeros before filter

% [y_dc, ~] = filter(y_dc, filt, Ns, max(length(Nfilt), length(y_dc))-1);
y_dc = filter(1, filt, y_dc);

y_dc = filter_depad(y_dc, Ntaps);

% resample the signal using lower sampling rate
p = 1;
q = floor(fs/B);
fslr = fs/q;
dtlr = 1/fslr;
y_dc = resample(y_dc, p, q);

end %downconvert


function [y_pad] = filter_pad(y, Nfilt)
%% [y_pad] = filter_pad(y, Nfilt)
%% pads zeros on the original sequences on both sides

Nfront = floor(Nfilt/2);
Nend = ceil(Nfilt/2)-1;
y_pad = [zeros(Nfront, 1); y; zeros(Nend, 1)];

end %filter_pad


function [y_dc] = filter_depad(y_dc, Ntaps)
%% [y_dc] = filter_depad(y, Nfilt)
%% returns the resulting sequence after depadding those zeross
Npad = floor(Ntaps/2);
if(length(y_dc(:,1))<length(y_dc(1,:)))
    y_dc = fliplr(circshift(fliplr(y_dc), Npad));
else
    y_dc = flipud(circshift(flipud(y_dc), Npad));
end %if
y_dc(end-Npad+1:end) = 0;

end % filter_depad