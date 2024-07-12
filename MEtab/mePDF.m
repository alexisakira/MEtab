%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mePDF
% (c) 2022 Alexis Akira Toda
% 
% Purpose: 
%       Compute maximum entropy density (piecewise exponential), which is
%       Equation (3.6) in Proposition 1 of Lee et al. (2024)
%
% Usage:
%       pdf = mePDF(x,p,t,lambda)
%
% Inputs:
% x         - evaluation point (could be vector)
% p         - vector of tail probabilities
% t         - vector of thresholds
% lambda    - vector of Lagrange multipliers
%
% Outputs:
% pdf       - probability density function
%
% Version 1.2: August 2, 2023
%
% Version 1.3: July 12, 2024
% - Added p in error checking
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pdf = mePDF(x,p,t,lambda)

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

pdf = 0*x; % initialize pdf
% k = 1
ind = (x >= t(1));
pdf(ind) = fhat(x(ind),q(1),t(1),Inf,lambda(1));
% k >= 2
for k = 2:K
    ind = (x >= t(k))&(x < t(k-1));
    pdf(ind) = fhat(x(ind),q(k),t(k),t(k-1),lambda(k));
end

end