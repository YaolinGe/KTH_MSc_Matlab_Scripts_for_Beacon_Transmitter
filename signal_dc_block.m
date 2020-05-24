function [Xbase, Xpad, Xadc, Xadclp, Xdc3, Xdc4] = signal_dc_block(x, fc, Fs, B)
% ,Xre, Xim, xlpre, xlpim, xdcre, xdcim, xrere, xreim
%% signal_dc returns the downconverted version of the input signal

ADCRES = pow2(12);

if iscolumn(x)
    x = x';
end %if

x = sig2FXP(x, ADCRES);

Nbpad = 3;
Nfwpad = 3;

adc_buffer_len = 4096;

N_input = length(x);
Nsample = adc_buffer_len;
Nframe = Nsample / 2;
Nframes = ceil(N_input / Nframe); % 
storage_vector = zeros(1,Nframes*(Nframe+Nfwpad));

for i = 1 : N_input
    storage_vector(i) = x(i);
end

j = 0;
while(Nframes)
    j = j + 1;
    Nframes = Nframes - 1; %prepad the adc buffer so to make frame downconversion works as expected
    adc_buffer(j, :) = storage_vector(1:Nframe + Nfwpad);
    overlapsave(j, :) = adc_buffer(j, [end - Nbpad - Nfwpad + 1:end-Nfwpad]);
    storage_vector(1:Nframe) = [];
    if j == 1
        adc_buffer_prepad(j, :) = [zeros(1,Nbpad), adc_buffer(j,:)];
    else
        adc_buffer_prepad(j, :) = [overlapsave(j-1,:), adc_buffer(j,:)];
    end
    [adc_buffer_dc(:, j), Xadc(:, j), Xadclp(:,j),Xdc3(:,j), Xdc4(:,j)] = downconvert_adc_buffer(adc_buffer_prepad(j,:), fc, Fs, B);

%     [adc_buffer_dc(:, j), Xre(:, j), Xim(:,j), xlpre(:,j), xlpim(:,j), xdcre(:,j), xdcim(:,j), xrere(:,j), xreim(:,j)] = downconvert_adc_buffer(adc_buffer_prepad(j,:), fc, Fs, B);
end
adc_buffer_dc = adc_buffer_dc(:);
Xadc = stretch_vector(Xadc(:));
Xadclp = stretch_vector(Xadclp(:));
Xdc3 = stretch_vector(Xdc3(:));
Xdc4 = stretch_vector(Xdc4(:));

Xbase = adc_buffer_dc;
% Xbase = adc_buffer_prepad;
Xpad = adc_buffer_prepad;

end