clear;close all;clc;


rho = 1025;
g = 9.81;
h = 0:4000;

pressure = (101325 + rho * g * h)/1e6;

plot(pressure, h, 'k-', 'linewidth', 2)
set(gca, 'Xaxislocation', 'top', 'yaxislocation', 'left', 'ydir', 'reverse')
pbaspect([1 1.5 1])
plot_grid();
xlabel('pressure [MPa]')
ylabel('depth [m]')



