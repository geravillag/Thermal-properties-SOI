clear all
close all
clc

path = 'C:\Users\Gerardo Villarreal\OneDrive - University of Bristol\THESIS-GerardosPC\COMSOL Files\MATERIAL PROPERTIES\';
cd(path)

addpath 'C:\Users\Gerardo Villarreal\Documents\MATLAB\Utilities';
savepath;

set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex')
set(groot, 'defaultTextInterpreter','latex')
set(0,'defaultAxesFontSize',14)
set(0,'defaultLegendFontSize',10)
set(groot,'defaultLineLineWidth',2.0)
set(0,'DefaultTextInterpreter', 'latex')

%%
%Specific Heat Silicon
clc
close all

file_name = 'Cp_Si.txt';
fileID=fopen(file_name,'r');
A=textscan(fileID,'%f %f  \n');
CpSi=cell2mat(A);
fclose(fileID);

%Specific Heat Silica
file_name = 'Cp_SiO2.txt';
fileID=fopen(file_name,'r');
A=textscan(fileID,'%f %f  \n');
CpSiO2=cell2mat(A);
fclose(fileID);

%Specific heat aluminium
file_name = 'Cp_Al.txt';
fileID=fopen(file_name,'r');
A=textscan(fileID,'%f %f  \n');
CpAl=cell2mat(A);
fclose(fileID);

%Specific heat Titanium
% 
% 
% theta=420;                  %Debbye Temperature  K^-1
% beta=1944/(theta^3);          %J mol^-1 K^-4
% beta=1.93e-8;
% CpTi =gamma*T + beta*T.^3;
A = csvread([path 'Cp_Ti.csv'],1,0);
T1=A(:,1);
CpTi=A(:,2);

T2=linspace(0,min(T1),50);
gamma=3.35e-3/47.867;       %Sommerfeld constant J mol^-1 K^-2
beta = 7.1347e-7;
CpTi2=gamma*T2+beta*T2.^3;

%Thermal Conductivity Silicon
file_name = 'kt_SI.txt';
fileID=fopen(file_name,'r');
A=textscan(fileID,'%f %f  \n');
ktSi=cell2mat(A);
fclose(fileID);

%Thermal Conductivity Silica
file_name = 'kt_SiO2.txt';
fileID=fopen(file_name,'r');
A=textscan(fileID,'%f %f  \n');
ktSiO2=cell2mat(A);
fclose(fileID);

%Thermal Conductivity Aluminium
file_name = 'kt_Al.txt';
fileID=fopen(file_name,'r');
A=textscan(fileID,'%f %f  \n');
ktAl=cell2mat(A);
fclose(fileID);

%Thermal conductivity Titanium
T=linspace(0,300,300);
ktTi=10.^(-2.398794842+8.970743802*(log10(T))+ (-29.19286973)*(log10(T)).^2 + (54.87139779)*(log10(T)).^3 + (-59.67137228)*(log10(T)).^4 + (38.89321714)*(log10(T)).^5 + (-14.94175848)*(log10(T)).^6 + (3.111616089)*(log10(T)).^7 + (-0.270452768)*(log10(T)).^8);

figure(1)
plot(CpSi(:,1),CpSi(:,2),'LineWidth',2)
hold on
plot(CpSiO2(:,1),CpSiO2(:,2),'LineWidth',2,'LineStyle','--')
plot(CpAl(:,1),CpAl(:,2)/1000,'LineWidth',2,'LineStyle',':')
plot(T1,CpTi,'LineWidth',2,'LineStyle','-.');
plot(T2,CpTi2,'LineWidth',2,'LineStyle','-.');
xlabel('Temperature (K)','FontSize',14)
ylabel('Specific Heat (J/(g $\cdot$ K))')
%set(gca,'YScale','log')
%set(gca,'XScale','log')
set(gca,'XLim',[0 300])
set(gcf,'Color',[1 1 1])
set(gca,'FontSize',12)
%set(gca,'YTick',[0:0.1:1])
legend({'Si','SiO$_2$','Al','Ti'},'Location','NorthWest','FontSize',12);

figure(2)
plot(ktSi(:,1),ktSi(:,2),'LineWidth',2)
hold on
plot(ktSiO2(:,1),ktSiO2(:,2),'LineWidth',2,'LineStyle','--')
plot(ktAl(:,1),ktAl(:,2),'LineWidth',2,'LineStyle',':')
plot(T,ktTi,'LineWidth',2,'LineStyle','-.')
xlabel('Temperature (K)','FontSize',14)
ylabel('Thermal conductivity [W/(cm $\cdot$ K)]')
set(gca,'YScale','log')
%set(gca,'XScale','log')
set(gca,'XLim',[0 300])
set(gcf,'Color',[1 1 1])
set(gca,'FontSize',12)
%set(gca,'YTick',[0:0.1:1])
legend({'Si','SiO$_2$','Al','Ti'},'Location','SouthEast','FontSize',12);

