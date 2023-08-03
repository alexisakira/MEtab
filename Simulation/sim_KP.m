%% Simulation of Kakwani and Podder (1976) to Compute Bias and RMSE

function out = sim_KP(N,pgrid,DGP)

% N = 10^5 ;
S = 1000 ; % simulation draws

% N = 1e7; % sample size
p0 = [0.001,0.01,0.05:0.05:1]; % true top fractile
K = length(p0);

% pgrid = [0.001,0.01,0.05,0.1:0.1:0.9]; % fractile to be evaluated at
topShare_KP = zeros(S,length(pgrid)) ;

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

%% estimate Lorenze curve using KP pp.142-143
% our 1-p is their p, our y is their x* 
% everything ordered from lowest bin to highest
% our K-1 is their T

T = K-1 ;
fKP = p; 
fKP(2:end) = diff(p);
fKP = flipud(fKP') ; % cell probability
xstarKP = flipud(y') ; % group average
QKP = sum(xstarKP.*fKP) ; % average income of all

fKP = fKP(1:end-1) ; % KP uses only T = K-1 bins in regression
pKP = cumsum(fKP) ; % bottom fractile
xstarKP = xstarKP(1:end-1) ;

qKP = cumsum(xstarKP.*fKP)/QKP ;

rKP = (pKP+qKP)/sqrt(2) ;
yKP = (pKP-qKP)/sqrt(2) ;

Y1 = log(yKP) ;
X1 = [ones(T,1),log(rKP),log(sqrt(2)-rKP)] ;
xKP = Y1 ;
for i = 1:T
    xKP(i) = t(K-i) ;   
end
Y2 = (QKP-xKP)./(QKP+xKP).*rKP.*(sqrt(2)-rKP)./yKP ;    
X2 = [zeros(T,1),sqrt(2)-rKP,-rKP] ;

Y = [Y1;Y2] ;
X = [X1;X2] ;
d3 = (X'*X)\X'*Y ; % OLS, their method III

aKP = exp(d3(1)) ;
alphaKP = d3(2) ;
betaKP = d3(3) ;
%% calculate top income shares
topShare = ygrid ;
for i = 1:length(ygrid)
    x = ygrid(i) ; 
    options = optimoptions('lsqnonlin','Display','off') ;
    pix = lsqnonlin(@(z) (alphaKP*aKP*z.^(alphaKP-1).*(sqrt(2)-z).^betaKP ...
             - betaKP*aKP*z.^alphaKP.*(sqrt(2)-z).^(betaKP-1)-(QKP-x)/(QKP+x)),0.5,0,sqrt(2),options) ; % eq(5.1)
    eta = aKP*pix^alphaKP*(sqrt(2)-pix)^betaKP ; % eq.(2.7)
    qx = (pix-eta)*sqrt(2)/2 ; % Lorenzo curve, combining eq.(2.2) and (4.1)
    topShare(i) = 1-qx ;
end
topShare_KP(s,:) = topShare ; % estimated top shares
end

bias = mean(topShare_KP./repmat(topShare_True,S,1)-1,1) ;
rmse = mean((topShare_KP./repmat(topShare_True,S,1)-1).^2,1).^(1/2) ;

out = [bias ; rmse] ;

end