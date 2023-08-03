function Out = fhat(y,q,a,b,lambda)
%% exponential distribution on (a,b) with parameter lambda
% integrates to q

if a >= b
    error('it must be a < b')
end

if lambda == 0
    Out = q/(b-a)*ones(size(y));
else
    Out = q*lambda*exp(lambda*y)/(exp(lambda*b) - exp(lambda*a));
end

end

