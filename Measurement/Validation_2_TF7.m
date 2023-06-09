clear; clc;
% Define the discrete transfer function in the z-domain
numz = 0.935*[0 -0.2008 0.2347];
denz = [1 -1.968 0.9695];


Ts = 0.001;
sysz = tf(numz, denz, Ts, 'Variable', 'z^-1');

% Convert to the s-domain (continuous time)
sysc = d2c(sysz);


% Time vector
t = 0:0.001:10;

% Step input parameters
A1 = 0;         
A2 = -0.0234;  
T = 2.5; 
total_duration = 10.0; 

% Time vector


% Input signal vector
u(t >= 0 & t < 2.45) = 0; %-0.000488281;
u(t >= 2.45 & t < 5) = -0.0234;
u(t >= 4.95 & t < 7.45) = 0;
u(t >= 7.45 & t <= 10) = -0.0234;
y = lsim(sysz, u, t);
figure(1)
plot(t, y, 'b-');
xlabel('Time');
ylabel('Amplitude');
legend('Input', 'Output');


data = load("exp1_032.mat");
time_1 = data.exp1_032.X.Data;
time = time_1(1125:10125)-1.1728;
inp_lvdt = data.exp1_032.Y(1).Data; % Amplifier out
inp_lvdt = inp_lvdt(1125:10125);
out_lvdt = data.exp1_032.Y(2).Data; % LVDT Out
out_lvdt = out_lvdt(1125:10125);
figure(2)
plot(time,inp_lvdt, time, out_lvdt)

figure(3)
plot(time,inp_lvdt, t, u)
legend('Real', 'Sim');
figure(4)
plot(time,out_lvdt, t, y)
legend('Real', 'Sim');
xlabel('Time');
ylabel('Amplitude');
% legend('Real', 'Sim');
% title('Output Compare');
% figure(5)
% step(sysz)
% hold on
% plot(time,out_lvdt,'r-')
% hold off
% 
% figure(6)
% plot(time,out_lvdt,'r-')