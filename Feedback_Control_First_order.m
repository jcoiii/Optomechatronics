clear; clc;
%% Controllability test
% First, i define A and B matrix of the system's state space. A and B will
% be used to determine the controllability of the system. Should the rank
% of controllability matrix is neq to length of A, dont bother to design
% the controller. no seriously, some states might be not "effectively
% controlled". This will show whether the system is controllable or not.

% 1 pole 0 zeros
A = 0.9709; 
B = 0.07888;

controllability_matrix = ctrb(A, B);
rank_controllability_matrix = rank(controllability_matrix);

c_check = isequal(rank_controllability_matrix,length(A));
if c_check == 1
    disp("System is controllable");
else
    disp("System is not controllable");
end


%% Control Design
Kp = 1;  
Ki = 1e-2;
Kd = 0;
desired_state = 0.15;
t = 0:0.001:2;
N = length(t);

x0 = 0;

x = zeros(1, N);
u = zeros(1, N);
x(1) = x0;
e_sum = 0;
e_prev = 0;

for k = 1:N-1
    e = desired_state - x(k);
    e_sum = e_sum + e;
    de = e - e_prev;
    e_prev = e;  
    u_unsaturated = Kp * e + Ki * e_sum + Kd * de;
    u_saturated = max(-0.25, min(0.25, u_unsaturated));
    u(k) = u_saturated;
    x(k+1) = A * x(k) + B * u(k);
end

%% Response PLot
figure(1);
plot(t, x);
xlabel('Time', Interpreter='latex',fontsize=15);
ylabel('$x_1$', Interpreter='latex',fontsize=15);
title('Output');
figure(2)
plot(t, u)
xlabel('Time', Interpreter='latex',fontsize=15);
ylabel('$u(k)$', Interpreter='latex',fontsize=15);
title('Input');
