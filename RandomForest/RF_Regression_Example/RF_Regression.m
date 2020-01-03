clc
clear all
close all

%% Project 1, BioE5020, Problem 2, Steven Smiley
%% Problem Statement:
% You are given data that was collected (in children living in El Paso,
% TX in 1973) to study the effects of lead exposure on the psychological
% and neurological well-being of children. Each child received functional
% and neurological testing at the year of their blood test (measuring lead levels). 
%
%You have two outcome variables for each child: 
%   a. The group ? categorical variable described below 
%   b. Lead level ? the continuous Lead level measurement 
%
%? What is the sensitivity and specificity of predicting each group? 
%   o If you can predict the Group, what measurements are most
%   important for determining the group? 
%
%? Can IQ and neurological tests predict lead levels?

%% Code Objective 1.0 - Load Data
% All Data
Xtrain=xlsread('Project_Python_trainingdata.xlsx',1);
Ytrain=xlsread('Project_Python_trainingdata.xlsx',2);
Xtest=xlsread('Project_Python_trainingdata.xlsx',3);
Ytest=xlsread('Project_Python_trainingdata.xlsx',4);

T_all= readtable('LEAD_data-1.xls');
T_all= table2array (T_all);
headers=T_all (1,:); %making a header matrix
[n_all,m_all]=size(T_all);
T_all=T_all (2:n_all,:); %sorting out the headers
[n_all,m_all]=size(T_all); %redefining the dimensions of my data matrix

% Group ID 
group_ID=T_all(:,23) ; %Extract Group ID from data
[n_ID,m_ID]=size(group_ID);

% Measurements
measurements=T_all(:,1:22);

headers_measurements=headers(:,1:22);
vbls=headers_measurements;

[n_meas,m_meas]=size(measurements);


%% Code Objective 2.0 - Part B
% The IQ is only columns 4 through 17
% The Neurological Test data is only column 22
measurements_PartB=str2double(measurements(:,[4:17,22]));
[n,m]=size(measurements_PartB);
vbls= headers_measurements(:,[4:17,22]);
% 
%% Code Objective 2.1: Import lead data as column
lead= T_all(:,24);
lead= str2double(lead);
[nlead,mlead]=size(lead); 

fc=1;
%% Code Objective 2.5.0 - Perform Random Forest (Regression) with Raw IQ and Neurological Data
iter=1; % number of iterations
for j=1:iter %iterate 1 times with same numbers
HeaderTitle='Raw IQ and Neurological Data';
fc=fc+1;
% Now fit to a Random Forest of decision trees
B2 = 500; % Number of Trees
cv=cvpartition(length(measurements_PartB),'holdout',0.2);
%Xtrain2=measurements_PartB(training(cv),:);
% Xtest2=measurements_PartB(test(cv),:);
% Ytrain2=lead(training(cv),:);
% Ytest2=lead(test(cv),:);
Xtrain2=Xtrain;
Xtest2=Xtest;
Ytrain2=Ytrain;
Ytest2=Ytest;
 Bag_Tree2 = TreeBagger(B2,Xtrain2,Ytrain2, ...
     'OOBPrediction','on','method','regression','oobvarimp','on')
oobErrorBaggedEnsemble2 = oobError(Bag_Tree2);
figure(fc)
plot(oobErrorBaggedEnsemble2)
title({['Figure 1.2b.10.',num2str(j)],HeaderTitle,'Out of Bag Classification Error Plot',['Iteration =',num2str(j)]});
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';


% Use the Random Forest to make a decision about each dot so that you can
% compare the prediciton to the true values.
[Bag_Predic2,scores2] = predict(Bag_Tree2,Xtest2);

headers=vbls;

%% Code Objective 2.5.1: Create linear fit & bland altman plots
fc = fc +1;
figure(fc)
subplot(1,2,1) % adds a subplot on the left to the figure
scatter(Bag_Predic2,Ytest2,8,'filled') % what is subplotted
%% Code Objective 2.5.2.a: linear fit
coeffs = polyfit(Bag_Predic2,Ytest2, 1); %polyfit looks for best fit coefficients of data
% % Get fitted values
 fittedX = linspace(min(Bag_Predic2), max(Bag_Predic2), 200);
 fittedY = polyval(coeffs, fittedX);
% % Plot the fitted line
% R^2
mdl = fitlm(Bag_Predic2,Ytest2); %fitlm gets R^2 & p values from data
R_sq=mdl.Rsquared.Ordinary;
R_sq_table_3(j)=R_sq;
P_v=mdl.Coefficients.pValue(2);
P_V_table_3(j)=P_v;
 hold on;
 plot(fittedX, fittedY, 'r-', 'LineWidth', 3);
 hold on;
 txt = {['Figure 1.2b.11.',num2str(j)];HeaderTitle;['m = ',num2str(coeffs(1)), '  b = ', num2str(coeffs(2))];['R = ',num2str(sqrt(R_sq)), '  P = ',num2str(P_v),' R^2= ',num2str(R_sq)]};
 xlabel({'Y-pred [lead prediction with',HeaderTitle,']'})
 ylabel('Y-test [lead]')
 title(txt,'FontSize',8)
 legend('Ytest vs Ypred data','Correlation')
subplot(1,2,2)
%% Code Objective 2.5.2.b: blandaltman plot
blandaltman_p11(Bag_Predic2,Ytest2,['Y-test [lead] vs. Y-pred [with ',HeaderTitle,']'],j);
hold off;

fc=fc+1;
figure(fc)
vars2=vbls;
varimp2=Bag_Tree2.OOBPermutedVarDeltaError;
[~,idxvarimp2]=sort(varimp2,'ascend');
varimp2(idxvarimp2);
labels2=vars2(idxvarimp2);
bar(categorical(labels2),varimp2(idxvarimp2));
title({['Figure 1.2b.12.',num2str(j)],HeaderTitle,'Variable Importance Plot',['Iteration =',num2str(j)]});
ylabel('00BpermutedVarDeltaError')
xlabel('Variable')

fc = fc +1;
figure(fc)
varimp_sorted2=varimp2(idxvarimp2);
barh(reordercats(categorical(labels2),string(categorical(labels2))),varimp_sorted2(:));
title({['Figure 1.2b.13.',num2str(j)],HeaderTitle,['Iteration =',num2str(j)],'Top 3 Variable Importance'}); xlabel('score'); 
end