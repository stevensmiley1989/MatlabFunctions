clc;
clear all;
close all;

load ALLDATA

D1 = CTLPress;
D2 = ObesDat;
D3 = ObsSmokeDat;

%load ObsPostMed
D4 = ObsPostMed;


%% Testing Systolic Blood Pressure in CO using t-distribution: 
mCTL = mean(D1)
sCTL = var(D1)

[h,p] = ttest(D1,120,'Tail','right') %There is a 78.7% probability that the
% difference we found between 120 is just by chance. 

% Let's try this manually just for this first question: 
t_stat = (mCTL-120)/(sCTL/sqrt(100))

alpha = .95; %critical alpha
nu = 120-1; %degrees of freedom
x = tinv(alpha,nu)

%% Testing Obese vs. CTL Subjects
% Do normal and obese people have the same variance? 
[hv,pv] = vartest2(D1,D2)

% Perform the t-test depepnding on what you found in the F-test
if hv == 1
    [h,pttest2] = ttest2(D1,D2,'Vartype','unequal')
else
    [h,pttest2] = ttest2(D1,D2)
end
boxplot([D1',D2'],'Notch','on','Labels',{'Normals','Group 2'},'Whisker',1)

%% Testing Sildenafil on Group2 
% Since we are comparing the same group at different time points, we will
% run the ttest command. Since the ttest command is generally used for a
% one-sample t-test, when you put in two samples, Matlab considers this a
% paired t-test. So, we are going to do a paired t-test for comparing the
% obesity group before and after Sildenafil. 
TMP = horzcat(D2',D4');
figure, hist(TMP)
% hold on
% hist(D4)
[h,p] = ttest(D2,D4)
[h2,p2] = ttest(D2-D4,0) %same thing as above!!!
clear TMP

%% ANOVA Analysis
%% 1-way ANOVA We want to compare the mean systolic blood pressure between D1, D2, and
% D3
TMP = horzcat(D1',D2',D3');
[pANOVA,tblANOVA,statsANOVA] = anova1(TMP)
multcompare(statsANOVA); %Takes the stats output from anova1 analysis
clear TMP

%% 1-way ANOVA What if you used ANOVA to compare only two groups? 
TMP = horzcat(D1',D2');
[panova_2samples,tbl,stats] = anova1(TMP)
clear TMP

%% 2-way ANOVA - the impact of gender
% We want to see if gender plays a role in the differences that we see
% betwee the 3 groups in 1-way ANOVA.
%The data in D1, D2, and D3 is already organized so that the first 50
%measurements are men and the second 50 are women. 
TMP = horzcat(D1',D2',D3');
[p,tbl,stats] = anova2(TMP,50)
% multcompare(stats); %Takes the stats output from anova1 analysis

