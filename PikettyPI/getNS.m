function [N,S,topshare_rep] = getNS(Nvec,tvec,Svec,fractile,topshare,f_out)

%% compute population size
yvec = Svec./Nvec; % vector of average income above threshold

options = optimset('Display','off','TolX',1e-6);

%func = @(x)(getN_obj(exp(x),Nvec,tvec,yvec,fractile,topshare));
%x = fminbnd(func,log(Nvec(1)),log(10*Nvec(1)),options);
%N = exp(x);
func = @(x)(getN_obj(Nvec(1)*exp(x),Nvec,tvec,yvec,fractile,topshare));
x = fminbnd(func,0,2,options);
N = Nvec(1)*exp(x);
%{
func = @(x)(getN_obj(Nvec(1)*exp(x),Nvec,tvec,yvec,fractile,topshare));
xlb = 0;
xub = 3;
ngrid = 100;
xgrid = linspace(xlb,xub,ngrid);
fgrid = 0*xgrid;
for n = 1:ngrid
    fgrid(n) = func(xgrid(n));
end
[~,n] = min(fgrid);
%x = fminbnd(func,0,3);
x = fminsearch(func,xgrid(n));
N = Nvec(1)*exp(x);
%}

bvec = yvec./tvec; % local Pareto coefficient
avec = bvec./(bvec - 1); % local Pareto exponent
pvec = Nvec/N; % fractile corresponding to given thresholds

%% compute top income shares for given fractiles

if nargin < 6
    f_out = fractile;
end
J = length(f_out);
Yvec = zeros(1,J); % store theoretical total income

for j = 1:J
    q = f_out(j);
    [~,i] = min(abs(pvec - q)); % find closest threshold
    p = pvec(i);
    Yvec(j) = N*yvec(i)*p^(1/avec(i))*q^(1/bvec(i));
end

q = fractile(1);
[~,k] = min(abs(pvec - q)); % find closest threshold to top 10%
p = pvec(k);
Yk = N*yvec(k)*p^(1/avec(k))*q^(1/bvec(k));
S = Yk/topshare(1);

%topshare_rep = topshare(1)*Yvec/Yvec(1);
topshare_rep = Yvec/S;

end

