function output = costfunction_terminalcondition(input,x0,xf,T,Q,R)

% Here we will extract three different important variable from the
% optimization variable "input". In the "input" variable, it contains the
% computation of optimal input, of optimal lambda and of optimal state. We
% will call these, in the following, by the variable u_star, lambda_star
% and x_star.

u_star = zeros(T,1);
for k = 1:T
    u_star(k) = input(k);
%    xstar(k) = input(k+2*T);
end;
sizex = size(xf,1);

lambda_star = input(T+1:sizex*T+T);

x_star = input(sizex*T+T+1:end);

% Based on the lambda_star and x_star which is now still a tall vector that 
% combines all time points, we rearrange them according to the
% dimension of lambda_star and x_star per time point k by using the
% variables X_star and Lambda_star (with capital letter at the start)

X_star = zeros(sizex,T);
Lambda_star = zeros(sizex,T);

for k = 1:T
    X_star(:,k) = x_star(sizex*(k-1)+1:sizex*k);
    Lambda_star(:,k) = lambda_star(sizex*(k-1)+1:sizex*k);
end;

% Here, we define our systems' state, initial condition, terminal
% condition, matrices for the cost function, etc. I use two different
% systems setup here, one for one-dimensional state equation and the other
% one is a two-dimensional state equation. I put commented lines, if I want
% to disable one of the two setups. 

%Terminal state x(T) = xf;
%initial state x(1) = x0;

% A = 0.9709; B = -0.07888;
A = [0 -0.9604; 1 1.959];
B = [0.006379; 0.002416];

% Recall from the Pontryagin minimum principle that we need to define
% Hamiltonian function. In the following, we will recall few of these basic
% facts / concepts

% Hamiltonian H(x(k),u(k)) = x(k)'Qx(k) + u(k)'Ru(k) + lambda(k+1)'(Ax(k)+Bu(k))
% where lambda(k) is a column vector with the same dimension as the state
% vector and the symbol lambda' means the transpose of lambda. 
% It can be computed that
% dH/du = 2*R*u(k) + lambda(k+1)'*B
% dH/dx = 2*Q*x(k) + A'*lambda(k+1)

% Pontryagin principle asks that
% X_star(k+1) = A*X_star(k) + B*u_star(k) 
% Lambda_star(k) = dH/dx = 2*Q*X_star(k) + A'*Lambda_star(k+1)
% dH/du = 2*R*u_star(k) + Lambda_star(k+1)'*B = 0

% or equivalently, 
% X_star(k+1) - A*X_star(k) - B*u_star(k) = 0
% Lambda_star'(k) - 2*Q*X_star(k) - A'*Lambda_star(k+1) = 0
% 2*R*u_star(k) + Lambda_star(k+1)'*B = 0

X = zeros(sizex,T);
X(:,1) = x0;
c1 = zeros(sizex,T);

for k = 1:T-1
    X(:,k+1) = A*X(:,k) + B*u_star(k);
    c1(:,k) = X_star(:,k+1) - A*X(:,k) - B*u_star(k);
end;
c1(:,k+1) = xf - A*X(:,k) - B*u_star(k);

c2 = zeros(sizex,T);
lambda = zeros(sizex,T);
lambda(:,T) = -2*inv(B'*B)*B'*R*u_star(k-1);

for k = T:-1:2
    lambda(:,k-1) = 2*Q*X_star(:,k) + A'*lambda(:,k);
    c2(:,k) = Lambda_star(:,k-1) - 2*Q*X_star(:,k) - A'*lambda(:,k);
end;

J = sum(c2.*c2,'all')+sum(c1.*c1,'all');

output = J;