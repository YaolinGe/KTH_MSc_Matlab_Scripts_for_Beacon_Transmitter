function plot_freq_spectrum(y, fs, shift, normalisation, logornot)
%% plot_freq_spectrum(y,fs)
%% plots the power spectral density of the signal y

n = length(y);
N = 1e3 * n;
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
if normalisation
    f = f/fs;
end %if

if logornot
    power = 10*log10(power);
end %if

figure();
grid on; grid minor; box on;
plot(f, power)
xlabel('frequency [Hz]');
ylabel('');
title('');
legend('','');
    
end % plot_freq_spectrum
