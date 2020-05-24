function [ind] = MF_detector(yref, y_dc, scale)
%% [ind] = MF_detect(yref, y_dc)
%% returns the index corresponds to the maximum correlation

Scorr = conv(y_dc, conj(flipud(yref)));
[peak, ind] = max(Scorr);
noise_std = sqrt(var(y_dc));
threshold = noise_std * scale;
if peak < threshold
    ind = -1;
end %if

% plot the resulting convolution
n = (0:length(Scorr)-1)';
figure();
grid on; grid minor; box on;
plot(n,Scorr)
xlabel('sample');
xlim([n(1), n(end)]);
ylabel('correlation');
title('');
hold on
% plot the noise threshold
plot([n(1) n(end)], [threshold threshold], 'k-', 'linewidth', 2.5)


end % MF_detect