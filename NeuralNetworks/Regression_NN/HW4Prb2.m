clc;
clear all;
close all;


%% Steven Smiley - Homework 4 - BioE5020 - Problem 2

%% Code Objective 1:  Import the Data
DATA = xlsread('P3. PA Flow Data.xlsx');


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

%% Code Objective 2:  Split the X from the Y(mPAP) out of the data
Ygold=DATA(:,3); %mPAP
Xtrain=DATA(:,[1,2,4,5,7]);
x=Xtrain';
t=Ygold;
rng('default')
%% Create Neural Network on Training Data
net = fitnet(1); %single
net.divideParam.trainRatio = 1; %train all data
net.divideParam.testRatio = 0; % dont test any of it
net.divideParam.valRatio = 0; % dont validate any of it
[net,tr] = train(net,x,t');

view(net)
y = sim(net,x);
y=y';



fc=3;
[R_table_f,R_sq_table_f,P_V_table_f] = LinearFit(Ygold,y,'Y Gold Truth [mPAP]','Y Predicted with Neural Network [mPAP]',fc);


fc=4;
subplot(1,2,2)
blandaltman(y,Ygold,['Y Predicted with Neural Network [mPAP] vs. Y Gold Truth [mPAP]'],fc);


%% Create Neural Network on Training Data
net = fitnet(10); %single
net.divideParam.trainRatio = 1; %train all data
net.divideParam.testRatio = 0; % dont test any of it
net.divideParam.valRatio = 0; % dont validate any of it
[net,tr] = train(net,x,t');

view(net)
y = sim(net,x);
y=y';



fc=5;
[R_table_f,R_sq_table_f,P_V_table_f] = LinearFit(Ygold,y,'Y Gold Truth [mPAP]','Y Predicted with Neural Network [mPAP]',fc);


fc=6;
subplot(1,2,2)
blandaltman(y,Ygold,['Y Predicted with Neural Network [mPAP] vs. Y Gold Truth [mPAP]'],fc);