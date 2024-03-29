function Hd = kaiser_function
%KAISER Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.4 and DSP System Toolbox 9.6.
% Generated on: 11-Jul-2019 23:48:01

% FIR Window Bandpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 16000;  % Sampling Frequency

N    = 50;       % Order
Fc1  = 2000;     % First Cutoff Frequency
Fc2  = 4000;     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
Beta = 8;        % Window Parameter

% Create the window vector for the design algorithm.
w = kaiser(200,2.5);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass');
Hd = dfilt.dffir(b);

% [EOF]
