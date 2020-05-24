clear;close all; clc;


N = 6;

fs = 160e3;
B = 5000;
fc = B/fs;
Ap = 1;     %passband ripple, [dB]
Ast = 30;   % stopband attenuation, [dB]

f = [0 fc 1.1*fc 1];
a = [1 1 0 0];


% FIR filter design

b1 = firpm(N, f, a);        % Parks-McClellan optimal FIR filter design
b2 = firls(N, f, a);
b3 = fir1(N, fc, 'low');    % Window-based FIR filter design
b4 = fir2(N, f, a);         % Frequency sampling-based FIR filter design
b5 = ellip(N, Ap, Ast, fc);  % Elliptic filter design

dp = .2;    % maximum deviation from passband 1
ds = 1;     % maximum deviation from stopband 0
% b6 = fircls(N, fc, Ap, Ast);% Constrained least square, lowpass and highpass, linear phase, FIR filter design


% All frequency values are in kHz.
Fs = 80;  % Sampling Frequency

N      = 6;    % Order
Fc     = 2.5;  % Cutoff Frequency
DpassU = 0.1;  % Upper Passband Ripple
DpassL = 0.1;  % Lower Passband Ripple
DstopU = 0.1;  % Upper Stopband Attenuation
DstopL = 0.1;  % Lower Stopband Attenuation

% Calculate the coefficients using the FIRCLS function.
b  = fircls(N, [0 Fc Fs/2]/(Fs/2), [1 0], [1+DpassU DstopU], [1-DpassL ...
            -DstopL]);
Hd = dfilt.dffir(b);



%% IIR filter design










































