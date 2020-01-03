clc;
clear all;
close all;


%% Steven Smiley - Homework 4 - BioE5020 - Problem 1

%% Code Objective 1:  Import the Data
DATA = readtable('DATA.xlsx');

%% make directory for figures
% get current directory
currentdirectory=pwd;
%uniqueID = round(1000*rand());
uniqueID = strjoin([string(month(datetime('now'))),string(day(datetime('now'))),string(hour(datetime('now'))),string(minute(datetime('now'))),string(round(second(datetime('now'))))],'-');
FigureDirectory=strjoin([string(currentdirectory),'/Figures-',string(uniqueID)],'');
mkdir(FigureDirectory)
screenSize = get(0,'screensize');
screenWidth = screenSize(3);
screenHeight = screenSize(4);
% separate the classification label from the predictor variables
Y = categorical(DATA.OUTCOME); %Create the Y Array - 1 if the patient turned out to have cancer 
DATA.OUTCOME = []; %Remove the class column from the data

% Notice that the data is now in table format. The matlab command for
% randon forest ("TreeBagger") actually expects numeric data as input.
% However, it is easier to keep track of tabulated data (particularely when
% importing from excel with a header row). Therefore, right before we start
% using this data, we will transform it to an array using: table2array().

%% Code Objective 2:  Split the data into a training & testing portion
cv = cvpartition(height(DATA),'holdout',0.20); %Hold out 20% of the data
% The training dataset becomes:
Xtrain = DATA(training(cv),:);
Ytrain = Y(training(cv));
% The testing dataset becomes:
Xtest = DATA(test(cv),:);
Ytest = Y(test(cv));

fprintf('Num observations in training data   : %d\n',height(Xtrain))
fprintf('Num variables in training data: %d\n\n',width(Xtrain))
fprintf('Num observations in testing data   : %d\n',height(Xtest))

%% Code Objective 3:  Now let's train a random forest
RF = TreeBagger(300,table2array(Xtrain),Ytrain,...
      'Method','classification','oobvarimp','on');

[Ypred,Yscore]= predict(RF,table2array(Xtest));

%% Code Objective 4: Create a confusion matrix comparing the RF with the testing set
fc=1 % figure counter

%% Use Confusion Matrix to Classify
hold off;
C = confusionmat(Ytest,categorical(Ypred));
stats0 = confusionmatStats(Ytest,categorical(Ypred));
sensitivity=stats0.sensitivity;
specificity=stats0.specificity ;
accuracy=stats0.accuracy; 
sensitivityRF=sensitivity;
specificityRF=specificity;
accuracyRF=accuracy;
groupOrder=stats0.groupOrder;
gg=string(groupOrder);
go=strjoin([gg(1,:), gg(2,:)],',');
gg=num2str(specificity);
sp=horzcat(gg(1,:),'   ', gg(2,:));
gg=num2str(sensitivity);
se=horzcat(gg(1,:),'   ', gg(2,:));
gg=100*trace(C)/sum(C(:)); %accuracy
sa=num2str(gg);
Ztest=categorical(Ytest);
Zpred=categorical(Ypred);
fc=fc+1;
hFig(fc) = figure('Position', [0 0 screenWidth screenHeight],'visible','off');
name= {['Figure 4.1.1, Random Forest Classificaton'],['Accuracy =', sa, '%','  Group Class ID Order =',char(go)],['  Sensitivity =',se,'   Specificity =',sp]};
plotconfusion(Ztest,Zpred,name)
saveas(hFig(fc),strjoin([FigureDirectory,'/Figure 4.1.1 - Random Forest Classification - Confusion Matrix.jpg'],''))
close()


%% (4) Evalue error by the number of OOB classifiers
fc=fc+1;
hFig(fc) = figure('Position', [0 0 screenWidth screenHeight],'visible','off');
plot(oobError(RF));
xlabel('Number of Grown Trees');
ylabel('Out-of-Bag Classification Error');
title({['Figure 4.1.2, Random Forest Classification'],['Out of Bag Error Plot']})
saveas(hFig(fc),strjoin([FigureDirectory,'/Figure 4.1.2 - Random Forest Classification - OutofBagErrorPlot.jpg'],''))
close()


%% (5) Make an importance bar plot
vars = Xtrain.Properties.VariableNames;
varimp = RF.OOBPermutedVarDeltaError';
[~,idxvarimp]= sort(varimp);
labels = vars(idxvarimp);
fc=fc+1;
hFig(fc) = figure('Position', [0 0 screenWidth screenHeight],'visible','off');
barh(varimp(idxvarimp),1); ylim([1 9]);
set(gca, 'YTickLabel',labels, 'YTick',1:numel(labels))
title('Figure 4.1.3, Variable Importance'); xlabel('score')
saveas(hFig(fc),strjoin([FigureDirectory,'/Figure 4.1.3 - Random Forest Classification - VariableImportancePlot.jpg'],''))
close()

%% HW4 - Problem 1 - Part 1
%% Partion Data into Training and Testing
group_ID = Y;
numInputs = size(labels);
Ytrain = grp2idx(Ytrain);
Ytest = grp2idx(Ytest);

