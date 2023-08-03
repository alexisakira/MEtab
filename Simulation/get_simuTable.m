%% Get Simulation Tables of Different Methods to Compare Bias and RMSE

clear ;
close all ;
clc ;

DGP = 4 ; % distribution, dPareto=1, Lognormal=2, Gamma=3, Weibull/exponential=4

Ngrid = [10^4,10^5,10^6]' ;
pgrid = [0.001,0.01,0.05,0.1:0.1:0.9]; % fractile to be evaluated at

bias_ME = zeros(length(Ngrid),length(pgrid)) ;
rmse_ME = zeros(length(Ngrid),length(pgrid)) ;
bias_KP = zeros(length(Ngrid),length(pgrid)) ;
rmse_KP = zeros(length(Ngrid),length(pgrid)) ;
bias_VA = zeros(length(Ngrid),length(pgrid)) ;
rmse_VA = zeros(length(Ngrid),length(pgrid)) ;
bias_HG = zeros(length(Ngrid),length(pgrid)) ;
rmse_HG = zeros(length(Ngrid),length(pgrid)) ;


for i = 1:length(Ngrid)
   
    temp = sim_ME(Ngrid(i),pgrid,DGP) ;
    bias_ME(i,:) = temp(1,:) ;
    rmse_ME(i,:) = temp(2,:) ;
    
    temp = sim_KP(Ngrid(i),pgrid,DGP) ;
    bias_KP(i,:) = temp(1,:) ;
    rmse_KP(i,:) = temp(2,:) ;
  
    temp = sim_VA(Ngrid(i),pgrid,DGP) ;
    bias_VA(i,:) = temp(1,:) ;
    rmse_VA(i,:) = temp(2,:) ;
   
    temp = sim_HG(Ngrid(i),pgrid,DGP) ;
    bias_HG(i,:) = temp(1,:) ;
    rmse_HG(i,:) = temp(2,:) ;
     
end

tab_bias = [0 pgrid ; Ngrid, bias_ME ; Ngrid, bias_KP ; Ngrid, bias_VA ; Ngrid, bias_HG] ;
tab_rmse = [0 pgrid ; Ngrid, rmse_ME ; Ngrid, rmse_KP ; Ngrid, rmse_VA ; Ngrid, rmse_HG] ;