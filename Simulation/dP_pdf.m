function Out = dP_pdf(x,alpha,beta,M)
% density function of double Pareto distribution

temp1 = alpha*beta/(alpha+beta)*M^(-beta)*x.^(beta-1).*(x<=M);
temp2 = alpha*beta/(alpha+beta)*M^alpha*x.^(-alpha-1).*(x>M);

Out = temp1 + temp2;

end

