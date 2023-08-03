function TE = meTailExp(x,p,t,lambda)
%% compute tail expectation of maximum entropy density (piecewise exponential)

K = length(t);
if length(lambda) ~= K
    error('lambda must have same length as t');
end
if any(diff(t) >= 0)
    error('t must be strictly decreasing')
end

q = p; % cell probability
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
        %temp = ((b-1/lamk)*exp(lamk*b) - (xx-1/lamk).*exp(lamk*xx))/(exp(lamk*b) - exp(lamk*a));
        temp = ((b-1/lamk)*exp(lamk*b) - (xx-1/lamk).*exp(lamk*xx.*(x < b)))/(exp(lamk*b) - exp(lamk*a));
    end
    TE = TE + q(k)*(x < b).*temp;
end

end

