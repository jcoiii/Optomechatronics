% Define the coefficients of the denominator polynomial
a = [1 -1.935 0.9351];

% Calculate the poles by finding the roots of the denominator
poles = roots(a);

% Check the magnitude of each pole
mag = abs(poles);

% If the magnitude of all poles is less than 1, the system is stable
if all(mag < 1)
    disp('The system is stable');
else
    disp('The system is unstable');
end