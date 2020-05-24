clear;close all; clc;

% fs = 160e3;
% t = 0:1/fs:1999/fs;
% a = cos(2*pi*20e3*t);
% phi = sin(2*pi*40e3*t);
% fc = 50e3;
% x = a.*cos(2*pi*fc*t+phi);
% plot(t, x)


% load chirp.mat
% 
% pspectrum(y, Fs, 'spectrogram')


% load handel.mat
% % sound(y, Fs)
% pspectrum(y,Fs, 'spectrogram')


% y = audioread('guitartune.wav');
% Fs = 44.1e3;
% % sound(y,Fs)
% pspectrum(y,  Fs,'spectrogram')


% load officetemp.mat
% plot(temp)
% 
% fs = 160e3;
% pspectrum(temp, fs, 'spectrogram')
% 
% 

% [y, Fs] = audioread('bluewhale.au');
% sound(y,4*Fs)
% 
% pspectrum(y, Fs,'spectrogram')



[y, Fs] = audioread('yaolin_2.m4a');
% sound(y,.25*Fs)
obj = audioplayer(y,3*Fs);
play(obj)

pspectrum(y, Fs,'spectrogram')