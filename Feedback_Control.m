clear; clc;
%% Controllability test
% First, i define A and B matrix of the system's state space. A and B will
% be used to determine the controllability of the system. Should the rank
% of controllability matrix is neq to length of A, dont bother to design
% the controller. no seriously, some states might be not "effectively
% controlled". This will show whether the system is controllable or not.

% % 2 poles 2 zeros
% A = [0 -0.9604; 1 1.959];
% B = [0.006379; 0.002416];

% 2 poles 1 zeros
A = [0 -0.9616; 1 1.96];
B = [0; -0.00373];

controllability_matrix = ctrb(A, B);
rank_controllability_matrix = rank(controllability_matrix);

c_check = isequal(rank_controllability_matrix,length(A));
if c_check == 1
    disp("System is controllable");
else
    disp("System is not controllable");
end

%% Steady State 
% We want to bring the system to it's steady state. But keep in mind, the
% controller is designed to bring the system to it's steady state. This can
% be calculated with the given algorithm. x2s is lvdt output based on the
% steady state of the 
syms x1s us

% % 2 pole 2 zero
% a1 = -1.959;
% a2 = 0.9604;
% b1 = 0.002416;
% b2 = 0.006379;

% 2 pole 1 zero
a1 = -1.96;
a2 = 0.9616;
b1 = -0.00373;
b2 = 0;

% Second Order ss solver
x2s = 0.25; 
eq1 = -a2*x2s + b2*us == x1s;
eq2 = x1s -a1*x2s + b1*us == x2s;
sol = solve([eq1, eq2], [us, x1s]);
x1s_sol = double(sol.x1s);
desired_state = [x1s_sol; x2s]; % change to xs 1st order system, xs=0.15

%% Control Design
Kp = 5;  
Ki = 0.01;
Kd = 20;

t = 0:0.001:2;
N = length(t);

x0 = [0; 0];

x = zeros(2, N);
u = zeros(2, N);
x(:, 1) = x0;
e_sum = [0; 0];
e_prev = [0; 0];

for k = 1:N-1
    e = desired_state - x(:, k);
    e_sum = e_sum + e;
    de = e - e_prev;
    e_prev = e;  
    u_unsaturated = Kp' .* e + Ki' .* e_sum + Kd' .* de; 
    u_saturated = max(-0.25, min(0.25, u_unsaturated));
    u(:, k) = u_saturated;
    x(:, k+1) = A * x(:, k) + B * u(1,k);
end

%% Response PLot
figure(1);
subplot(2, 1, 1);
plot(t, x(1, :));
xlabel('Time', Interpreter='latex',fontsize=15);
ylabel('$x_1$', Interpreter='latex',fontsize=15);
title('Output');

subplot(2, 1, 2);
plot(t, x(2, :));
xlabel('Time', Interpreter='latex',fontsize=15);
ylabel('$x_2$', Interpreter='latex',fontsize=15);

figure(2);
plot(t, u(1, :));
xlabel('Time', Interpreter='latex',fontsize=15);
ylabel('$u(k)$', Interpreter='latex',fontsize=15);
title('Input');
