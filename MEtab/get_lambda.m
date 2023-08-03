function [lambda,J] = get_lambda(y,a,b)
%% maximize J(lambda)

if (y <= a)||(y >= b)
    error('it must be a < y < b')
end

m = (a+b)/2; % midpoint

% cases that can be solved analytically
if b == Inf
    lambda = 1/(a-y);
    J = -1 - log(y-a);
    return
elseif y == m
    lambda = 0;
    J = -log(b-a);
    return
end

% assume b < Inf and y ~- m

s = 1/b; % scaling factor
options = optimset('TolFun',1e-10,'TolX',1e-10);

[lambda,fval] = fminsearch(@(x)(-Jlambda(x,s*y,s*a,s*b)),0,options);
lambda = s*lambda;
J = -fval + log(s);

end