%% Convert Training Data from Categorical to Numerical 
%X train
x_train=table2array(Xtrain)';
x=x_train;
%X test
Xtest=table2array(Xtest);
t=ind2vec(Ytrain');


%% Create Neural Network on Training Data
net = patternnet([10]); %single hidden layer of 10 neurons
[net,tr] = train(net,x,t);

%% Convert Testing Data from Categorical to Numerical 
t=ind2vec(Ytest');

%% Predict Y-test with X-test
y = net(Xtest');
y=vec2ind(y);
t=vec2ind(t);

%% View Performance of Neural Network
perf = perform(net,y,t)

fc=fc+1;
%% Use Confusion Matrix to Classify
hold off;
C = confusionmat(Ytest,y);
stats1 = confusionmatStats(Ytest,y);
sensitivity=stats1.sensitivity;
specificity=stats1.specificity ;
sensitivityNN1=sensitivity;
specificityNN1=specificity;
accuracy=stats1.accuracy; 
accuracyNN1=accuracy;
groupOrder=stats1.groupOrder;
gg=string(groupOrder);
go=strjoin([gg(1,:), gg(2,:)],',');
gg=num2str(specificity);
sp=horzcat(gg(1,:),'   ', gg(2,:));
gg=num2str(sensitivity);
se=horzcat(gg(1,:),'   ', gg(2,:));
gg=100*trace(C)/sum(C(:)); %accuracy
sa=num2str(gg);
Ztest=categorical(Ytest);
Zpred=categorical(y);
fc=fc+1;
hFig(fc) = figure('Position', [0 0 screenWidth screenHeight],'visible','off');
name= {['Figure 4.1.4, Neural Network Classificaton, 1 layer with 10 neurons'],['Accuracy =', sa, '%','  Group Class ID Order =',char(go)],['  Sensitivity =',se,'   Specificity =',sp]};
plotconfusion(Ztest,Zpred',name)
saveas(hFig(fc),strjoin([FigureDirectory,'/Figure 4.1.4 - Neural Network Classification - 1 layers, 10 neurons - Confusion Matrix.jpg'],''))
close() 
save('NN1.mat','net')

%% HW4 - Problem 1 - Part 2

%% Create Neural Network on Training Data
x=x_train;
t=ind2vec(Ytrain');
net2 = patternnet([5 5 5]); %3 layers with 5 neurons each
[net2,tr2] = train(net2,x,t);

%% Predict Y-test with X-test
t=ind2vec(Ytest');
y = net2(Xtest');
 y=vec2ind(y);
 t=vec2ind(t);

%% View Performance of Neural Network
perf2 = perform(net2,y,t)


fc=fc+1;
%% Use Confusion Matrix to Classify
hold off;
C = confusionmat(Ytest,y);
stats2 = confusionmatStats(Ytest,y);
sensitivity=stats2.sensitivity;
specificity=stats2.specificity ;
accuracy=stats2.accuracy; 
sensitivityNN2=sensitivity;
specificityNN2=specificity;
accuracyNN2=accuracy;
groupOrder=stats2.groupOrder;
gg=string(groupOrder);
go=strjoin([gg(1,:), gg(2,:)],',');
gg=num2str(specificity);
sp=horzcat(gg(1,:),'   ', gg(2,:));
gg=num2str(sensitivity);
se=horzcat(gg(1,:),'   ', gg(2,:));
gg=100*trace(C)/sum(C(:)); %accuracy
sa=num2str(gg);
Ztest=categorical(Ytest);
Zpred=categorical(y);
fc=fc+1;
hFig(fc) = figure('Position', [0 0 screenWidth screenHeight],'visible','off');
name= {['Figure 4.1.7, Neural Network Classificaton, 3 layers with 5 neurons each'],['Accuracy =', sa, '%','  Group Class ID Order =',char(go)],['  Sensitivity =',se,'   Specificity =',sp]};
plotconfusion(Ztest,Zpred',name)
saveas(hFig(fc),strjoin([FigureDirectory,'/Figure 4.1.7 - Neural Network Classification -3 layers, 5 neurons- Confusion Matrix.jpg'],''))
close() 
save('NN2.mat','net2')

%% HW4 - Problem 1 - Part 3
%% New Patient Data
ClumpThickness = 0.2;
UniformityofCellSize = 0.7;
UniformityofCellShape = 0.5;
MarginalAdhesion = 1;
SingleEpithelialCellSize = 0.5;
BareNuclei = 0.4;
BlandChromatin = 0.7;
NormalNucleoli = 0.7;
Mitosis=1;
NewPatient = [ClumpThickness,UniformityofCellSize,...
    UniformityofCellShape, MarginalAdhesion,...
    SingleEpithelialCellSize, BareNuclei,...
    BlandChromatin, NormalNucleoli,...
    Mitosis];

% Random Forest - Probability
[YnewPatient_RF,Score_newPatient_RF]=predict(RF,NewPatient)
RF_Probability_Benign = Score_newPatient_RF(1); % The probability of benign
RF_Probability_Malignant = Score_newPatient_RF(2); % The probability of malignant

% Neural Network - 1 hidden layer with 10 neurons
Score_newPatient_NN1 = net(NewPatient');
NN1_Malignant = vec2ind(Score_newPatient_NN1); % The score of malignant

% Neural Network - 3 hidden layers with 5 neurons each
Score_newPatient_NN2 = net2(NewPatient');
NN2_Malignant = vec2ind(Score_newPatient_NN2); % The score of malignant

NewPatientOutputFile(2,1)={string('Benign')};
NewPatientOutputFile(3,1)={string('Malignant')};
NewPatientOutputFile(1,2)={string('Random Forest')}
NewPatientOutputFile(2,3)={string('Neural Network 1 hidden layer with 10 neurons')}
NewPatientOutputFile(2,4)={string('Neural Network 3 hidden layers with 5 neurons each')}

NewPatientOutputFile(2,2)={string(RF_Probability_Benign)}
NewPatientOutputFile(3,2)={string(RF_Probability_Malignant)}


NewPatientOutputFile(3,3)={string(NN1_Malignant)}


NewPatientOutputFile(3,4)={string(NN2_Malignant)}
NewPatientOutputFile=(NewPatientOutputFile);
filename=strjoin([FigureDirectory,'/NewPatientOutput.xlsx'],'');
writecell(NewPatientOutputFile,filename,'Sheet',1,'Range','A1');

