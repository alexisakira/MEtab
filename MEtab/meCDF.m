function cdf = meCDF(x,p,t,lambda)
%% compute CDF of maximum entropy density (piecewise exponential)

K = length(t);
if length(lambda) ~= K
    error('lambda must have same length as t');
end
if any(diff(t) >= 0)
    error('t must be strictly decreasing')
end

q = p; % cell probability
q(2:end) = diff(p);

cdf = q(1)*(x >= t(1)).*(1-exp(lambda(1)*(x-t(1))));
for k=2:K
    lamk = lambda(k);
    if lamk == 0
        temp = (min(x,t(k-1)) - t(k))/(t(k-1) - t(k));
    else
        temp = (exp(lamk*min(x,t(k-1))) - exp(lamk*t(k)))/(exp(lamk*t(k-1)) - exp(lamk*t(k)));
    end
    cdf = cdf + q(k)*(x >= t(k)).*temp;
end

end

