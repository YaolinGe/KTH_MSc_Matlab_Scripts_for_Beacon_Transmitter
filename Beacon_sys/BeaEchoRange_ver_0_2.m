close all; clear all; clc;
vsound = 1460;

data = get_data_sonarfile('square_tank_Fs160kHz.txt',1);

Fs = 160e3;
dt = 1/Fs;

t  = (0:length(data)-1)/Fs;
range = t*vsound/2;
figure(1);
plot(range, data);
title('sample data from pool at ca 4m');
ylabel('12 bit resolution');
xlabel('m');
hold on;



