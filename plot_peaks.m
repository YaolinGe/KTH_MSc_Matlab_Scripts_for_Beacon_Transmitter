function plot_peaks(x, y)
[pks, locs] = findpeaks(y);
[val idx] = max(pks);
plot(y);
hold on;
N = 1:3;
plot(x(locs(idx(N))), pks(idx(N)), '*');
str = string(int16(x(locs(idx(N)))));
text(x(locs(idx(N))), pks(idx(N)), str(N));
end
