%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% main
% (c) 2022 Alexis Akira Toda
%
% Purpose: 
%       Main analysis in Lee et al. (2024) "Tuning Parameter-Free
%       Nonparametric Density Estimation from Tabulation Data", Journal of
%       Econometrics, https://doi.org/10.1016/j.jeconom.2023.105568
%
% Version 1.1: August 23, 2022
%
% Version 1.2: July 12, 2024
% - Minor expositional changes
% - Combined original and smoothed versions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

smoothed = false; % use smoothed version or not (in paper, it is 'false')

%% plot function phi (Figure B.1)

phi = @(x)(cosh(x)./sinh(x) - 1./x);
x = linspace(-6,6,1000);

figure
plot(x,phi(x));
yline(0,'k--','LineWidth',1);
legend('Graph of $\phi(x)$','Location','NW')

exportgraphics(gcf,'fig_phi_graph.pdf',...
    'Resolution',300,'ContentType','vector')

%% analysis of US income distribution (Section 5.1 of paper)

Y1 = 1946;
Y2 = 2019;
P1 = 21.480; % read CPI for year Y1
P2 = 258.263; % read CPI for year Y2
infl = P2/P1; % gross inflation rate

% year Y1 data
temp = readmatrix(['IRS' num2str(Y1) '.xlsx']);
AGI_threshold1 = temp(:,1)*infl; % vector of lower threshold
Nreturns1 = temp(:,2); % vector of number of returns
AGI1 = temp(:,3)*infl; % adjusted gross income

t1 = flipud(AGI_threshold1); % thresholds
p1 = cumsum(flipud(Nreturns1))/sum(Nreturns1); % top fractile
y1 = flipud(AGI1./Nreturns1); % group mean
q1 = [p1(1); diff(p1)]; % bin probability

% year Y2 data
temp = readmatrix(['IRS' num2str(Y2) '.xlsx']);
AGI_threshold2 = temp(:,1); % vector of lower threshold
Nreturns2 = temp(:,2); % vector of number of returns
AGI2 = temp(:,3); % adjusted gross income

t2 = flipud(AGI_threshold2); % thresholds
p2 = cumsum(flipud(Nreturns2))/sum(Nreturns2); % top fractile
y2 = flipud(AGI2./Nreturns2); % group mean
q2 = [p2(1); diff(p2)]; % bin probability

% estimation
if smoothed == false % original version
    meObj1 = MEtab(p1,y1,t1); 
    meObj2 = MEtab(p2,y2,t2);
else % smoothed version
    meObj1 = MEtab(p1,y1,t1(end),'log'); 
    meObj2 = MEtab(p2,y2,t2(end),'log');
end

% create grid for plotting
ygrid1 = exp(linspace(log(t1(end)),log(t1(1)),1000));
ygrid2 = exp(linspace(log(t2(end)),log(t2(1)),1000));

% evaluate pdf and cdf on grid
pdf1 = meObj1.f(ygrid1);
cdf1 = meObj1.F(ygrid1);
pdf2 = meObj2.f(ygrid2);
cdf2 = meObj2.F(ygrid2);

% plot pdf (Figure 3(a))
figure
semilogx(t2,meObj2.f(t2).*t2,'o','Color',c1); hold on
semilogx(t1,meObj1.f(t1).*t1,'x','Color',c2);
semilogx(ygrid2,pdf2.*ygrid2,'-','Color',c1);
semilogx(ygrid1,pdf1.*ygrid1,'-','Color',c2);
xlabel('Income (2019 dollars)')
ylabel('PDF of log income')
legend(num2str(Y2),num2str(Y1))
xlim([100,1e7])

exportgraphics(gcf,'fig_logincomePDF.pdf',...
    'Resolution',300,'ContentType','vector')

% log-log plot of tail probability (Figure 3(b))
figure
loglog(t2,p2,'o','Color',c1); hold on
loglog(t1,p1,'x','Color',c2);
loglog(ygrid2,1-cdf2,'-','Color',c1);
loglog(ygrid1,1-cdf1,'-','Color',c2);
xlabel('Income (2019 dollars)')
ylabel('Tail probability')
legend(num2str(Y2),num2str(Y1))

exportgraphics(gcf,'fig_loglog.pdf',...
    'Resolution',300,'ContentType','vector')

%% calculate top income shares

lambda1 = meObj1.lambda;
tailProb1 = 1 - meCDF(ygrid1,p1,t1,lambda1);
tailExp1 = meTailExp(ygrid1,p1,t1,lambda1);
ybar1 = sum(AGI1)/sum(Nreturns1); % average income
topShare_ME1 = tailExp1/ybar1;
topShare_data1 = cumsum(flipud(AGI1))/sum(AGI1);

lambda2 = meObj2.lambda;
tailProb2 = 1 - meCDF(ygrid2,p2,t2,lambda2);
tailExp2 = meTailExp(ygrid2,p2,t2,lambda2);
ybar2 = sum(AGI2)/sum(Nreturns2); % average income
topShare_ME2 = tailExp2/ybar2;
topShare_data2 = cumsum(flipud(AGI2))/sum(AGI2);

