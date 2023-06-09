% Define your numerator and denominator coefficients of your transfer function
num = [-0.01881, 0.01692];     % Numerator coefficients
den = [1, -1.975, 0.9756];     % Denominator coefficients

% Create a transfer function
sys = tf(num, den, 0.001); % T is the sample time for the discrete system

% Convert to controllable canonical form
[A_c, B_c, C_c, D_c] = tf2ss(num, den);

% Convert to observable canonical form
A = A_c'; 
B = C_c';
C = B_c';
D = D_c;

% % Create a state-space system in observable canonical form
% sys_obsv = ss(A, B, C, D, 0.001);

% Display the matrices
disp('A matrix: ');
disp(A);

disp('B matrix: ');
disp(B);

disp('C matrix: ');
disp(C);

disp('D matrix: ');
disp(D);