% clean data from IRS spreadsheets, 1993-
% for tip to write excel files in Matlab, see
% https://www.mathworks.com/help/matlab/import_export/exporting-to-excel-spreadsheets.html

C = {'lower_threshold','N_AGI','AGI','N_salary_wage','salary_wage','tax','ex_cg'};

%% 1916-1930

year = 1916:1930;
T = length(year);

for t = 1:T
    rawname = ['raw' num2str(year(t)) '.xlsx'];
    filename = ['IRS' num2str(year(t)) '.xlsx'];
    temp = xlsread(rawname);
    temp(temp(:,1) == -999,:) = []; % delete rows with -999
    
    % 1916
    if year(t) == 1916
        temp(end-28,2:end) = sum(temp(end-28:end-24,2:end),1);
        temp(end-27:end-24,:) = [];
        temp(end-23,2:end) = sum(temp(end-23:end-22,2:end),1);
        temp(end-22,:) = [];
        temp(end-21,2:end) = sum(temp(end-21:end-19,2:end),1);
        temp(end-20:end-19,:) = [];
        temp(end-18,2:end) = sum(temp(end-18:end-17,2:end),1);
        temp(end-17,:) = [];
        temp(end-16,2:end) = sum(temp(end-16:end-15,2:end),1);
        temp(end-15,:) = [];
        temp(end-14,2:end) = sum(temp(end-14:end-13,2:end),1);
        temp(end-13,:) = [];
        temp(end-8,2:end) = sum(temp(end-8:end-7,2:end),1);
        temp(end-7,:) = [];
        temp(end-3,2:end) = sum(temp(end-3:end,2:end),1);
        temp(end-2:end,:) = [];
    end
    
    % 1917
    if year(t) == 1917
        temp(end-37,2:end) = sum(temp(end-37:end-35,2:end),1);
        temp(end-36:end-35,:) = [];
        temp(end-33,2:end) = sum(temp(end-33:end-29,2:end),1);
        temp(end-32:end-29,:) = [];
        temp(end-28,2:end) = sum(temp(end-28:end-23,2:end),1);
        temp(end-27:end-23,:) = [];
        temp(end-22,2:end) = sum(temp(end-22:end-20,2:end),1);
        temp(end-21:end-20,:) = [];
        temp(end-19,2:end) = sum(temp(end-19:end-18,2:end),1);
        temp(end-18,:) = [];
        temp(end-17,2:end) = sum(temp(end-17:end-16,2:end),1);
        temp(end-16,:) = [];
        temp(end-15,2:end) = sum(temp(end-15:end-14,2:end),1);
        temp(end-14,:) = [];
        temp(end-9,2:end) = sum(temp(end-9:end-8,2:end),1);
        temp(end-8,:) = [];
        temp(end-7,2:end) = sum(temp(end-7:end-6,2:end),1);
        temp(end-6,:) = [];
        temp(end-3,2:end) = sum(temp(end-3:end,2:end),1);
        temp(end-2:end,:) = [];
    end
    
    % 1918, 1919, 1922, 1923
    if ismember(year(t),[1918 1919 1922 1923])
        temp(end-1,2:end) = sum(temp(end-1:end,2:end),1); % combine top 2 groups
        temp(end,:) = [];
    end
    
    % 1920
    if year(t) == 1920
        temp(end-3,2:end) = sum(temp(end-3:end-2,2:end),1); % combine top 3-4 groups
        temp(end-2,:) = [];
        temp(end-1,2:end) = sum(temp(end-1:end,2:end),1); % combine top 1-2 groups
        temp(end,:) = [];
    end
    
    % 1921
    if year(t) == 1921
        temp(end-4,2:end) = sum(temp(end-4:end-3,2:end),1); % combine top 4-5 groups
        temp(end-3,:) = [];
        temp(end-2,2:end) = sum(temp(end-2:end,2:end),1); % combine top 1-3 groups
        temp(end-1:end,:) = [];
    end
    
    % 1927-
    if year(t) >= 1927
        temp(1,2:end) = sum(temp(1:5,2:end),1); % combine bottom 5 groups
        temp(2:5,:) = [];
    end
    
    writecell(C,filename,'Range','A1:F1');
    writematrix(temp,filename,'Range','A2:F100')
end

%% 1931--1933

year = 1931:1933;
T = length(year);

