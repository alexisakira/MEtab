%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fhat
% (c) 2021 Alexis Akira Toda
% 
% Purpose: 
%       Compute truncated exponential distribution, which is Equation (3.6)
%       in Proposition 1 of Lee et al. (2024)
%
% Usage:
%       Out = fhat(y,q,a,b,lambda)
%
% Inputs:
% y         - evaluation point (could be vector)
% q         - bin probability
% a         - lower endpoint of interval
% b         - upper endpoint of interval
% lambda    - Lagrange multiplier
%
% Outputs:
% Out       - function value
%
% Version 1.1: June 1, 2021
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Out = fhat(y,q,a,b,lambda)

if a >= b
    error('it must be a < b')
end

if lambda == 0
    % if lambda = 0, it is uniform
    Out = q/(b-a)*ones(size(y));
else % lambda ~= 0
    Out = q*lambda*exp(lambda*y)/(exp(lambda*b) - exp(lambda*a));
end

end