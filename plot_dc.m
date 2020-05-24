function plot_dc(dfile)

Fs = 160e3; B = 5e3; f0 = 47e3;
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, dfile,'.txt'];
y = get_data_sonarfile(filename, 1);
y = y - mean(y);
t = (0:length(y)-1)/Fs;
plot(t,abs(y))

V = signal_dc(y, f0, Fs, B);
tdc = (0:length(V.re)-1)/B;
hold on;
plot(tdc, absC(rescale_maxC(V, abs(max(y)))), 'ro-')

end