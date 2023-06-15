clear; clc;
syms x1s us

a1 = -1.959;
a2 = 0.9604;
b1 = 0.002416;
b2 = 0.006379;

x2s = 0.2; % maximum of x2s = same as the optimal input constraint 

eq1 = -a2*x2s + b2*us == x1s;
eq2 = x1s -a1*x2s + b1*us == x2s;
sol = solve([eq1, eq2], [us, x1s]);
x1s_sol = double(sol.x1s);


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
% xf = 5;
% xf = 0.15;
x1 = x1s_sol;
x2 = x2s;
xf = [x1; x2];
T = 40;
%x0 = 2;
x0 = [0; 0];
sizex = size(x0,1);
Q = 0.001;
R = 0.001;
options = optimoptions('fmincon', 'Algorithm', 'interior-point', 'MaxFunctionEvaluations', 3e+6);
U_optimal = fmincon(@(U) costfunction_terminalcondition(U,x0,xf,T,Q,R),zeros(T+sizex*T*2,1),[],[],[],[],-0.3*ones(T+sizex*T*2,1),0.3*ones(T+sizex*T*2,1),[],options);

% Verify the U_optimal

% A = 0.9709; B = -0.07888;
A = [0 -0.9604; 1 1.959];
B = [0.006379; 0.002416];

clear x;
u = U_optimal(1:T);
x = zeros(sizex,T);

x(:,1) = x0;
for k = 1:T-1
    x(:,k+1) = A*x(:,k) + B*u(k);
end
figure(1)
plot(x(1,:))
figure(2)
plot(x(2,:))