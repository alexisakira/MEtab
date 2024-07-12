%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jlambda
% (c) 2021 Alexis Akira Toda
% 
% Purpose: 
%       Compute objective function in maximum entropy density estimation,
%       which is Equation (3.4) in Proposition 1 of Lee et al. (2024)
%
% Usage:
%       [fval,grad] = Jlambda(lambda,y,a,b)
%
% Inputs:
% lambda    - Lagrange multiplier
% y         - group mean on interval
% a         - lower endpoint of interval
% b         - upper endpoint of interval
%
% Outputs:
% fval      - function value
% grad      - derivative
%
% Version 1.1: June 1, 2021
% 
% Version 1.2: July 12, 2024
% - Changed error checking
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fval,grad] = Jlambda(lambda,y,a,b)

% some error checking
if (y <= a)||(y >= b)
    error('it must be a < y < b')
end

% assume lambda = 0
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