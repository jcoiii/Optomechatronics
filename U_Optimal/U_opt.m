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
clear; clc;
%xf = 5;
xf = 0.15;
T = 15;
%x0 = 2;
x0 = 0;
sizex = size(x0,1);
Q = 0.01;
R = 0.01;
options = optimoptions('fmincon', 'Algorithm', 'interior-point', 'MaxFunctionEvaluations', 3e+6);
U_optimal = fmincon(@(U) costfunction_terminalcondition(U,x0,xf,T,Q,R),zeros(T+sizex*T*2,1),[],[],[],[],-0.25*ones(T+sizex*T*2,1),0.25*ones(T+sizex*T*2,1),[],options);

% Testing the U_optimal from the line above

A = 0.9709; B = -0.07888;
% A = [0 -0.9756;1 -1.9756];
% B = [0.01692;-0.01881];

clear x;
u = U_optimal(1:T);
x = zeros(sizex,T);

x(:,1) = x0;
for k = 1:T-1
    x(:,k+1) = A*x(:,k) + B*u(k);
end