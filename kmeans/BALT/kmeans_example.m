clc
clear all
close all

%%%Steven Smiley - BALT - kmeans
%% Code Objective 0: Import data from excel 
fc=0
columns=[5,12:15,17:19]
for iter=1:2
    clearvars -except fc iter columns
Axlsx= readtable('Batch-12-7-9-17-BALT_RegionPropsData.xlsx'); 
headers=Axlsx.Properties.VariableNames;
A= table2cell (Axlsx);
% only want certain columns
Ygold=A(:,[3]);
header_gold=headers(:,[3]);
A = A(:,columns);
%A = A(:,[15,18]);
headers=headers(:,columns);
headersOG=headers;
%headers=headers(:,[15,18]);
[n,m]=size(A);
A=cell2mat(A);
A=zscore(A); % normalize because different units

%% Do you want to feed it Raw Data or PCA Data?
answer = questdlg('Do you want to feed kmeans Raw Data or PCA Data?', ...
	'Steven Smiley''s Kmeans Algorithm', ...
	'RAW Data','PCA Data',[]);
% Handle response
switch answer
    case 'RAW Data'
        disp([answer ' Good sh*t!'])
        dessert = 1;
    case 'PCA Data'
        disp([answer ' F*ck yes!'])
        dessert = 3;
end

if dessert == 3
%% make PCA feed it
PCsize=size(headers,2);
clear headers
for pc=1:PCsize
    headers{pc}={['PC1:',num2str(pc)]}
end
headers=string(headers);
[coeff, score, latent, tsquared, explain] =pca(A); %PCA of normalized covariance matrix for PCA
A=score;
else
end
%%

Ygold=string(Ygold);

[m_RP,n_RP] = size(A); %collect the size of the feature extractd data
[m_St,n_St] = size(Ygold); %collect the size of the data
[m_H, n_H] = size(headers); % collect the size of the Header data


% fc=1
%% Code Objective 1:  Look at Data
fc=fc+1
figure(fc)
boxplot(A,headers)
title({'Figure-3.2a.1.1';'Look at the Data first';'Boxplot of Raw Data'});
xlabel('extracted features')
ylabel('values')



%% Code Objective 3:  Cluster Analysis - Extracted Features
fc=fc+1
k=2; % number of clusters tested
for i=k:k
rng(1); % For reproducibility
[idx,Centers] = kmeans(A,i,'Distance','sqeuclidean');
x1 = min(A(:,1)):0.01:max(A(:,1));
x2 = min(A(:,2)):0.01:max(A(:,2));
figure(fc)
subplot(1,2,1)
hold on;
scatter(A(:,1),A(:,2),[],idx)
hold on
plot(Centers(:,1),Centers(:,2),'kx',...
    'MarkerSize',15,'LineWidth',3)
legend('Data', 'Centroids','Location','East')
hold on;
title ({['Figure-3.2a.3.1'];['k=',num2str(k)];['Scatter Plot'];['Feature Extracted cluster analysis']});
xlabel (headers(1));
ylabel (headers(2)); 
subplot(1,2,2)
[silh,h] = silhouette(A,idx,'sqeuclidean');
avgsilh=mean(silh);
title ({['Figure-3.2a.3.2'];['k=',num2str(k)];['Average Silh = ',num2str(avgsilh)];['Silhouette Plot'];['Extracted Features cluster analysis']});
end
for z=1:n
    if Ygold(z) == 'No'
    class_pt(z)=1; % No
    else
    class_pt(z)=2; %Yes
    end
end
class_pt=class_pt';
class_pt=string(class_pt);
idx=string(idx);
%% RF: Confusion Matrix
C = confusionmat(class_pt,idx);

%% Confusion Matrix - Stats
stats = confusionmatStats(class_pt,idx);

%% Confusion Matrix - Stats - Specificity
specificity=stats.specificity ;
gg=num2str(specificity,3);
sp=num2str(strjoin(string(gg),'\, '));

%% Confusion Matrix - Stats - Sensitivity
sensitivity=stats.sensitivity;
gg=num2str(sensitivity,3);
se=num2str(strjoin(string(gg),'\, '));

%% Confusion Matrix - Stats - Accuracy
accuracy=stats.accuracy; 
gg=100*trace(C)/sum(C(:)); %accuracy
sa=num2str(gg,2);


%% Confusion Matrix - Stats - Group Order
if class(stats.groupOrder) == 'string'
groupOrder=num2str(strjoin(string((stats.groupOrder)),'\, '));
else
groupOrder=num2str(strjoin(string({(stats.groupOrder)}),'\, '));
end

Ztest=categorical(class_pt);
Zpred=categorical(idx);
%% Confusion Matrix Plot
screenSize = get(0,'screensize');
screenWidth = screenSize(3);
screenHeight = screenSize(4);
fc=fc+1;
hFig(fc) = figure('Position', [0 0 screenWidth screenHeight],'visible','on');
name= {['K-means classification:  ','Accuracy =', sa, '%'],...
    ['Group Order:  ',groupOrder],['Sensitivity =',se,'  Specificity =',sp]};
plotconfusion(Ztest,Zpred,name)

%% PCA extra 
if dessert == 3


% How to program zscore manually
% for i=1:n
%     for j=1:m
%         An(i,j)=(A(i,j)-mean(A(:,j)))/std(A(:,j));
%     end
% end
fc=fc+1
figure(fc)
vbls=headersOG;
vbls2=headers;
boxplot(A,vbls2)
txt = {'Figure 2-3A1';'Boxplot of categories for verification of normalized data'};
title(txt,'FontSize',8)

%Total Variance & Variance
TotVar=100.*(cumsum(latent)./sum(latent));
vbls2=headers;
fc=fc+1
figure(fc),scatter(1:m,TotVar,'bo');
txt = {'Figure 2-3A5';'% Variance of Principal Components'};
title(txt,'FontSize',8)
text(1:m,TotVar,vbls2,'Fontsize',5);
ylabel('% Variance')
xlabel('Total # of Principal Components added together')
hold on;
plot(1:m,TotVar);


%the status vector (here zero or one)
clear class_pt
for z=1:n
    if Ygold(z) == 'No'
    class_pt(z)=0; % No
    else
    class_pt(z)=1; %Yes
    end
end
class_pt=class_pt';
% Add the first header variables
%class_pt(m+1:m+n)=class_pt;
%class_pt(1:m)=3;

fc=fc+1
figure(fc)
%hbi = biplot(coeff(:,1:2),'scores',score(:,1:2),'varlabels',vbls,...
%    'ObsLabels',num2str((1:size(score,1))'));
hbi = biplot(coeff(:,1:2),'scores',score(:,1:2),'varlabels',vbls);
txt = {'Figure 2-3A2';'Biplot'};
title(txt,'FontSize',8)


for ii = 1:length(hbi)
    userdata = get(hbi(ii), 'UserData')
    if ~isempty(userdata)
        if class_pt(userdata) == 0
            set(hbi(ii), 'MarkerEdgeColor', 'g');
        elseif class_pt(userdata) == 1
            set(hbi(ii), 'MarkerEdgeColor', 'r');
        else 
            set(hbi(ii), 'MarkerEdgeColor', 'b');
        end

    end
end

fc=fc+1
figure(fc)

scatter(score(:,1),score(:,2),[],class_pt,'filled')
hold on;
Alim=axis();
hold on;
line([Alim(1) Alim(2)], [0 0]);  %x-axis
line([0 0], [Alim(3) Alim(4)]);  %y-axis
xlabel('Score PC1')
ylabel('Score PC2')
title('BALT PCA Analysis')
else
end
end