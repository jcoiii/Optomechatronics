clear; clc;
load('new_tf.mat');
numz = tf8.Numerator;
denz = tf8.Denominator;  
% numz = [-0.01881, 0.01692];     % Numerator coefficients
% denz = [1, -1.975, 0.9756];     % Denominator coefficients

Ts = 0.001;
t = 0:0.001:7.5;
t_shift = t-0.05334;
sysz = tf(numz, denz, Ts, 'Variable', 'z^-1');

% pulse sign
u = zeros(size(t));
u(t >= 0 & t <= 2.5) = 0;
u(t > 2.5 & t < 5) = 0.25;
u(t > 5 & t < 7.5) = 0;
% u(t >= 3 & t < 4.5) = 0;
% u(t >= 4.5 & t <= 5) = 0.25;

u_gain = 1.07;
% Sine wave
% f = 0.5; 
% A = 0.2; 
% u = -A*sin(2*pi*f*t);
y = lsim(sysz, u*u_gain, t);
% figure(1)
% plot(t, u, 'b-');
% xlabel('Time');
% ylabel('Amplitude');

%%
data = load("combined_data.mat");
time = data.combined_data(5).time_tr;
time = time - time(1);
inp_lvdt = data.combined_data(5).inp_ampf_tr; % Amplifier In
out_lvdt = data.combined_data(5).out_lvdt_tr; % LVDT Out
zero_crossings = find(diff(sign(out_lvdt)) ~= 0);

figure(1)
plot(time, out_lvdt, 'b-');
xlabel('Time');
ylabel('Amplitude');

%%
time = time(1:7501);
inp_lvdt = inp_lvdt(1:7501);
out_lvdt = out_lvdt(1:7501);

figure(2)
plot(time,inp_lvdt, time, out_lvdt)
title('Input - Output Plot')
xlabel('Time');
ylabel('Amplitude');
legend('Input', 'Output');

%%
figure(3)
plot(time,inp_lvdt, t_shift, u)
title('Input Comparison Plot')
xlabel('Time');
ylabel('Amplitude');
legend('Real Measurement', 'Simulated');

%%
figure(4)
plot(time,out_lvdt, t_shift, y)
legend('Real Measurement', 'Simulated');
title('Output Compare');
xlabel('Time');
ylabel('Amplitude');

% figure(5)
% step(sysz)
% hold on
% plot(time,out_lvdt,'r-')
% hold off
% 
% figure(6)
% plot(time,out_lvdt,'r-')