%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_lambda
% (c) 2021 Alexis Akira Toda
% 
% Purpose: 
%       Maximize objective function in maximum entropy density estimation,
%       which is Equation (3.4) in Proposition 1 of Lee et al. (2024)
%
% Usage:
%       [lambda,J] = get_lambda(y,a,b)
%
% Inputs:
% y         - group mean on interval
% a         - lower endpoint of interval
% b         - upper endpoint of interval
%
% Outputs:
% lambda    - Lagrange multiplier
% J         - maximum value
%
% Version 1.1: June 1, 2021
%
% Version 1.2: July 12, 2024
% - Changed scaling factor
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [lambda,J] = get_lambda(y,a,b)

% some error checking
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

% assume b < Inf and y ~= m

% define scaling factor for numerical stability; see Appendix C of paper
s = 2/(abs(a)+abs(b));
options = optimset('TolFun',1e-10,'TolX',1e-10);

[lambda,fval] = fminsearch(@(x)(-Jlambda(x,s*y,s*a,s*b)),0,options);
lambda = s*lambda; % Lagrange multiplier
J = -fval + log(s); % maximum value

end