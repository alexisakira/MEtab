%% Simulation of Villasenor and Arnold (1989) to Compute Bias and RMSE

function out = sim_VA(N,pgrid,DGP)

% N = 10^5 ;
S = 1000 ; % simulation draws

% N = 1e7; % sample size
p0 = [0.001,0.01,0.05:0.05:1]; % true top fractile
K = length(p0);

% pgrid = [0.001,0.01,0.05,0.1:0.1:0.9]; % fractile to be evaluated at
topShare_VA = zeros(S,length(pgrid)) ;

%% DGP
if DGP == 1 % double Pareto

alpha = 2.3 ;
beta = 1.1 ;
M = (beta+1)*(alpha-1)/(alpha*beta); % make mean 1

% t = quantile(data,1-p); % empirical thresholds
t = dP_quantile(alpha,beta,M,1-p0) ; % population quantile with dP
ygrid = dP_quantile(alpha,beta,M,1-pgrid) ; 
topShare_True = dP_topShare(alpha,beta,M,ygrid) ; 

elseif DGP == 2 % lognormal

    sig = 1.5 ; mu = -sig^2/2 ;
    
    t = logninv(1-p0,mu,sig) ;
    ygrid = logninv(1-pgrid,mu,sig) ;
    topShare_True = normcdf((mu+sig^2-log(ygrid))/sig)./(1-normcdf((log(ygrid)-mu)/sig)).*pgrid ;

elseif DGP == 3 % Gamma 

    a = 1 ; b = 1 ; % Matlab definition of b is different from our paper

    t = gaminv(1-p0,a,b) ;
    ygrid = gaminv(1-pgrid,a,b) ;
    topShare_True = gammainc(ygrid,a+1,'upper') ;

elseif DGP == 4

    b = 1 ; % k in our Table 2, reduced to exponential dist.
    a = 1 ; % b in our Table 2, = Gamma(2)

    t = wblinv(1-p0,a,b) ;
    ygrid = gaminv(1-pgrid,a,b) ;
    topShare_True = (1+ygrid).*pgrid ; % based on exponential dist. E[X|X>x]=E[X]+x

end

parfor s = 1:S

rng(s)
    
if DGP == 1
   alpha = 2.3 ; beta = 1.1 ; M = (beta+1)*(alpha-1)/(alpha*beta);
   temp1 = exprnd(1/alpha,[N,1]);
   temp2 = exprnd(1/beta,[N,1]);
   data = M*exp(temp1-temp2);
elseif DGP == 2
    sig = 1.5 ; mu = -sig^2/2 ;
    data = lognrnd(mu,sig,[N,1]) ;
elseif DGP == 3
    a = 1 ; b = 1 ;
    data = gamrnd(a,b,[N,1]) ;
elseif DGP == 4
    a = 1 ; b = 1 ;
    data = wblrnd(a,b,[N,1]) ;
end

y = 0*t; % store group mean
y(1) = sum(data.*(data >= t(1)))/sum(data >= t(1));

for k = 2:K
    temp = (data >= t(k)).*(data < t(k-1));
    y(k) = sum(data.*temp)/sum(temp);
end

p = 0*t ; % sample top fractile
for k = 1:K
    p(k) = sum(data >= t(k))/N ;
end

%% estimate Lorenze curve using VA p.322
% everything ordered from lowest bin to highest
% x is cumulative proportions of income units
% y is cumulative proportions of income received

pVA = p'; 
pVA(2:end) = diff(p);
pVA = flipud(pVA) ; % cell probability
X = cumsum(pVA) ; % cumulative proportions of income units

yVA = flipud(y') ; % group average
QVA = sum(yVA.*pVA) ; % average income of all

Y = cumsum(yVA.*pVA)/QVA ; % cumulative proportions of income received

tVA = Y.*(1-Y) ;
uVA = X.^2-Y ;
vVA = Y.*(X-1) ;
wVA = X-Y ;
% reg = [uVA,vVA,wVA] ;
% 
% est = (reg'*reg)^(-1)*reg'*tVA ;
% aVA = est(1) ;
% bVA = est(2) ;
% dVA = est(3) ;


bVA = (vVA'*vVA)\vVA'*(tVA-uVA) ; % eq.(15) with restriction a=1,d=0
aVA = 1 ;
dVA = 0 ;
eVA = -(aVA+bVA+dVA+1) ;

%% calculate top income shares
xgrid = ygrid ; % find the bottom fractile
alphaVA = bVA^2 - 4*aVA ;
betaVA = 2*bVA*eVA - 4*dVA ;
KVA = (betaVA^2-4*alphaVA*eVA^2)^(1/2)/(2*alphaVA) ; 
den = @(x) (2*alphaVA*KVA/QVA)*((bVA+2*x/QVA).^2 - alphaVA).^(-3/2) ; % density eq.(7) 
% Typo in the paper, should be -3/2 as implied by eq.(9)
for i = 1:length(ygrid)
    xgrid(i) = integral(@(x) den(x),0,ygrid(i)) ; 
end

Lorenzo = (-(bVA*xgrid+eVA)-(alphaVA*xgrid.^2+betaVA*xgrid+eVA^2).^(1/2))/2 ; % eq.(6b)
topShare_VA(s,:) = 1 - Lorenzo ; % estimated top shares

end

bias = mean(topShare_VA./repmat(topShare_True,S,1)-1,1) ;
rmse = mean((topShare_VA./repmat(topShare_True,S,1)-1).^2,1).^(1/2) ;

out = [bias ; rmse] ;

end