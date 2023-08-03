%% create figures from tab_simu.xlsx

clear
close all
clc;

%% figure formatting

set(0,'DefaultTextInterpreter','latex')
set(0,'DefaultAxesTickLabelInterpreter','latex');
set(0,'DefaultLegendInterpreter', 'latex')
   
set(0,'DefaultTextFontSize', 14)
set(0,'DefaultAxesFontSize', 14)
set(0,'DefaultLineLineWidth',1)

temp = get(gca,'ColorOrder');
c1 = temp(1,:);
c2 = temp(2,:);
c3 = temp(3,:);

close all

%% load data
filename = 'tab_simu.xlsx';
% quantiles
q = xlsread(filename,'Figure 2','X4:AQ4');

% tuning parameter
c = [0.1 0.5 1 1.5];

%% plot results

dist = {'Double Pareto','Lognormal','Gamma'};
dist_short = {'dP','lN','G'};
range = {'X24:AQ38','X62:AQ76','X100:AQ114'};
N = [1e4 1e5 1e6];
N_str = {'$10^4$','$10^5$','$10^6$'};

I = length(range);
J = length(N);

for i = 1:I
    rmse = xlsread(filename,'Figure 2',range{i});
    for j = 1:J
        temp = rmse(5*(j-1)+1:5*j,:);
        figure
        plot(q,temp(1,:),'-','Color',c1); hold on
        plot(q,temp(2:end,:),'--')
        xlabel('Quantile')
        ylabel('Relative RMSE')
        legend('ME','BK $c=0.1$','BK $c=0.5$','BK $c=1.0$','BK $c=1.5$')
        title([dist{i} ', $n=$ ' N_str{j}])
        fig = gca;
        exportgraphics(fig,['fig_sim_' dist_short{i} num2str(N(j)) '.pdf'])
    end
end

%% combine all figures in one

f = figure;
for i = 1:I
    rmse = xlsread(filename,'Figure 2',range{i});
    for j = 1:J
        temp = rmse(5*(j-1)+1:5*j,:);
        
        subplot(3,3,3*(i-1)+j);
        plot(q,temp(1,:),'-','Color',c1); hold on
        plot(q,temp(2:end,:),'--')
        if i == 3
            xlabel('Quantile')
        end
        if j == 1
            ylabel('Relative RMSE')
        end
        if (i==3)&&(j==3)
            legend('ME','BK $c=0.1$','BK $c=0.5$','BK $c=1.0$','BK $c=1.5$')
        end
        title([dist{i} ', $n=$ ' N_str{j}])
    end
end

f.Position = [200 50 1120 840];

exportgraphics(f,'fig_RMSE.pdf');