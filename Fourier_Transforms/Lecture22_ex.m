clear all
close all

load EX2DATA.mat


fs = 100; %Hz
T = 1; 
dt = 1/fs;

t = 0:dt:T-dt;

%% Just visualize
for i = 1:200
    if C(i) == 1
        Color = [1 0 0];
        Cnn(1,i) = 1;
        Cnn(2,i) = 0;
    else
        Color = [0 0 1];
        Cnn(1,i) = 0; 
        Cnn(2,i) = 1;
    end
     
    plot(t,Y(:,i),'Color',Color)
    hold on
end
figure
%% Lets do some feature extraction
for i = 1:200
    Coef1(:,i) = FFT_Function(Y(:,i));
	
    Coef2(1,i) = max(Y(:,i));
    xax(i) = i;
    yax(i) = Coef2(1,i);
end
Coef = vertcat(Coef1,Coef2);


figure, scatter(xax,yax,C)

%% Let's try PCA
[coeff,score,latent,tstat,explained] = pca(Coef');
figure, scatter(score(:,1),score(:,2),[],C,'filled')
xlabel('score(:,1)')
ylabel('score(:,2)')

%% Nerual Network with harmonics
% net = patternnet([67]); %This assigns one hidden layer with 3 nodes
% net2 = train(net,Coef,Cnn); %This trains the network

% %% Nerual Network with raw data
net = patternnet([50 25]); %This assigns one hidden layer with 3 nodes
net2 = train(net,Y,Cnn); %This trains the network