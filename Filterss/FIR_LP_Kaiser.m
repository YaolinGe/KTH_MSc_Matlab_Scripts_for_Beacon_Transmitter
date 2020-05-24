function Hd = FIR_LP_Kaiser
%FIR_LP_KAISER Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.7 and Signal Processing Toolbox 8.3.
% Generated on: 27-Feb-2020 14:50:46

% FIR Window Lowpass filter designed using the FIR1 function.

% All frequency values are in kHz.
Fs = 80;  % Sampling Frequency

N    = 6;        % Order
Fc   = 2.5;      % Cutoff Frequency
flag = 'scale';  % Sampling Flag
Beta = 0.5;      % Window Parameter

% Create the window vector for the design algorithm.
win = kaiser(N+1, Beta);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Fc/(Fs/2), 'low', win, flag);
Hd = dfilt.dffir(b);

% [EOF]