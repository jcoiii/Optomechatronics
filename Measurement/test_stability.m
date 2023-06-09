a = [tf12.Denominator];  
poles = roots(a);

mag = abs(poles);
if all(mag < 1)
    disp('The system is stable');
else
    disp('The system is unstable');
end