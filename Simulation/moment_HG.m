function out = moment_HG(theta,cHG,yHG,zHG)
% the moment function in HG, eq.(8)
% theta  = (1/a,1/b,p,q) , unknown parameters in GB2
% u = (yb)^(1/a)/(1+(yb)^(1/a)) ; 
% F(y) = betainc(u,p,q), F1(y) = betainc(u,p+a,q-a)
% mu = b*.beta(p+a,q-a)/beta(p,q) ;
% cHG_i matches F(z_i) - F(z_{i-1}) and yHG_i matches mu*(F1(z_i)-F1(z_{i-1}))

F = @(y,th)  betainc(1-1./(1+(y.*th(2)).^(1./th(1))),th(3),th(4)) ;
mu = @(th) 1./th(2).*beta(th(3)+th(1),th(4)-th(1))./beta(th(3),th(4)) ;
F1 = @(y,th) betainc(1-1./(1+(y.*th(2)).^(1./th(1))),th(3)+th(1),th(4)-th(1)) ;

w = [1./cHG(1:end-1);1./yHG] ; % diagonal weight for GMM
K = length(cHG) ;
H = zeros(2*K-1,1) ;

H(1) = (cHG(1) - F(zHG(1),theta))*w(1) ; 
for i = 2:K-1      
   H(i) = ( cHG(i)-(F(zHG(i),theta)-F(zHG(i-1),theta)) ).*w(i) ;
end
H(K) = (yHG(1)-mu(theta).*F1(zHG(1),theta))*w(K) ;
for i = K+1:length(H)
   H(i) = ( yHG(i-K+1)-mu(theta).*(F1(zHG(i-K+1),theta)-F1(zHG(i-K),theta)) ).*w(i) ;
end

out = H'*H ;
end