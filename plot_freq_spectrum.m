function plot_freq_spectrum(y, fs, shift, normalised, logornot, half, triple)
%% plot_freq_spectrum(y,fs)
%% plots the power spectral density of the signal y

n = length(y);
N = 10 * n;
Y = fft(y,N);
n = length(Y);
if ~shift
    power = abs(Y).^2/n;
    f = (0:n-1)*fs/n;
else
    Y = fftshift(Y);
    power = abs(Y).^2/n;
    f = (-n/2:n/2-1)*fs/n;
end %if 

if normalised
    f = f/fs;
end %if

if logornot
    power = pow2db(power);
end %if
if half
    power = power(1:length(power)/2);
    f =  f(1:length(f)/2);
end %if

% figure();
if triple
    subplot(3,1,1); pspectrum(y, fs); subplot(3,1,2); powerbw(y, fs);
    subplot(3,1,3); plot(f, power); xlabel('frequency [Hz]');ylabel('PSD');
else
    grid on; grid minor; box on;
    plot(f, power)
    xlabel('frequency [Hz]');
    ylabel('');
    title('');
end %if
% legend('','');
    
end % plot_freq_spectrum
