clc;
clear all;
close all;

load DATA.mat


% The Y variable is PVRi
% We use the first 20 observations to train the dataset
Ytrain = DATA_RHC(1:20,:);
Xtrain = DAT_AllExpressed(1:20,:);

% We use the last 8 observations, which are not used in training, to see
% how well our algorythm works. 
Xtest = DAT_AllExpressed(21:28,:);
Ytest = DATA_RHC(21:28,:);

%% Create the decision tree
tree = fitrtree(Xtrain,Ytrain,'MinParentSize',5) %,'MaxNumSplits',3); %,'MinParentSize',5)%,'MaxNumSplits',7)
% % % % % Here are some things that can help you grow a deep or shallow tree
% MaxNumSplits ? The maximal number of branch node splits is MaxNumSplits per tree. Set a large value for MaxNumSplits to get a deep tree. The default is size(X,1) ? 1.
% MinLeafSize ? Each leaf has at least MinLeafSize observations. Set small values of MinLeafSize to get deep trees. The default is 1.
% MinParentSize ? Each branch node in the tree has at least MinParentSize observations. Set small values of MinParentSize to get deep trees. The default is 10

view(tree,'Mode','graph')

% Identify important variables
PreImp = predictorImportance(tree);
c = categorical(Target_AllExpressed);
bar(c, PreImp)

% Evaluate Trained Data
Y_hat0 = predict(tree,Xtrain);
figure, scatter(Y_hat0,Ytrain)
xlabel('Predicted Y from training Data')
ylabel('Actual training Y data')
blandaltman(Y_hat0,Ytrain,char('Evaluated Trained Data'),10) %Bland Altman plot shows we clearly overfit the data

% % Compare Tree with Data
Y_hat = predict(tree,Xtest);
figure, scatter(Y_hat,Ytest)
xlabel('Predicted Y from testing Data')
ylabel('Actual testing Y data')
blandaltman(Ytest,Y_hat,char('Compare Tree with Data'),11) %Bland Altman plot shows we clearly overfit the data
