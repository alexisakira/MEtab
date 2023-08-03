function [fval,grad] = Jlambda(lambda,y,a,b)
%% compute J(lambda) and its derivative
% a, b: endpoints of interval
% y: mean

if a >= b
    error('it must be a < b')
end

if lambda == 0
    fval = -log(b-a);
    grad = y - (a+b)/2;
    return
end

% assume lambda ~= 0

ea = exp(lambda*a);
eb = exp(lambda*b);

fval = y*lambda - log((eb - ea)/lambda);
grad = y - (b*eb - a*ea)/(eb - ea) + 1/lambda;

end

