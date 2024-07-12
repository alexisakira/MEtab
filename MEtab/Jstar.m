%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jstar
% (c) 2021 Alexis Akira Toda
% 
% Purpose: 
%       Compute minimized Kullback-Leibler divergence in maximum entropy
%       density estimation, which is Equation (3.7) of Lee et al. (2024)
%
% Usage:
%       [fval,grad] = Jstar(q,y,t,scale)
%
% Inputs:
% q         - vector of bin probabilities
% y         - vector of group mean on intervals
% t         - vector of thresholds
%
% Optional:
% scale     - using 'log' transforms variable in log scale; using
% 'normlize' transforms variable into [0,1]
%
% Outputs:
% fval      - function value
% grad      - gradient
%
% Version 1.1: June 2, 2021
%
% Version 1.2: July 12, 2024
% - Changed name of function
% - Added t in error checking
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fval,grad] = Jstar(q,y,t,scale)

if nargin < 4
    scale = []; % default is no scaling
end

% some error checking
K = length(q);
if length(y) ~= K
    error('y must have same length as q')
end
if length(t) ~= K
    error('t must have same length as q')
end
if any(diff(y) >= 0)
    error('y must be strictly decreasing')
end
if any(diff(t) >= 0)
    error('t must be strictly decreasing')
end

% initialization
lambda = 0*q;
J = 0*q;

% k = 1
[lambda1,J1] = get_lambda(y(1),t(1),Inf);
lambda(1) = lambda1;
J(1) = J1;

% k >= 2
for k=2:K
    [lambdak,Jk] = get_lambda(y(k),t(k),t(k-1));
    lambda(k) = lambdak;
    J(k) = Jk;
end

% function value using Equation (3.7)
fval = dot(q,J + log(q));

% compute gradient using Equation (B.23a)
grad = 0*t;
grad(end) = [];
for k = 1:K-1
    if k == 1
        b = Inf;
    else
        b = t(k-1);
    end
    tk = t(k);
    grad(k) = fhat(tk,q(k),tk,b,lambda(k)) - fhat(tk,q(k+1),t(k+1),tk,lambda(k+1));
end

if strcmp(scale,'log')
    grad = grad.*t(1:end-1);
elseif strcmp(scale,'normalize')
    grad = grad.*(y(1:end-1) - y(2:end));
end