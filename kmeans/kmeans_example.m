clc;
clear all;
close all;

%%% Homework 3 - Problem 2 - BioE5020 - Steven Smiley
%% Part A
%% Code Objective 0:  Import Data
load('Prob2Dat.mat')
[m_RP,n_RP] = size(RelProtien); %collect the size of the protein data
[m_St,n_St] = size(Stage); %collect the size of the stage data
[m_H, n_H] = size(Header); % collect the size of the Header data


%% Code Objective 1:  Look at Data
%There are  4 groups of 50 with 3 different proteins each
figure
boxplot(RelProtien,Header)
title({'Figure-3.2a.1.1';'Look at the Data first';'Boxplot of Raw Data'});
xlabel('Protein')
ylabel('values')

figure 
scatter3(RelProtien(:,1),RelProtien(:,2),RelProtien(:,3))
title({'Figure-3.2a.1.2';'Look at the Data first';'3D Scatter of Raw Data'});
xlabel('Protein 1')
ylabel('Protien 2')
zlabel('Protien 3')


%% Code Objective 3:  Cluster Analysis - Proteins
k=4; % number of clusters tested
for i=k:k
rng(1); % For reproducibility
[idx,Centers] = kmeans(RelProtien,i,'Distance','sqeuclidean');
x1 = min(RelProtien(:,1)):0.01:max(RelProtien(:,1));
x2 = min(RelProtien(:,2)):0.01:max(RelProtien(:,2));
figure
subplot(1,2,1)
hold on;
scatter(RelProtien(:,1),RelProtien(:,2),[],idx)
hold on
plot(Centers(:,1),Centers(:,2),'kx',...
    'MarkerSize',15,'LineWidth',3)
legend('Data', 'Centroids','Location','East')
hold on;
title ({['Figure-3.2a.3.1'];['k=',num2str(k)];['Scatter Plot'];['Proteins cluster analysis']});
xlabel (Header(1));
ylabel (Header(2)); 
subplot(1,2,2)
[silh,h] = silhouette(RelProtien,idx,'sqeuclidean');
avgsilh=mean(silh);
title ({['Figure-3.2a.3.2'];['k=',num2str(k)];['Average Silh = ',num2str(avgsilh)];['Silhouette Plot'];['Proteins cluster analysis']});
%idx2
idxx=idx;
[mid,nid]=size(idx);
%
aa=1;
bb=50;
cc=100;
dd=150;
ee=200;
for ii=aa:ee
    if idxx(ii) == mode(idx(aa:bb));
        idxx(ii) = mode(Stage(aa:bb));
    elseif idxx(ii) == mode(idx(bb:cc));
        idxx(ii) = mode(Stage(bb:cc));
    elseif idxx(ii) == mode(idx(cc:dd));
        idxx(ii) = mode(Stage(cc:dd));
    elseif idxx(ii) == mode(idx(dd:ee));
        idxx(ii) = mode(Stage(dd:ee));
    end
end

count1b=0;
for ii=aa:bb
    if idxx(ii)==mode(Stage(aa:bb));
    count1b=count1b+1;
    else
    end
end
percentStagecorrect_protein(1)=100.*(count1b/(50.));
count2b=0;
for ii=bb:cc
    if idxx(ii)==mode(Stage(bb:cc));
    count2b=count2b+1;
    else
    end
end
percentStagecorrect_protein(2)=100.*(count2b/(50.));
count3b=0;
for ii=cc:dd
    if idxx(ii)==mode(Stage(cc:dd));
    count3b=count3b+1;
    else
    end
end
percentStagecorrect_protein(3)=100.*(count3b/(50.));
count4b=0;
for ii=dd:ee
    if idxx(ii)==mode(Stage(dd:ee));
    count4b=count4b+1;
    else
    end
end
percentStagecorrect_protein(4)=100.*(count4b/(50.));
percentTotalcorrect_protein=mean(percentStagecorrect_protein);
end



