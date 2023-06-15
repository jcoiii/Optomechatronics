clear; clc;
% Coefficients of the numerator
num = [0, -0.007914, -0.01209];

% Coefficients of the denominator
den = [1, -1.957, 0.959];

% Create the transfer function
sys = tf(num, den);  % '-1' indicates discrete time system
sys_ss = ss(sys);
[A,B,C,D] = tf2ss(num,den);
% Convert to observable canonical form
Ao = transpose(sys_ss.A);
Bo = transpose(sys_ss.C);
Co = transpose(sys_ss.B);
Do = sys_ss.D;