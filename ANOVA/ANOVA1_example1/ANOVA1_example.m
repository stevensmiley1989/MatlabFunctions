clc 
clear all
close all

%% Code Objective 1: Import data from excel & look at Data
T= readtable('RV Wall thickness_sjs.csv');
T=table2array(T);

%% Code Objective 2:  Show that anova-1 gives same result as Unpaired T-test for Control & PH 7 week mice.
labels = {'Control','PH'};
[hanova,panova]= anova1(T(:,[1:2]),labels);
%% Function Objective 2:  Boxplot
fc=3
figure(fc), boxplot(T(:,[1,2]),'Labels',labels)
titlelabel2='Anova-1';
title({['Figure -',num2str(fc)],['Boxplot'],[titlelabel2],['p = ',num2str(hanova)]})
xlabel='Control vs. PH';
ylabel='RV Wall thickness (mm)';