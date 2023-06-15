clear; clc;
% Coefficients of the numerator
B = [0, -0.07888];

% Coefficients of the denominator
A = [1, -0.9709];

% Create the transfer function
sys = tf(B, A, -1);  % '-1' indicates discrete time system

% Convert to state-space representation
[A,B,C,D] = tf2ss(B,A);

% Convert to observable canonical form


% The Ao, Bo, Co, Do matrices represent the system in observable canonical form
