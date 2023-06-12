function output = costfunction_N(input,x0,N)

U = zeros(N,1);
for k = 1:N
    U(k) = input(k);
end;
%U = [input(1);input(2);input(3)];
A = 2; B = 1; Q = 1; P = 0.5; R = 0.5;

S_of_x = 1;
for k = 1:N-1
    S_of_x = [S_of_x;A^k;];
end;

Observability = B;
for k = 1:N-1
    Observability = [A^k*B Observability];
end;
S_of_u = zeros(N,N);
for k = 1:N-1
    S_of_u(k+1,1:k) = Observability(end-k+1:end);
end;

%S_of_u = [0 0 0;B 0 0;A*B B 0];

Q_bar = eye(N,N)*Q;
Q_bar(N,N) = P;
%Q_bar = [Q 0 0;0 Q 0;0 0 P];
R_bar = eye(N,N)*R;
%R_bar = [R 0 0;0 R 0;0 0 R];

H = S_of_u' * Q_bar * S_of_u + R_bar;
F = S_of_x' * Q_bar * S_of_u;
J =  U'*H*U + 2*x0'*F*U + x0' * S_of_x' * Q_bar * S_of_x * x0;

output = J;