function plot_data(filename)
dpath = 'C:\Users\geyao\Desktop\';
y = get_data_sonarfile([dpath, filename, '.txt'], 1);
% figure(); 
plot(y); 
title(filename); xlabel('samples'); ylabel('ADC level');
grid on; grid minor; box on;

