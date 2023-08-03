%% Simulation

clear
close all
clc;

%% figure formatting

set(0,'DefaultTextInterpreter','latex')
set(0,'DefaultAxesTickLabelInterpreter','latex');
set(0,'DefaultLegendInterpreter', 'latex')
   
set(0,'DefaultTextFontSize', 14)
set(0,'DefaultAxesFontSize', 14)
set(0,'DefaultLineLineWidth',2)

temp = get(gca,'ColorOrder');
c1 = temp(1,:);
c2 = temp(2,:);
c3 = temp(3,:);

close all

N = 1e7; % sample size
p = [0.001,0.005,0.01,0.05:0.05:0.95,0.99,0.995,0.999,1]; % top fractile
K = length(p);
ygrid = 10.^linspace(-4,4,1000);

%% lognormal

sigma = 1.5;
mu = -sigma^2/2; % make mean 1
rng(1);
data = exp(normrnd(mu,sigma,[N,1])); % simulated data
t = quantile(data,1-p); % thresholds
y = 0*t; % store group mean
y(1) = sum(data.*(data >= t(1)))/sum(data >= t(1));

for k = 2:K
    temp = (data >= t(k)).*(data < t(k-1));
    y(k) = sum(data.*temp)/sum(temp);
end

meObj_lN = MEtab(p,y,t);

pdf0_lN = normpdf(log(ygrid),mu,sigma); % true density
pdf_lN = meObj_lN.f(ygrid);

figure
semilogx(ygrid,pdf0_lN,'--k','LineWidth',1); hold on
semilogx(ygrid,pdf_lN.*ygrid,'-','Color',c1);
semilogx(t,meObj_lN.f(t).*t,'o','Color',c1);
xlabel('$y$')
ylabel('PDF of $\log Y$')
xlim([1e-4,1e2])
legend('Population','Estimate','Thresholds','Location','NW')
title('Lognormal')

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig_sim_lN','-dpdf')

%% gamma

a = 0.5;
theta = a; % make mean 1
rng(1);
data = gamrnd(a,1/theta,[N,1]);

t = quantile(data,1-p); % thresholds
y = 0*t; % store group mean
y(1) = sum(data.*(data >= t(1)))/sum(data >= t(1));

for k = 2:K
    temp = (data >= t(k)).*(data < t(k-1));
    y(k) = sum(data.*temp)/sum(temp);
end

meObj_gam = MEtab(p,y,t);

pdf0_gam = gampdf(ygrid,a,1/theta); % true density
pdf_gam = meObj_gam.f(ygrid);

figure
semilogx(ygrid,pdf0_gam.*ygrid,'--k','LineWidth',1); hold on
semilogx(ygrid,pdf_gam.*ygrid,'-','Color',c1);
semilogx(t,meObj_gam.f(t).*t,'o','Color',c1);
xlabel('$y$')
ylabel('PDF of $\log Y$')
xlim([1e-4,1e2])
legend('Population','Estimate','Thresholds','Location','NW')
title('Gamma')

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig_sim_Gamma','-dpdf')

%% Weibull

b = 0.7; % shape parameter
a = 1/gamma(1+1/b); % scale parameter
rng(1)
data = wblrnd(a,b,[N,1]);

t = quantile(data,1-p); % thresholds
y = 0*t; % store group mean
y(1) = sum(data.*(data >= t(1)))/sum(data >= t(1));

for k = 2:K
    temp = (data >= t(k)).*(data < t(k-1));
    y(k) = sum(data.*temp)/sum(temp);
end

meObj_wbl = MEtab(p,y,t);

pdf0_wbl = wblpdf(ygrid,a,b); % true density
pdf_wbl = meObj_wbl.f(ygrid);

figure
semilogx(ygrid,pdf0_wbl.*ygrid,'--k','LineWidth',1); hold on
semilogx(ygrid,pdf_wbl.*ygrid,'-','Color',c1);
semilogx(t,meObj_wbl.f(t).*t,'o','Color',c1);
xlabel('$y$')
ylabel('PDF of $\log Y$')
xlim([1e-4,1e2])
legend('Population','Estimate','Thresholds','Location','NW')
title('Weibull')

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig_sim_Weibull','-dpdf')

%% double Pareto

alpha = 1.5;
beta = 0.5;
M = (beta+1)*(alpha-1)/(alpha*beta); % make mean 1
rng(1)
temp1 = exprnd(1/alpha,[N,1]);
rng(2)
temp2 = exprnd(1/beta,[N,1]);
data = M*exp(temp1-temp2);

t = quantile(data,1-p); % thresholds
y = 0*t; % store group mean
y(1) = sum(data.*(data >= t(1)))/sum(data >= t(1));

for k = 2:K
    temp = (data >= t(k)).*(data < t(k-1));
    y(k) = sum(data.*temp)/sum(temp);
end

meObj_dP = MEtab(p,y,t);

pdf0_dP = dP_pdf(ygrid,alpha,beta,M); % true density
pdf_dP = meObj_dP.f(ygrid);

figure
semilogx(ygrid,pdf0_dP.*ygrid,'--k','LineWidth',1); hold on
semilogx(ygrid,pdf_dP.*ygrid,'-','Color',c1);
semilogx(t,meObj_dP.f(t).*t,'o','Color',c1);
xlabel('$y$')
ylabel('PDF of $\log Y$')
xlim([1e-4,1e2])
legend('Population','Estimate','Thresholds','Location','NW')
title('Double Pareto')

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig_sim_dP','-dpdf')

%% combine all figures in one

f = figure;

subplot(2,2,1);
semilogx(ygrid,pdf0_lN,'--k','LineWidth',1); hold on
semilogx(ygrid,pdf_lN.*ygrid,'-','Color',c1);
semilogx(t,meObj_lN.f(t).*t,'o','Color',c1);
%xlabel('$y$')
ylabel('PDF of $\log Y$')
xlim([1e-4,1e2])
legend('Population','Estimate','Thresholds','Location','NW')
title('Lognormal')

subplot(2,2,2);
semilogx(ygrid,pdf0_gam.*ygrid,'--k','LineWidth',1); hold on
semilogx(ygrid,pdf_gam.*ygrid,'-','Color',c1);
semilogx(t,meObj_gam.f(t).*t,'o','Color',c1);
%xlabel('$y$')
%ylabel('PDF of $\log Y$')
xlim([1e-4,1e2])
%legend('Population','Estimate','Thresholds','Location','NW')
title('Gamma')

subplot(2,2,3);
semilogx(ygrid,pdf0_wbl.*ygrid,'--k','LineWidth',1); hold on
semilogx(ygrid,pdf_wbl.*ygrid,'-','Color',c1);
semilogx(t,meObj_wbl.f(t).*t,'o','Color',c1);
xlabel('$y$')
ylabel('PDF of $\log Y$')
xlim([1e-4,1e2])
%legend('Population','Estimate','Thresholds','Location','NW')
title('Gamma')

subplot(2,2,4);
semilogx(ygrid,pdf0_dP.*ygrid,'--k','LineWidth',1); hold on
semilogx(ygrid,pdf_dP.*ygrid,'-','Color',c1);
semilogx(t,meObj_dP.f(t).*t,'o','Color',c1);
xlabel('$y$')
%ylabel('PDF of $\log Y$')
xlim([1e-4,1e2])
%legend('Population','Estimate','Thresholds','Location','NW')
title('Double Pareto')

f.Position = [200 50 1120 840];

exportgraphics(f,'fig_density.pdf');