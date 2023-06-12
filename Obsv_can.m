% Coefficients of the numerator
B = [0, -0.07888];

% Coefficients of the denominator
A = [1, -0.9709];

% Create the transfer function
sys = tf(B, A, -1);  % '-1' indicates discrete time system

% Convert to state-space representation
sys_ss = ss(sys);

% Convert to observable canonical form
Ao = transpose(sys_ss.A);
Bo = transpose(sys_ss.C);
Co = transpose(sys_ss.B);
Do = sys_ss.D;

% The Ao, Bo, Co, Do matrices represent the system in observable canonical form
