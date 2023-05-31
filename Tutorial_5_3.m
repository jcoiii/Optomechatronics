clear; clc;
syms K
% Define P1 P2 as tf
num_p1 = [1 5];
den_p1 = [double(coeffs(expand((K+1)^5)))];
num_p2 = [1 0];
den_p2 = [1 1];
P1 = tf(num_p1,den_p1);
P2 = tf(num_p2,den_p2);
sys = P1*P2;
poles_sys = pole(sys);
%% Use matlab's "Bandwidth"
answer = bandwidth(sys);
% %% Use pole tracing
% figure(1)
% pzplot(sys)
% 
% poles = pole(sys);
% sorted_poles = sort(poles, 'ComparisonMethod', 'real');
% dominant_poles = sorted_poles(1:2);
% bandwidth = abs(imag(dominant_poles(2)) - imag(dominant_poles(1)));
% 
% %% Use Bode Plot response
% figure(2)
% bode(sys)