function plot_dc_output(y, fc, ydc, B)
Fs = 160e3;
Y = signal_dc(y, fc, Fs, B);
Y = absC(Y);
t = (0:length(Y)-1)/B;
figure(); hold on
y = y - mean(y);
p1 = plot((0:length(y)-1)/Fs, abs(y));
p2 = plot(t, Y*max(abs(y))/max(Y), 'ro-');

tdc = (0:length(ydc)-1)/B;
p3 = plot(tdc, ydc*max(abs(y))/max(abs(ydc)), 'ko-');
grid on; grid minor; box on;
legend([p1, p2, p3], 'original signal', 'Matlab simulation', 'Hardware implementation', 'Matlab simualtion blockwise')

title('DC implementation');
xlabel('time');

