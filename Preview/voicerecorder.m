clear
close all
clc


% msq = mseq(2,15,1,2);
% fs = 32768;







% r = audioplayer(msq,fs);
% tic
% play(r)
% toc



r = audiorecorder;
tic
recordblocking(r,2);
toc



y = getaudiodata(r);

fid = fopen('yaolin.txt','w');
fprintf(fid, '%.12f\n', y);
fs = 8e3;

t = (0:length(y)-1)/fs;
figure()
plot(t,y)

n = pow2(nextpow2(length(y)));
Y = fft(y,n);
power = abs(Y).^2/n;
f = (-n/2:n/2-1)*(fs/n);
% sound(y,fs)
figure()
plot(f,power)
