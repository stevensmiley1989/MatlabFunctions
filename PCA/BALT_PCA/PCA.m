clc
clear all
close all

%%%Steven Smiley - BALT - PCA
%% Code Objective 0: Import data from excel 
Axlsx= readtable('Batch-12-7-9-17-BALT_RegionPropsData.xlsx'); 
headers=Axlsx.Properties.VariableNames;
A= table2cell (Axlsx);
% only want certain columns
Ygold=A(:,[3]);
header_gold=headers(:,[3]);
%A = A(:,[5,12:15,17:19]);
A = A(:,[14,18]);
%headers=headers(:,[5,12:15,17:19]);
headers=headers(:,[14,18]);
PCsize=size(headers,2);
for pc=1:PCsize
    vbls2{pc}={['PC1:',num2str(pc)]}
end
[n,m]=size(A);
A=cell2mat(A);
Ygold=string(Ygold);
% Different units so use Correlation and not Covariance Matrix for PCA
% Thus, zscore is used
An=zscore(A);

% How to program zscore manually
for i=1:n
    for j=1:m
        An(i,j)=(A(i,j)-mean(A(:,j)))/std(A(:,j));
    end
end

figure(1)
vbls=headers;
boxplot(An,vbls)
txt = {'Figure 2-3A1';'Boxplot of categories for verification of normalized data'};
title(txt,'FontSize',8)


[coeff, score, latent, tsquared, explain] =pca(An); %PCA of normalized covariance matrix for PCA

%Total Variance & Variance
TotVar=100.*(cumsum(latent)./sum(latent));
%vbls2={'PC1','PC1+PC2','PC1+PC2+PC3','PC1+PC2+PC3+PC4','PC1+PC2+PC3+PC4+PC5','PC1:6','PC1:7','PC1:8'};
figure(7),scatter(1:m,TotVar,'bo');
txt = {'Figure 2-3A5';'% Variance of Principal Components'};
title(txt,'FontSize',8)
text(1:m,TotVar,vbls2,'Fontsize',5);
ylabel('% Variance')
xlabel('Total # of Principal Components added together')
hold on;
plot(1:m,TotVar);


%the status vector (here zero or one)
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

figure('Color', 'w');
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

figure(3)

scatter(score(:,1),score(:,2),[],class_pt,'filled')
hold on;
Alim=axis();
hold on;
line([Alim(1) Alim(2)], [0 0]);  %x-axis
line([0 0], [Alim(3) Alim(4)]);  %y-axis
xlabel('Score PC1')
ylabel('Score PC2')
title('BALT PCA Analysis')



