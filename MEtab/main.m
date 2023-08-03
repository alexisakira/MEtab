%% US income distribution

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

%% plot function phi

phi = @(x)(cosh(x)./sinh(x) - 1./x);
x = linspace(-6,6,1000);

figure
plot(x,phi(x));
yline(0,'k--','LineWidth',1);
legend('Graph of $\phi(x)$','Location','NW')

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig_phi_graph','-dpdf')

%% analysis of US income distribution

Y1 = 1946;
Y2 = 2019;
P1 = 21.480; % read CPI for year Y1
P2 = 258.263; % read CPI for year Y2
infl = P2/P1; % gross inflation rate

% estimation
temp = xlsread(['IRS' num2str(Y1) '.xlsx']);
AGI_threshold1 = temp(:,1)*infl; % vector of lower threshold
Nreturns1 = temp(:,2); % vector of number of returns
AGI1 = temp(:,3)*infl; % adjusted gross income

t1 = flipud(AGI_threshold1); % thresholds
p1 = cumsum(flipud(Nreturns1))/sum(Nreturns1); % top fractile
y1 = flipud(AGI1./Nreturns1); % group mean
q1 = [p1(1); diff(p1)]; % bin probability

temp = xlsread(['IRS' num2str(Y2) '.xlsx']);
AGI_threshold2 = temp(:,1); % vector of lower threshold
Nreturns2 = temp(:,2); % vector of number of returns
AGI2 = temp(:,3); % adjusted gross income

t2 = flipud(AGI_threshold2); % thresholds
p2 = cumsum(flipud(Nreturns2))/sum(Nreturns2); % top fractile
y2 = flipud(AGI2./Nreturns2); % group mean
q2 = [p2(1); diff(p2)]; % bin probability

tic
meObj1 = MEtab(p1,y1,t1);
toc
tic
meObj2 = MEtab(p2,y2,t2);
toc

% plot results
ygrid1 = exp(linspace(log(t1(end)),log(t1(1)),1000));
ygrid2 = exp(linspace(log(t2(end)),log(t2(1)),1000));

pdf1 = meObj1.f(ygrid1);
cdf1 = meObj1.F(ygrid1);
pdf2 = meObj2.f(ygrid2);
cdf2 = meObj2.F(ygrid2);

figure
semilogx(t2,meObj2.f(t2).*t2,'o','Color',c1); hold on
semilogx(t1,meObj1.f(t1).*t1,'x','Color',c2);
semilogx(ygrid2,pdf2.*ygrid2,'-','Color',c1);
semilogx(ygrid1,pdf1.*ygrid1,'-','Color',c2);
xlabel('Income (2019 dollars)')
ylabel('PDF of log income')
legend(num2str(Y2),num2str(Y1))
xlim([100,1e7])

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig_logincomePDF','-dpdf')

figure
loglog(t2,p2,'o','Color',c1); hold on
loglog(t1,p1,'x','Color',c2);
loglog(ygrid2,1-cdf2,'-','Color',c1);
loglog(ygrid1,1-cdf1,'-','Color',c2);

xlabel('Income (2019 dollars)')
ylabel('Tail probability')
legend(num2str(Y2),num2str(Y1))

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig_loglog','-dpdf')

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

figure
loglog(p2,topShare_data2,'o','Color',c1); hold on
loglog(p1,topShare_data1,'x','Color',c2);
loglog(tailProb2,topShare_ME2,'-','Color',c1);
loglog(tailProb1,topShare_ME1,'-','Color',c2);

xlabel('Top fractile')
ylabel('Top income share')
legend(num2str(Y2),num2str(Y1),'Location','NW')

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig_topshare_loglog','-dpdf')

figure
plot(p2,topShare_data2,'o','Color',c1); hold on
plot(p1,topShare_data1,'x','Color',c2);
plot(tailProb2,topShare_ME2,'-','Color',c1);
plot(tailProb1,topShare_ME1,'-','Color',c2);

xlabel('Top fractile')
ylabel('Top income share')
ylim([0,1])
legend(num2str(Y2),num2str(Y1),'Location','NW')

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig_topshare','-dpdf')

%% plot time series of top income shares

year = 1936:2018; % years to plot (can change later)
T = length(year);
%top_fractile = [0.01 0.05 0.1 0.25 0.5]; % top fractiles (can change later)
top_fractile = [0.01 0.05 0.1 0.2 0.4 0.6 0.8];
K = length(top_fractile);

topShareME = nan(T,K); % store top income shares

sample_size = 1e3*xlsread('TabFig2018.xls','Table A0','B29:B111'); % sample size
total_income = 1e6*xlsread('TabFig2018.xls','Table A0','I29:I111'); % total income
topSharePS = fliplr(xlsread('TabFig2018.xls','Table A3','B29:D111')); % top income share in PS data

for t = 1:T
    filename = ['IRS' num2str(year(t)) '.xlsx'];
    temp = xlsread(filename);
    temp(any(isnan(temp),2), :) = []; % delete rows with NaN
    N_tot = temp(:,2);
    Y_tot = temp(:,3); % adjusted gross income
    
    % redefine variables to take cumulative sums
    N_tot = cumsum(flipud(N_tot)); % number of returns above each threshold
    Y_tot = cumsum(flipud(Y_tot)); % total income above each threshold

    % adjust N_tot and Y_tot to match PS data
    %N_tot(end) = sample_size(t);
    %Y_tot(end) = total_income(t);

    % construct inputs for ME estimation
    p_tot = N_tot/N_tot(end); % top fractiles corresponding to bin threshodlds
    t_tot = flipud(temp(:,1)); % bin thresholds
    y_tot = [Y_tot(1)/N_tot(1); diff(Y_tot)./diff(N_tot)]; % average income in each group

    % ME estimation of tax filers
    meObj = MEtab(p_tot,y_tot,t_tot);

    % compute top income shares
    if year(t) < 1945
        kmax = 3;
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

figure
hold on
plot(year,100*topShareME);
xline(1986,'k--','LineWidth',0.5);
text(1986,110,'1986')
xlim([year(1) 2020])
xlabel('Year')
ylabel('Top income share (\%)')
title('Top $p$ fractile for $p\in \{0.01, 0.05, 0.1, 0.2, 0.4, 0.6, 0.8\}$')

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig_topshare_1-80','-dpdf')


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

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig_topshare_1-10','-dpdf')