%Comparison between kt of Si and SiO2 for all T.
T4=linspace(0,300,300);
figure(3)
yyaxis left
plot(T4,interp1(CpSi(:,1),CpSi(:,2),T4)./interp1(CpSiO2(:,1),CpSiO2(:,2),T4),'LineWidth',1.5)
ylabel('Cp$_{Si}$/Cp_${SiO_2}$','interpreter','latex')
%set(gca,'YScale','log')
yyaxis right
plot(T4,interp1(ktSi(:,1),ktSi(:,2),T4)./interp1(ktSiO2(:,1),ktSiO2(:,2),T4),'LineWidth',1.5)
ylabel('\kappa$_{Si}$/\kappa_{SiO_2}')
xlabel('Temperature (K)','FontSize',12)
set(gca,'YScale','log')
set(gca,'FontSize',12)
set(gcf,'Color',[1 1 1 ])

figure(4)%proportional to the thermal difussivity kt/cp (could also include thermal expansion in temperature dependent density
T5=linspace(max(min(CpSi(:,1),min(ktSi(:,1)))),min(max(CpSi(:,1),max(ktSi(:,1)))),1000);
plot(T5,interp1(ktSi(:,1),ktSi(:,2),T5)./interp1(CpSi(:,1),CpSi(:,2),T5))
ylabel('Difussivity')
xlabel('Temperature (K)')
hold on
plot(T5,interp1(ktSiO2(:,1),ktSiO2(:,2),T5)./interp1(CpSiO2(:,1),CpSiO2(:,2),T5))
set(gca,'YScale','log')
legend({'Si','SiO$_2$'})

figure(5)
plot(T5,interp1(ktSi(:,1),ktSi(:,2),T5)./interp1(CpSi(:,1),CpSi(:,2),T5)./interp1(ktSiO2(:,1),ktSiO2(:,2),T5)./interp1(CpSiO2(:,1),CpSiO2(:,2),T5))
set(gca,'YScale','log')
xlabel('Temperature')
ylabel('Diffusivity ratio Si/SiO$_2$')

autoArrangeFigures();
%%
T3=[T2 T1'];
CpTi3=[CpTi2 CpTi'];
figure(3);plot(T3,CpTi3)
%csvwrite('Cp_Ti_complete.csv',[T3' CpTi3'])

%%
close all
clear -path
clc

%Thermo-Optic Coefficient in Silicon
data=csvread([path 'ThermoOptic_Si.csv'],1,0);
T=data(:,1);
TOSi=data(:,2);

figure(1)
scatter(T,TOSi,'LineWidth',1.5)
set(gca,'YScale','log')
set(gca,'Xlim',[0 310])
xlabel('Temperature (K)')
ylabel('dn/dT (K^{-1})')
set(gca,'FontSize',13)
set(gcf,'Color',[1 1 1 ])

%%
%Thermal expansion coefficients
close all
clear all
clc

data_Si=sortrows(dlmread('alpha_Si.txt',' '),1);
data_SiO2=sortrows(dlmread('alpha_SiO2.txt',' '),1);
data_Al=sortrows(dlmread('alpha_Al.txt',' '),1);
data_brass=sortrows(dlmread('alpha_brass.txt','\t'),1);
data_copper=sortrows(dlmread('alpha_copper.txt','\t'),1);
data_Ti=sortrows(dlmread('alpha_Ti6Al4V.txt','\t'),1);

a=-1.711E2;
b=-2.140E-1;
c=4.807E-3;
d=-7.111E-6;

T=linspace(0,300,100);
T2=linspace(24,300,500);
y = a + b*T2 + c*T2.^2 + d*T2.^3;

figure(1)
plot(T,interp1(data_Si(:,1),data_Si(:,2),T,'linear','extrap'))
hold on
plot(data_SiO2(:,1),1e-6*data_SiO2(:,2))
plot(T,interp1(data_Al(:,1),data_Al(:,2),T,'linear','extrap'))
plot(T,interp1(data_brass(:,1),data_brass(:,2),T,'linear','extrap'))
plot(T,interp1(data_copper(:,1),data_copper(:,2),T,'linear','extrap'))
%plot(T,interp1(data_Ti(:,1),data_Ti(:,2),T,'linear','extrap'))
plot(T,interp1(T2,y*1./(T2-293)*1e-5,T,'linear','extrap'))
xlabel('Temperature (K)')
ylabel('$\alpha$ (K$^{-1}$)');
set(gca,'XLim',[1 300])
%set(gca,'YLim',[-1 0.5]*1e-6)
%set(gca,'YScale','log')
set(gca,'XScale','log')
legend({'Si','SiO$_2$','Al','Brass','Cu','Ti-6Al-4V'},'Location','NorthWest')
set(gca,'LooseInset',get(gca,'TightInset'))