for t = 1:T
    rawname = ['raw' num2str(year(t)) '.xlsx'];
    filename = ['IRS' num2str(year(t)) '.xlsx'];
    temp = xlsread(rawname);
    temp(temp(:,1) == -999,:) = []; % delete rows with -999
    
    temp(1,2:end) = sum(temp(1:5,2:end),1); % combine bottom 5 groups
    temp(2:5,:) = [];
    % 1931
    if year(t) == 1931
        temp(end-1,2:end) = sum(temp(end-1:end,2:end),1); % combine top 1-2 groups
        temp(end,:) = [];
    end
    % 1933
    if year(t) == 1933
        temp(end-4,2:end) = sum(temp(end-4:end-3,2:end),1); % combine top 4-5 groups
        temp(end-3,:) = [];
        temp(end-2,2:end) = sum(temp(end-2:end,2:end),1); % combine top 1-3 groups
        temp(end-1:end,:) = [];
    end
    
    temp(:,5) = 1000*temp(:,5); % salary_wage is in thousands
    
    writecell(C,filename,'Range','A1:F1');
    writematrix(temp,filename,'Range','A2:F100')
end

%% 1934-1992

year = 1934:1992;
T = length(year);

for t = 1:T
    rawname = ['raw' num2str(year(t)) '.xlsx'];
    filename = ['IRS' num2str(year(t)) '.xlsx'];
    temp = xlsread(rawname);
    temp(temp(:,1) == -999,:) = []; % delete rows with -999
    
    if year(t) <= 1936
        temp(1,2:end) = sum(temp(1:5,2:end),1); % combine bottom 5 groups
        temp(2:5,:) = [];
    end
    % 1934
    if year(t) == 1934
        temp(end-4,2:end) = sum(temp(end-4:end-3,2:end),1); % combine top 4-5 groups
        temp(end-3,:) = [];
        temp(end-2,2:end) = sum(temp(end-2:end,2:end),1); % combine top 1-3 groups
        temp(end-1:end,:) = [];
    end
    % 1935
    if year(t) == 1935
        temp(end-2,2:end) = sum(temp(end-2:end-1,2:end),1); % combine top 2-3 groups
        temp(end-1,:) = [];
        temp(:,6) = temp(:,6)/1000; % for 1935 only, taxes are raw numbers
    end
    
    % take care of Form 1040A
    if year(t) == 1941
        temp(1,2:end) = sum(temp(1:6,2:end),1); % combine bottom 6 groups
        temp(2:6,:) = [];
    end
    
    if ismember(year(t),[1942 1943])
        temp(1,2:end) = sum(temp(1:11,2:end),1); % combine bottom 11 groups
        temp(2:11,:) = [];
    end
    
    if ismember(year(t),[1936 1946])
        temp(end-1,2:end) = sum(temp(end-1:end,2:end),1); % combine top two groups
        temp(end,:) = [];
    end
    
    temp(:,3) = 1000*temp(:,3); % money amounts are in thousands
    temp(:,5) = 1000*temp(:,5); % money amounts are in thousands
    temp(:,6) = 1000*temp(:,6); % money amounts are in thousands

    if year(t) == 1986
        temp(:,7) = 1000*temp(:,7); % money amounts are in thousands
    end
    
    writecell(C,filename,'Range','A1:G1');
    writematrix(temp,filename,'Range','A2:G100')
end

%% 1985-1992

%{
year = 1985:1992;
T = length(year);

for t = 1:T
    rawname = ['raw' num2str(year(t)) '.xlsx'];
    filename = ['IRS' num2str(year(t)) '.xlsx'];
    temp = xlsread(rawname);
    temp(temp(:,1) == -999,:) = []; % delete rows with -999
    
    temp(:,2) = 1000*temp(:,2); % number of returns are in thousands
    temp(:,3) = 1e6*temp(:,3); % money amounts are in millions
    temp(:,4) = 1000*temp(:,4); % number of returns are in thousands
    temp(:,5) = 1e6*temp(:,5); % money amounts are in millions
    temp(:,6) = 1e6*temp(:,6); % money amounts are in millions
    
    writecell(C,filename,'Range','A1:F1');
    writematrix(temp,filename,'Range','A2:F100')
end
%}

%% 1993

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000]]'; % lower cutoff of AGI
temp1 = xlsread('93in14si.xlsx','B10:E23');
temp2 = xlsread('93in14si.xlsx','M433:M446');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS1993.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F15')

%% 1994

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000]]'; % lower cutoff of AGI
temp1 = xlsread('94in14si.xlsx','B10:E23');
temp2 = xlsread('94in14si.xlsx','M433:M446');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS1994.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F15')

%% 1995

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000]]'; % lower cutoff of AGI
temp1 = xlsread('95in14ar.xlsx','B10:E23');
temp2 = xlsread('95in14ar.xlsx','M433:M446');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS1995.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F15')

