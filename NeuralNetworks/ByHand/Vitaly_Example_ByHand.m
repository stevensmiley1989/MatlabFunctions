%% Example 1: Find a regression function for P2 = 7.6.*P1+8.1+5*rand;
% Lets start by considering 2 points that are related by: P2 = 7.6*P1+8.1
close all
clear all
clc

P1 = 1:20;
for i = 1:20
    P2(i) = 7.6.*P1(i)+8.1+5*rand;
end

scatter(P1,P2)

net = fitnet([1]); 
%% how to adjust transferFcn at a specific layer
%net.layers{2}.transferFcn = 'tansig';
rng('default');
net = train(net, P1,P2);
view(net)
y = sim(net,P1);

figure, plot(P1,P2,'o',P1,y)
xlabel('P1')
ylabel('P2')

% %% Compute the performance of the network - just find RMSE
perf = perform(net, y,P2) %Matlab's NN performance function

yhat = P2; %What if we want to compute it ourselves ... just find RSME
mean((y - yhat).^2)   % Mean Squared Error


% %% Feed-forward process by hand: 

%In order to do the feed-forward by ourselves, we need to know how Matlab
%processed the data before and after the network: 
net.inputs{1}.processFcns
net.inputs{1}.processSettings
net.outputs{2}.processFcns
net.outputs{2}.processSettings

% Also, we need to know what kind of activation functions were used: 
net.layers{1}.transferFcn
net.layers{2}.transferFcn

[TestP1n,TestP1s] = mapminmax(P1);
[TestP2n,TestP2s] = mapminmax(P2);

% if one node in hidden layer
for i = 1:20
    TestP1 = P1(i);
    TestP1a = TestP1n(i);
    yTst(i) = sim(net,TestP1);

    b1 = net.b{1};
    w1 = net.IW{1,1};
    
    b2 = net.b{2};
    w2 = net.LW{2,1};
    

    z = TestP1a*w1+b1; %similar to n1 [SUM function 1] for Inputs, Layer 1
    
    y2 = feval('tansig',z); % similar to a1 [Activation Function 1] for Inputs, Layer 1

    z2 = y2*w2+b2; %similar to n2 [SUM function 2] for Layer 2
    
    y3(i) = feval('purelin',z2); %similar to a2 for Layer 2
end

yfinal = mapminmax('reverse',y3,TestP2s); %maps the output to the actual output format

figure, scatter(yTst,yfinal)
xlabel('Y from Sim Command')
ylabel('Y from our own FF net')


getweights=getwb(net)

LinearFit(yTst,yfinal,'yTst','yfinal',4)

