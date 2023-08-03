%% Simulation of the HGBRC method to Compute Bias and RMSE

function out = sim_HG(N,pgrid,DGP)

% N = 10^5 ;
S = 1000 ; % simulation draws

% N = 1e7; % sample size
p0 = [0.001,0.01,0.05:0.05:1]; % true top fractile
K = length(p0);

% pgrid = [0.001,0.01,0.05,0.1:0.1:0.9]; % fractile to be evaluated at
topShare_ME = zeros(S,length(pgrid)) ;

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

cHG = p';
cHG(2:end) = diff(p);
cHG = flipud(cHG) ; % cell probability
yHG = flipud(y') ; % group average
yHG = yHG.*cHG ; % group average times cell prob, \tilde{y} in HG

zHG = yHG ; % bin upper bound, ordered ascendingly in HG
for i = 1:K-1
    zHG(i) = t(K-i) ;   
end
zHG(end) = 99 ; % z(K) = inf ; z(0) = 0 ;

%% GMM matching the sample moment (cHG and yHG) with model-based moment

th0 = [0.5,1,1,2]' ; % initial search value
A = [1,0,0,-1] ;
b = 0 ; % constraint that th(4)-th(1)>0
lb = 0.01*[1;1;1;1] ;
ub = 1000*[1;1;1;1] ;
options = optimoptions('fmincon','Display','off');
th_gmm = fmincon(@(th) moment_HG(th,cHG,yHG,zHG),th0,A,b,[],[],lb,ub,[],options) ;

%% calculate top income shares
F1 = @(y,th) betainc(1-1./(1+(y.*th(2)).^(1./th(1))),th(3)+th(1),th(4)-th(1)) ;
topShare = ygrid ;
for i = 1:length(ygrid)
    topShare(i) = 1-F1(ygrid(i),th_gmm) ;
end

topShare_ME(s,:) = topShare ; % estimated top shares

end

bias = mean(topShare_ME./repmat(topShare_True,S,1)-1,1) ;
rmse = mean((topShare_ME./repmat(topShare_True,S,1)-1).^2,1).^(1/2) ;

out = [bias ; rmse] ;

end