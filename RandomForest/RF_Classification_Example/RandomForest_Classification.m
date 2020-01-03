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


% 
%% Code Objective 1.1 - Perform Random Forest (Classification)
fc=1; %figure number start
iter=1; % number of iterations
for j=1:iter %iterate 3 times with same numbers
fc=fc+1;
% Now fit to a Random Forest of decision trees
B = 500; % Number of Trees
Stage_cv=cvpartition(length(measurements),'holdout',0.20);
Xtrain=str2double(measurements(training(Stage_cv),:));
Xtest=str2double(measurements(test(Stage_cv),:));
Ytrain=str2double(group_ID(training(Stage_cv),:));
Ytest=str2double(group_ID(test(Stage_cv),:));
Bag_Tree = TreeBagger(B,Xtrain,Ytrain, ...
    'OOBPrediction','on','method','classification','oobvarimp','on')

oobErrorBaggedEnsemble = oobError(Bag_Tree);
figure(fc)
plot(oobErrorBaggedEnsemble)
title({['Figure 1.2a.1.',num2str(j)],'Out of Bag Classification Error Plot',['Iteration =',num2str(j)]});
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';



% Use the Random Forest to make a decision about each dot so that you can
% compare the prediciton to the true values.
[Bag_Predic,scores] = predict(Bag_Tree,Xtest);

for i = 1:length(scores(:,1))
    cnum3(i) = str2num(Bag_Predic{i});
end
 

hold off;
C = confusionmat(Ytest,cnum3);
stats = confusionmatStats(Ytest,cnum3);
sensitivity=stats.sensitivity;
specificity=stats.specificity ;
accuracy=stats.accuracy; 
gg=num2str(specificity);
sp=horzcat(gg(1,:),'   ', gg(2,:),'    ', gg(3,:));
gg=num2str(sensitivity);
se=horzcat(gg(1,:),'   ', gg(2,:),'    ', gg(3,:));
gg=100*trace(C)/sum(C(:)); %accuracy
sa=num2str(gg);
gg1=num2str(100*C(1,1)/sum(C(:,1))); %class 1 accuracy
gg2=num2str(100*C(2,2)/sum(C(:,2))); %class 2 accuracy
gg3=num2str(100*C(3,3)/sum(C(:,3))); %class 3 accuracy
sac=horzcat(gg1,'   ', gg2,'    ', gg3);
Ztest=categorical(Ytest);
Zpred=categorical(cnum3');
fc=fc+1;
figure(fc);
name= {['Figure 1.2a.2.',num2str(j)],['Accuracy =', sa, '%'],['Class Accuracy =', sac, '%'],['Sensitivity =',se],['Specificity =',sp],['Iteration =',num2str(j)]};
plotconfusion(Ztest,Zpred,name)



fc=fc+1;
figure(fc)
vars=headers_measurements;
varimp=Bag_Tree.OOBPermutedVarDeltaError;
[~,idxvarimp]=sort(varimp,'descend');
varimp(idxvarimp);
labels=vars(idxvarimp);
bar(categorical(labels),varimp(idxvarimp));
title({['Figure 1.2a.3.',num2str(j)],'Variable Importance Plot',['Iteration =',num2str(j)]});
ylabel('00BpermutedVarDeltaError')
xlabel('Variable')

fc = fc +1;
figure(fc)
varimp_sorted=varimp(idxvarimp);
barh(categorical(labels(1:3)),varimp_sorted(1:3));
%set(gca,'YTickLabel',labels)
title({['Figure 1.2a.4.',num2str(j)],['Iteration =',num2str(j)],'Top 3 Variable Importance'}); xlabel('score'); 
end