% plot top shares in original scale (Figure 4(a))
figure
plot(p2,topShare_data2,'o','Color',c1); hold on
plot(p1,topShare_data1,'x','Color',c2);
plot(tailProb2,topShare_ME2,'-','Color',c1);
plot(tailProb1,topShare_ME1,'-','Color',c2);
xlabel('Top fractile')
ylabel('Top income share')
ylim([0,1])
legend(num2str(Y2),num2str(Y1),'Location','NW')

exportgraphics(gcf,'fig_topshare.pdf',...
    'Resolution',300,'ContentType','vector')

% plot top shares in log-log scale (Figure 4(b))
figure
loglog(p2,topShare_data2,'o','Color',c1); hold on
loglog(p1,topShare_data1,'x','Color',c2);
loglog(tailProb2,topShare_ME2,'-','Color',c1);
loglog(tailProb1,topShare_ME1,'-','Color',c2);

xlabel('Top fractile')
ylabel('Top income share')
legend(num2str(Y2),num2str(Y1),'Location','NW')

exportgraphics(gcf,'fig_topshare_loglog.pdf',...
    'Resolution',300,'ContentType','vector')

%% plot time series of top income shares (Section 5.2)

year = 1936:2018; % years to plot
T = length(year);
top_fractile = [0.01 0.05 0.1 0.2 0.4 0.6 0.8]; % top fractiles
K = length(top_fractile);

topShareME = nan(T,K); % store top income shares

sample_size = 1e3*readmatrix('TabFig2018.xls','Sheet','Table A0','Range','B29:B111'); % sample size
total_income = 1e6*readmatrix('TabFig2018.xls','Sheet','Table A0','Range','I29:I111'); % total income
topSharePS = fliplr(readmatrix('TabFig2018.xls','Sheet','Table A3','Range','B29:D111')); % top income share in PS data

for t = 1:T
    filename = ['IRS' num2str(year(t)) '.xlsx'];
    temp = readtable(filename);
    N_tot = temp.N_AGI; % number of returns
    Y_tot = temp.AGI; % adjusted gross income
    
    % redefine variables to take cumulative sums
    N_tot = cumsum(flipud(N_tot)); % number of returns above each threshold
    Y_tot = cumsum(flipud(Y_tot)); % total income above each threshold

    % construct inputs for ME estimation
    p_tot = N_tot/N_tot(end); % top fractiles corresponding to bin threshodlds
    t_tot = flipud(temp.lower_threshold); % bin thresholds
    y_tot = [Y_tot(1)/N_tot(1); diff(Y_tot)./diff(N_tot)]; % average income in each group

    % ME estimation of tax filers
    if smoothed == false % original version
        meObj = MEtab(p_tot,y_tot,t_tot);
    else % smoothed version
        meObj = MEtab(p_tot,y_tot,t_tot(end),'log');
    end
    
    % compute top income shares
    if year(t) < 1945
        kmax = 3; % pre 1945, compute only within top 10%
    else
        kmax = K;
    end

    for k = 1:kmax
        lambda = meObj.lambda;
        top_prob = top_fractile(k)*sample_size(t)/N_tot(end); % adjust top fractile for non-filers
        func = @(x)(1-meCDF(x,p_tot,t_tot,lambda)-top_prob);
        fval = func(t_tot);
        k_neg = sum(fval < 0); % number of thresholds that give negative fval
        x = fzero(func,t_tot(k_neg));
        topshare = meTailExp(x,p_tot,t_tot,lambda)*N_tot(end)/total_income(t);
        topShareME(t,k) = topshare;
    end
end

% plot Figure 5
figure
hold on
plot(year,100*topShareME);
xline(1986,'k--','LineWidth',0.5);
text(1986,110,'1986')
xlim([year(1) 2020])
xlabel('Year')
ylabel('Top income share (\%)')
title('Top $p$ fractile for $p\in \{0.01, 0.05, 0.1, 0.2, 0.4, 0.6, 0.8\}$')

exportgraphics(gcf,'fig_topshare_1-80.pdf',...
    'Resolution',300,'ContentType','vector')

% plot Figure 6
figure
hold on
plot(year,100*topShareME(:,1:3));
plot(year,topSharePS(:,1),':','Color',c1); 
plot(year,topSharePS(:,2),':','Color',c2); 
plot(year,topSharePS(:,3),':','Color',c3);
xline(1986,'k--','LineWidth',0.5);
text(1986,55,'1986')
xlim([year(1) 2020])
xlabel('Year')
ylabel('Top income share (\%)')
legend('Top 1\%','Top 5\%','Top 10\%','Piketty-Saez','Location','best')

exportgraphics(gcf,'fig_topshare_1-10.pdf',...
    'Resolution',300,'ContentType','vector')