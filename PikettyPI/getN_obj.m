function Out = getN_obj(N,Nvec,svec,yvec,fractile,topshare)

bvec = yvec./svec; % local Pareto coefficient
avec = bvec./(bvec - 1); % local Pareto exponent
pvec = Nvec/N; % fractile corresponding to given thresholds

Yvec = 0*topshare; % store theoretical total income
J = length(fractile);

for j = 1:J
    q = fractile(j);
    [~,i] = min(abs(pvec - q)); % find closest threshold
    p = pvec(i);
    Yvec(j) = yvec(i)*p^(1/avec(i))*q^(1/bvec(i));
end

temp1 = topshare/topshare(1);
temp2 = Yvec/Yvec(1);
Out = norm(log(temp2) - log(temp1)); % most natural

end

