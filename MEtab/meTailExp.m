%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% meCDF
% (c) 2022 Alexis Akira Toda
% 
% Purpose: 
%       Compute tail expectations of maximum entropy density (piecewise
%       exponential), which is based on Section 3.3 of Lee et al. (2024)
%
% Usage:
%       TE = meTailExp(x,p,t,lambda)
%
% Inputs:
% x         - evaluation point (could be vector)
% p         - vector of tail probabilities
% t         - vector of thresholds
% lambda    - vector of Lagrange multipliers
%
% Outputs:
% TE        - tail expectations
%
% Version 1.1: August 2, 2022
%
% Version 1.2: July 12, 2024
% - Added p in error checking
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function TE = meTailExp(x,p,t,lambda)

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

xx = max(x,t(1));
TE = q(1)*(xx - 1/lambda(1)).*exp(lambda(1)*(xx - t(1)));
for k=2:K
    lamk = lambda(k);
    a = t(k);
    b = t(k-1);
    xx = max(x,a);
    if lamk == 0
        temp = (1/2)*(b^2-xx.^2)/(b-a);
    else
        temp = ((b-1/lamk)*exp(lamk*b) - (xx-1/lamk).*exp(lamk*xx.*(x < b)))/(exp(lamk*b) - exp(lamk*a));
    end
    TE = TE + q(k)*(x < b).*temp;
end

end

