%% Example : Look at the impact of splitting data on regression in NN

clc;
clear all;
close all;

rng('default');

P = [0 1 2 3 4 5 6 7 8 9 10];
T = [0 1 2 3 4 3 2 1 2 3 4];

scatter(P,T)
net = fitnet([10]); %could also use feedforward net
view(net)

% What if we train the model using all our data
net.divideParam.trainRatio = 100/100;
net.divideParam.valRatio = 0/100;
net.divideParam.testRatio = 0/100;

[net,tr] = train(net,P,T);
Y = sim(net,P);
figure, plot(P,T,'o',P,Y)

figure, plotperform(tr)

% What if we now witheld some of the data for validation and testing
net2 = fitnet([10]);

net.divideParam.trainRatio = 60/100;
net2.divideParam.valRatio = 25/100;
net2.divideParam.testRatio = 15/100;

[net2,tr2] = train(net2,P,T);
Y2 = sim(net2,P);
figure, plot(P,T,'o',P,Y2) %The fit is not very good now

figure, plotperform(tr2) %Notice that the error for our validation and testing sets is really bad