%% replicate Piketty & Saez (2003) using 2019 data

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

%% load data and compute local Pareto exponents

topsharePSZ = xlsread('PSZ2022AppendixTablesII(Distrib).xlsx','TD1','E116:J116');
% top shares in Piketty-Saez-Zucman spreadsheet
fractile = [10 5 1 0.5 0.1 0.01]/100;
f_out = 10.^linspace(log10(fractile(1)),-5,1000);

temp = xlsread('IRS2019.xlsx');
t = temp(:,1); % vector of lower threshold
Nreturns = temp(:,2); % vector of number of returns
AGI = temp(:,3); % adjusted gross income

N = cumsum(Nreturns,'reverse'); % number of returns above each threshold
S = cumsum(AGI,'reverse'); % total income above each threshold
s = S./N; % average income above each threshold

b = s./t; % local Pareto coefficient
a = b./(b - 1); % local Pareto exponent

figure
plot(t,a,'-o')
xlabel('Income threshold (\$)')
ylabel('Local Pareto exponent')

%save figure in pdf format
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig_local_Pareto','-dpdf')

%% estimate sample size and replicate top shares

tic
[N0,S0,topshare_rep] = getNS(N,t,S,fractile,topsharePSZ,f_out);
toc

figure
loglog(f_out,topshare_rep,'-','Color',c1); hold on
loglog(fractile,topsharePSZ,'ko');
xlabel('Top fractile')
ylabel('Top income share')
legend('Replication','Piketty \& Saez (2003)','location','NW')

%save figure in pdf format
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig_PSreplication','-dpdf')