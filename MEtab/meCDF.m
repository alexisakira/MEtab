%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% meCDF
% (c) 2022 Alexis Akira Toda
% 
% Purpose: 
%       Compute CDF of maximum entropy density (piecewise exponential),
%       which is based on Section 3.3 of Lee et al. (2024)
%
% Usage:
%       pdf = meCDF(x,p,t,lambda)
%
% Inputs:
% x         - evaluation point (could be vector)
% p         - vector of tail probabilities
% t         - vector of thresholds
% lambda    - vector of Lagrange multipliers
%
% Outputs:
% cdf       - cumulative distribution function
%
% Version 1.1: March 30, 2022
%
% Version 1.2: July 12, 2024
% - Added p in error checking
% - Fixed bug when last entry of p is less than 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cdf = meCDF(x,p,t,lambda)

K = length(t); % number of bins

% some error checking
if length(lambda) ~= K
    error('lambda must have same length as t');
end
if any(diff(p) < 0)
    error('p must be increasing')
end
if any(diff(t) >= 0)
    error('t must be strictly decreasing')
end

q = p; % initialize bin probabilities
q(2:end) = diff(p);

% k = 1
cdf = q(1)*(x >= t(1)).*(1-exp(lambda(1)*(x-t(1))));
% k >= 2
for k=2:K
    lamk = lambda(k);
    if lamk == 0
        temp = (min(x,t(k-1)) - t(k))/(t(k-1) - t(k));
    else
        temp = (exp(lamk*min(x,t(k-1))) - exp(lamk*t(k)))/(exp(lamk*t(k-1)) - exp(lamk*t(k)));
    end
    cdf = cdf + q(k)*(x >= t(k)).*temp;
end
cdf = cdf + (1-p(end)); % adjust cdf so that F(infty) = 1

end

