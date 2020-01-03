clc;
clear all;
close all;

% Important Note: I an effort to confuse everyone as much as possible,
% Matlab basically has 3 functions that all do the same thing: 
% feedforward is the general function for: (1) 'fitnet' for regression and
% 'patternnet' for classification. Why? Because they hate puppies, 
% that's why! 

% Another Note: When defining the Y array for classification in RF, you
% simply assigned integers that corresponded to the class. So, if you had a
% problem with 4 classes, you each observation of Y had some number between
% 1 and 4. This is kind of different in Neural Nets because it's difficult
% to train an output activation function to output 4 integers. So, we end
% up assigning 4 output nodes, each having possible values 1 or 0. 

%% The classifier problem RF could not handle 
load XYDataClassification 
% load XYData_Spiral


% We have 100 numbers of a and b data, which we use to make the input matrix X
X = [a,b];
N = length(X(:,1));

% Create an output classifyer, Y - which has 1 for any number where X(:,1) > 0.5
rows = find(X(:,1) < X(:,2));
Y(:,1) = zeros(N,1);
Y(:,2) = ones(N,1);
Y(rows,1) = 1;
Y(rows,2) = 0;

for i = 1:N
    if Y(i) == 0
        Color(i,:) = [1 0 0]; %If Class = 0, then red dot
    else
        Color(i,:) = [0 0 0]; %If Class = 1, then black dot
    end
end

scatter(X(:,1),X(:,2),25,Color)

% rng('default');
net = patternnet([1 1]); %This assigns one hidden layer with 3 nodes
net = train(net,X',Y'); %This trains the network
view(net); %This views the network

figure(1)
plotpc(net.IW{1},net.b{1}); %Plot Classification Line
Weights = getwb(net)

x_eval = linspace(0,1,50);
y_eval = linspace(0,1,50);
[Xe,Ye] = meshgrid(x_eval,y_eval);

count = 1;
for i = 1:50
    for j = 1:50
        Xtest(count,1) = x_eval(i);
        Xtest(count,2) = x_eval(j);
        count = count+1;
    end
end

y_hat = net(Xtest');
C = vec2ind(y_hat);

figure, scatter(Xtest(:,1),Xtest(:,2),25,C,'filled')