%% 1996

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000]]'; % lower cutoff of AGI
temp1 = xlsread('96in14si.xlsx','B10:E23');
temp2 = xlsread('96in14si.xlsx','O433:O446');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS1996.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F15')

%% 1997

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000]]'; % lower cutoff of AGI
temp1 = xlsread('97in14.xlsx','B11:E24');
temp2 = xlsread('97in14.xlsx','O444:O457');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS1997.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F15')

%% 1998

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000]]'; % lower cutoff of AGI
temp1 = xlsread('98in14ar.xlsx','B10:E23');
temp2 = xlsread('98in14ar.xlsx','O433:O446');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS1998.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F15')

%% 1999

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000]]'; % lower cutoff of AGI
temp1 = xlsread('99in14ar.xlsx','B10:E23');
temp2 = xlsread('99in14ar.xlsx','O433:O446');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS1999.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F15')

%% 2000

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('00in14ar.xlsx','B11:E28');
temp2 = xlsread('00in14ar.xlsx','O484:O501');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2000.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2001

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('01in14ar.xlsx','B10:E27');
temp2 = xlsread('01in14ar.xlsx','O473:O490');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2001.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2002

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('02in14ar.xlsx','B10:E27');
temp2 = xlsread('02in14ar.xlsx','O568:O585');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2002.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2003

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('03in14ar.xlsx','B10:E27');
temp2 = xlsread('03in14ar.xlsx','G758:G775');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2003.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2004

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('04in14ar.xlsx','B13:E30');
temp2 = xlsread('04in14ar.xlsx','FG13:FG30');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2004.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2005

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('05in14ar.xlsx','B11:E28');
temp2 = xlsread('05in14ar.xlsx','FI11:FI28');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2005.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2006

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('06in14ar.xlsx','B11:E28');
temp2 = xlsread('06in14ar.xlsx','FK11:FK28');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2006.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2007

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('07in14ar.xlsx','B11:E28');
temp2 = xlsread('07in14ar.xlsx','FK11:FK28');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2007.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2008

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('08in14ar.xlsx','B11:E28');
temp2 = xlsread('08in14ar.xlsx','FM11:FM28');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2008.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2009

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 250 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('09in14ar.xlsx','B11:G29');
temp1(:,[3 4]) = [];
temp2 = xlsread('09in14ar.xlsx','FO11:FO29');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2009.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F20')

%% 2010

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 250 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('10in14ar.xlsx','B11:G29');
temp1(:,[3 4]) = [];
temp2 = xlsread('10in14ar.xlsx','FS11:FS29');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2010.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F20')

%% 2011

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 250 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('11in14ar.xlsx','B11:G29');
temp1(:,[3 4]) = [];
temp2 = xlsread('11in14ar.xlsx','FS11:FS29');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2011.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F20')

%% 2012

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 250 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('12in14ar.xlsx','B11:G29');
temp1(:,[3 4]) = [];
temp2 = xlsread('12in14ar.xlsx','EG11:EG29');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2012.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F20')

%% 2013

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('13in14ar.xlsx','B11:G28');
temp1(:,[3 4]) = [];
temp2 = xlsread('13in14ar.xlsx','EG11:EG28');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2013.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2014

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('14in14ar.xlsx','B11:G28');
temp1(:,[3 4]) = [];
temp2 = xlsread('14in14ar.xlsx','EI11:EI28');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2014.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2015

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('15in14ar.xlsx','B11:G28');
temp1(:,[3 4]) = [];
temp2 = xlsread('15in14ar.xlsx','EI11:EI28');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2015.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2016

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('16in14ar.xlsx','B11:G28');
temp1(:,[3 4]) = [];
temp2 = xlsread('16in14ar.xlsx','EI11:EI28');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2016.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2017

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('17in14ar.xlsx','B11:G28');
temp1(:,[3 4]) = [];
temp2 = xlsread('17in14ar.xlsx','EM11:EM28');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2017.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2018

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('18in14ar.xlsx','B11:G28');
temp1(:,[3 4]) = [];
temp2 = xlsread('18in14ar.xlsx','EQ11:EQ28');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2018.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')

%% 2019

lcutoff = [1 1000*[5 10 15 20 25 30 40 50 75 100 200 500 1000 1500 2000 5000 10000]]'; % lower cutoff of AGI
temp1 = xlsread('19in14ar.xlsx','B11:G28');
temp1(:,[3 4]) = [];
temp2 = xlsread('19in14ar.xlsx','ES11:ES28');

temp = [lcutoff temp1 temp2];
temp(:,[3 5 6]) = 1000*temp(:,[3 5 6]);

filename = 'IRS2019.xlsx';
writecell(C,filename,'Range','A1:F1');
writematrix(temp,filename,'Range','A2:F19')