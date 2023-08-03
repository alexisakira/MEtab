function pdf = mePDF(x,p,t,lambda)
%% compute maximum entropy density (piecewise exponential)

K = length(t);
if length(lambda) ~= K
    error('lambda must have same length as t');
end
if any(diff(t) >= 0)
    error('t must be strictly decreasing')
end

q = p; % cell probability
q(2:end) = diff(p);

pdf = 0*x;
ind = (x >= t(1));
pdf(ind) = fhat(x(ind),q(1),t(1),Inf,lambda(1));
for k = 2:K
    ind = (x >= t(k))&(x < t(k-1));
    pdf(ind) = fhat(x(ind),q(k),t(k),t(k-1),lambda(k));
end

end

