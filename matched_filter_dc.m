function corr_time = matched_filter_dc(y, fc, Fs, B)
Nsample = 2048;
dc_factor = 32;
Ndc_passband = Nsample;
Ndc_baseband = Ndc_passband / dc_factor; 
Npulse = 34;
Nframe = Nsample + 2 * Npulse;
Nfwpad_dcfilt = 3;
Nbpad_dcfilt = 3;

Nframes = ceil(length(y) / Nframe); % used to find non-overlapping samples in the buffer
storage_vector = zeros(1, Nframes*(Nframe+Nfwpad_dcfilt));

storage_vector(1:length(y)) = y;

% generate reference signal dc so to use everytime
np = 10;
yref_dc = generate_refsig_sine(np, fc);

Nfilt = length(yref_dc.re);

j = 0;
while(Nframes)
    j = j + 1;
    Nframes = Nframes - 1; %prepad the adc buffer so to make frame downconversion works as expected
    adc_buffer(j, :) = storage_vector(1:Nframe + Nfwpad_dcfilt);
    overlapsave(j, :) = adc_buffer(j, [end - Nfwpad_dcfilt - Nbpad_dcfilt + 1:end - Nfwpad_dcfilt]);
    storage_vector(1:Nframe) = []; % only Nframe value is removed, keep overlapped values in the buffer
    if j == 1
        adc_buffer_prepad(j, :) = [zeros(1,Nbpad_dcfilt), adc_buffer(j,:)];
    else
        adc_buffer_prepad(j, :) = [overlapsave(j-1,:), adc_buffer(j,:)];
    end
    adc_buffer_dc(:, j) = downconvert_adc_buffer(adc_buffer_prepad(j,:), fc, Fs, B);
    corr_time_dc(:, j) = filterC(adc_buffer_dc(:, j), yref_dc, Ndc_baseband, Nfilt);
end
% corr_time_dc = corr_time_dc(:);
corr_time = corr_time_dc;
% corr_time = adc_buffer_prepad;

end





