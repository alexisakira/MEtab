%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MEtab
% (c) 2022 Alexis Akira Toda
% 
% Purpose: 
%       Estimate maximum entropy density from tabulation
%
% Usage:
%       meObj = MEtab(p,y,t,scale)
%
% Inputs:
% p         - vector of tail probabilities
% y         - vector of group mean on intervals
% t         - vector of thresholds
%
% Optional:
% scale     - using 'log' transforms variable in log scale; using
% 'normlize' transforms variable into [0,1]
%
% Outputs:
% meObj     - maximum entropy object
%
% Version 1.1: March 31, 2022
%
% Version 1.2: July 12, 2024
% - Combined original and smoothed versions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function meObj = MEtab(p,y,t,scale)

% some error checking
K = length(p);
if length(y) ~= K
    error('y must have same length as p')
end
if any(diff(p) <= 0)
    error('p must be strictly increasing')
end
if any(diff(y) >= 0)
    error('y must be strictly decreasing')
end
if t(end) >= y(end)
    error('it must be t(end) < y(end)')
end

if size(p,1) > size(p,2)
    p = p'; % convert to row vector
end
if size(y,1) > size(y,2)
    y = y'; % convert to row vector
end
if size(t,1) > size(t,2)
    t = t'; % convert to row vector
end

q = p; % initialize bin probability
q(2:end) = diff(p);

%% Calculate t if using smoothed version
if nargin == 4 % smoothed version (Theorem 2 in paper)

    tmin = t(end); % define lower bound
    options = optimoptions('fmincon','Algorithm','trust-region-reflective',...
    'TolFun',1e-8,'TolX',1e-8','SpecifyObjectiveGradient',true,'Display','iter');

    if isempty(scale) % original scale
        lb = y(2:end); % lower bound for thresholds
        ub = y(1:end-1); % upper bound for thresholds
        t0 = (lb + ub)/2; % initial guess
    
        t = fmincon(@(t)Jstar(q,y,[t,tmin]),t0,[],[],[],[],lb,ub,[],options); % solve for optimal threshold
        t = [t,tmin];
    elseif strcmp(scale,'log') % log scale
        if y(end) <= 0
            error('y needs to be positive vector')
        end
        lb = log(y(2:end));
        ub = log(y(1:end-1));
        x0 = (lb + ub)/2;
    
        x = fmincon(@(x)Jstar(q,y,[exp(x),tmin],'log'),x0,[],[],[],[],lb,ub,[],options);
        t = [exp(x),tmin];
    elseif strcmp(scale,'normalize') % normalized scale
        yub = y(1:end-1);
        ylb = y(2:end);
        lb = zeros(size(ylb)) + 1e-6;
        ub = ones(size(yub)) - 1e-6;
        x0 = (lb + ub)/2;
    
        x = fmincon(@(x)Jstar(q,y,[ylb + (yub-ylb).*x,tmin],'normalize'),x0,[],[],[],[],lb,ub,[],options);
        t = [ylb + (yub-ylb).*x,tmin];
    end
end

%% remaining calculation is same for original and smoothed version

if length(t) ~= K
    error('t must have same length as p')
end
if any(diff(t) >= 0)
    error('t must be strictly decreasing')
end

lambda = 0*q; % Lagrange multiplier
J = 0*q; % store maximum values of dual problems

% solve dual problem for optimal threshold
[lambda1,J1] = get_lambda(y(1),t(1),Inf);
lambda(1) = lambda1;
J(1) = J1;

for k=2:K
    [lambdak,Jk] = get_lambda(y(k),t(k),t(k-1));
    lambda(k) = lambdak;
    J(k) = Jk;
end

% define outputs
meObj.p = p;
meObj.q = q;
meObj.t = t;
meObj.lambda = lambda;
meObj.Jmin = dot(q,J + log(q));
meObj.f = @(x)mePDF(x,p,t,lambda);
meObj.F = @(x)meCDF(x,p,t,lambda);
meObj.TE = @(x)meTailExp(x,p,t,lambda);

end

