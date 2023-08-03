function meObj = MEtab(p,y,t)
%% estimate maximum entropy density from tabulation
% p:        vector of top fractile
% y:        vector of group mean
% t:        thresholds

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
if any(diff(t) >= 0)
    error('t must be strictly decreasing')
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

q = p; % cell probability
q(2:end) = diff(p);

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

end

