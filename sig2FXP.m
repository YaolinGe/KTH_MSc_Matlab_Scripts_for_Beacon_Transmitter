function [ADC]=sig2FXP(x,FXP_RES)
% Convert analog signal to sampled complex sonar fixed point representation
ADC=round(x/max(abs(x))*FXP_RES ); % Convert to ADC input
% ADC=round( (x/max(abs(x))/2)*FXP_RES ); % Convert to ADC input

end