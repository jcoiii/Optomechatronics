%Let us consider the following system
%x(k+1) = 2x(k) + u(k)
%and the cost function be given by
% 0.5x^2(k_f) + 0.5*sum(2x(k)^2+u(k)^2)
%as in the tutorial question 1

%Based on the explicit solution to the state equation
%as in the batch approach, we have that
%X = [I;A;A^2;...;A^N]x(0) + [0 0 0 ...;B 0 ...;AB B ...]U
%X = S_of_x x(0) + S_of_u U

%Thus the cost function can be written as 
%J = U'HU + 2x(0)'FU + x(0)'S_of_x' Q_bar S_of_x x(0)
%where H = S_of_u' Q_bar S_of_u + R_bar, F = S_of_x' Q_bar S_of_u
%and Q_bar = block(Q,Q,..., Q,P) and R_bar = block(R,R,...,R)

%Consider the terminal time k_f = 2
%In our case above, A = 2, B = 1, Q = 1, P = 0.5, R = 0.5.
clear all;

A = 2; B = 1; Q = 1; P = 0.5; R = 0.5;

S_of_x = [1;A;A^2];
S_of_u = [0 0 0;B 0 0;A*B B 0];

Q_bar = [Q 0 0;0 Q 0;0 0 P*10000];
R_bar = [R 0 0;0 R 0;0 0 R];

H = S_of_u' * Q_bar * S_of_u + R_bar;
F = S_of_x' * Q_bar * S_of_u;

%Assume initial condition is 2
U_optimal = - inv(H)*F'*2;

%%

%We will find the optimization using fmincon as follows
options = optimoptions('fmincon','Algorithm','interior-point');
initial_condition = 2;
U_optimal = fmincon(@(U) costfunction(U,initial_condition),[0;0;0],[],[],[],[],[],[],[],options);

%%
% Let us check the resulting trajectory when we apply the solution of 
% U_optimal
clear x;

x(1) = 2;
x(2) = 2*x(1) + U_optimal(1);
x(3) = 2*x(2) + U_optimal(2);

%%
U_optimal = fmincon(@(U) costfunction_N(U,initial_condition,10),zeros(10,1),[],[],[],[],[],[],[],options);

%%
% Computation of the optimal feedforward control with terminal condition
% x(T) = xf, with terminal time T. We will use the same systems' setup as
% before, and extended to a higher dimensional linear system (with
% dimension 2).
% Similar as before, the computation of the cost function for the
% optimization code will be done in a separate m-file, which in this case
% will be costfunction_terminalcondition. The variable U_optimal will contain three
% different optimal variables: input_star, lambda_star and x_star which are
% three important components in the Pontryagin minimum principle. For the
% validation setup later, we will then extract the input_star from the
% calculated U_optimal. Note that the dimension of input_star is the same
% as the dimension of the column of B, the dimension of lambda_star and
% x_star will be the same as the dimension of the state x.

%xf = 5;
xf = [8;0];
T = 5;
%x0 = 2;
x0 = [2;0];
sizex = size(x0,1);

options = optimoptions('fmincon','Algorithm','interior-point');
U_optimal = fmincon(@(U) costfunction_terminalcondition(U,x0,xf,T),zeros(T+sizex*T*2,1),[],[],[],[],[],[],[],options);

%%
% Testing the U_optimal from the line above

%A = 2; B = 1; Q = 1; P = 0.5; R = 0.5;
A = [0 1;0.4 0.5];
B = [0;1];

clear x;
u = U_optimal(1:T);
x = zeros(sizex,T);

x(:,1) = x0;
for k = 1:T-1
    x(:,k+1) = A*x(:,k) + B*u(k);
end;


%% MPC for the scalar example
x = 10;u=0;
for k = 1:100
%The first part is we need to compute the first MPC control input  
U_optimal = fmincon(@(U) costfunction_N(U,x(k),10),zeros(10,1),[],[],[],[],[],[],[],options);
u(k) = U_optimal(1);
%u(k) =0;
x(k+1) = 2*x(k) + u(k);
end;

%% MPC for Cessna example
x0 = [0;0;0;10];
options = optimoptions('fmincon','Algorithm','interior-point');
global dummy;
%The commented matrix below is the discretized version of the Cessna model
%A =  [0.6136        0    0.157        0;
%     -0.128        1   0.1904        0;
%     -0.8697        0   0.5248        0;
%      -27.56    32.05   0.4087        1;];
%  B = [ -0.4539;-0.4436;-3.199; 0.6068];

%The systems matrix below is the continuous-time model of the Cessna model
A = [-1.2822 0 0.98 0;0 0 1 0;-5.4293 0 -1.8366 0;-128.2 128.2 0 0];
B = [-0.3;0;-17;0];
C = [0   1   0   0; 0   0   0   1];
D = [0;0];

%We set the initial condition of the state variables
x = x0;
%The variables below is to record the solution of the continuous-time
%system when it is given the piecewise constant input coming from the MPC
%controller
x_continuous_time =[];
total_time = [];
%The variable control_input is the piecewise constant input signal that is
%a result of the MPC computation
control_input = [];

N = 10; %Horizon length. When you set it to 3, you can see the instability

for k = 1:40
%The first part is we need to compute the first MPC control input  
U_optimal = fmincon(@(U) costfunction_cessna(U,x(:,k),N),zeros(N,1),[],[],[],[],[],[],[],options);
u(k) = U_optimal(1);

%We pass the computed input u(k) into a global variable as it will be used
%as a local variable in the computation of solution in the ODE. Note that
%the ODE solver of matlab accepts only function that is defined on the time
%and on the current state value. If we want to include external signal to
%the ordinary differential equation, I resort it by using a global variable
%instead.
dummy = u(k);

%Computing the solution on the time interval [k*0.25 , (k+1)*0.25] of to the 
%continuous-time model using the piece-wise
%constant control input from the MPC as computed above. 
[t,y] = ode15s(@mycessna,0:0.01:0.25,x(:,k));

%The solution of the ODE is concatenated with the previous solution on the
%previous time interval
x_continuous_time = [x_continuous_time;y];
control_input = [control_input;u(k)*ones(size(y,1),1)];
total_time = [total_time;t+0.25*(k-1)];

%The continuous-time solution of the ODE at the end of the time interval 
%becomes the initial condition for the next sampling time
x(:,k+1) = y(end,:)';
end;

figure;
plot(total_time,x_continuous_time(:,2),'r-');
xlabel('time (s)'); ylabel('Pitch angle (rad)');
figure;
plot(total_time,x_continuous_time(:,4),'r-');
xlabel('time (s)'); ylabel('Altitude (m)');
figure;
plot(total_time,control_input, 'r-' );
xlabel('time (s)'); ylabel('Control input');
