function [ADC]=sig2ADC(x,ADCRES,INPUTGAIN)
% Convert analog signal to sampled complex sonar fixed point representation
% ADC=round((INPUTGAIN*(x/max(abs(x))/2)+0.5)*ADCRES); % Convert to ADC input
ADC=round((INPUTGAIN*(x/max(abs(x))/2))*ADCRES); % Convert to ADC input

end