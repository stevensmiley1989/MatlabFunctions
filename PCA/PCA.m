clc
clear all
close all

%%%Steven Smiley - BioE5020 - Homework 2 - Problem 3
%% Code Objective 0: Import data from excel 
A= readtable('RawData_HW2Pr3_new.xlsx'); 
%Hematocrit; Viscocity (cP); mPAP; MPA Vorticity (1/s); RPA Vorticity
%(1/s); Helicity (m/s2)
%
A= table2array (A);
[n,m]=size(A);
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
vbls={'Hematocrit','Viscocity','MPA Vorticity','RPA Vorticity ','HELICITY'};
boxplot(An,vbls)
txt = {'Figure 2-3A1';'Boxplot of categories for verification of normalized data'};
title(txt,'FontSize',8)


[coeff, score, latent, tsquared, explain] =pca(An); %PCA of normalized covariance matrix for PCA

%Total Variance & Variance
TotVar=100.*(cumsum(latent)./sum(latent));
vbls2={'PC1','PC1+PC2','PC1+PC2+PC3','PC1+PC2+PC3+PC4','PC1+PC2+PC3+PC4+PC5'};
figure(7),scatter(1:m,TotVar,'bo');
txt = {'Figure 2-3A5';'% Variance of Principal Components'};
title(txt,'FontSize',8)
text(1:m,TotVar,vbls2,'Fontsize',5);
ylabel('% Variance')
xlabel('Total # of Principal Components added together')
hold on;
plot(1:m,TotVar);


%the status vector (here zero or one)
class_pt(1:5)=0; %Control
class_pt(6:21)=1; %PH

figure('Color', 'w');
hbi = biplot(coeff(:,1:2),'scores',score(:,1:2),'varlabels',vbls,...
    'ObsLabels',num2str((1:size(score,1))'));
txt = {'Figure 2-3A2';'Biplot'};
title(txt,'FontSize',8)


for ii = 1:length(hbi)
    userdata = get(hbi(ii), 'UserData');
    if ~isempty(userdata)
        if class_pt(userdata) == 0
            set(hbi(ii), 'Color', 'b');

        elseif class_pt(userdata) == 1
            set(hbi(ii), 'Color', 'r');
        end

    end
end
hold on;

%% Code Objective 1, add data for new patient
% % Part b
% %Hema=42.6%; Visc.=3.91cP; Vortic MPA=6890; RPA Vorticy=110; Helicity=19
NP=[42.6;3.91;6890.;110.;19.]';
[o,p]=size(NP);
%normalize the new patient data to the score data, which used zscore.
for i=1:o
    for j=1:m
        NP(i,j)=(NP(i,j)-mean(A(:,j)))/std(A(:,j));
    end
end

%populate a new score matrix with old score data for first n rows
%add new patient transformed score to n+1 row.
scorenew=(NP-mean(An))*coeff;
scorenew(n+1,:)=scorenew(1,:); %adds new patient's new score to n+1 row
for i=1:n
    scorenew(i,:)=score(i,:); %populates new score matrix with old score data for first n rows
end

hold on;

hbi2 = biplot(coeff(:,1:2),'scores',scorenew(:,1:2),'varlabels',vbls,...
    'ObsLabels',num2str((1:size(scorenew,1))'));

%the status vector (here zero or one)
class_pt(1:5)=0; %Control
class_pt(6:21)=1; %PH
class_pt(22:22)=2; %NewData

for ii = 1:length(hbi2)
    userdata = get(hbi2(ii), 'UserData');
    if ~isempty(userdata)
        if class_pt(userdata) == 2
            set(hbi2(ii), 'Color', 'g');

        elseif class_pt(userdata) == 1
            set(hbi2(ii), 'Color', 'r');
            
        elseif class_pt(userdata) == 0
            set(hbi2(ii), 'Color', 'b');
        end

    end
end

%% Code Objective 2
%% ROC Analysis of principal components (PC1 & PC2) vs. known disease state (PH or control)
%Add column to scores, identifies which observation was PH(1) or control(0)
for i=1:5
    score(i,6)=0; %control
end
for i=6:21
    score(i,6)=1; % PH
end

%PC1 vs. (PH [1] or Control [0])
[Y(:,1),Y(:,2),Y(:,3),AUC(1)] = perfcurve(score(:,6),score(:,1),[1]);
Y(:,4)=sqrt(Y(:,1).^2+(1.-Y(:,2)).^2);
figure(3)
hold on;
plot(Y(:,1),Y(:,2))
[min_dist_Y(1),I_Y(1)]=min(Y(:,4)); % minimum d, index of d
cutoff(1)=Y(I_Y(1),3);  % cutoff 
cutoff(2)=Y(I_Y(1),1); % cutoff (1-specificity) or x axis
cutoff(3)=Y(I_Y(1),2); % cutoff sensitivity or y axis 
plot(cutoff(2),cutoff(3),'r*')

%PC2 vs. (PH [1] or Control [0])
[Y2(:,1),Y2(:,2),Y2(:,3),AUC(2)] = perfcurve(score(:,6),score(:,2),[0]);
Y2(:,4)=sqrt(Y2(:,1).^2+(1.-Y2(:,2)).^2);
hold on;
plot(Y2(:,1),Y2(:,2))
[min_dist_Y2(1),I_Y2(1)]=min(Y2(:,4)); % minimum d, index of d
cutoff(4)=Y2(I_Y2(1),3);  % cutoff 
cutoff(5)=Y2(I_Y2(1),1); % cutoff (1-specificity) or x axis
cutoff(6)=Y2(I_Y2(1),2); % cutoff sensitivity or y axis 
plot(cutoff(5),cutoff(6),'r*')
legend('PC1 ROC','PC1 cutoff','PC2 ROC','PC2 cutoff')
txt = {['Figure 2-3A3'];['PC1 for ROC'];['PC1 cutoff = ',num2str(cutoff(1))];['PC1 cutoff [1-specificity] = ',num2str(cutoff(2))];['PC1 cutoff sensitivity = ',num2str(cutoff(3))];[ '  Minimum Distance for PC1 to top left corner = ', num2str(min_dist_Y)];min_dist_Y;['PC2 cutoff = ',num2str(cutoff(4))];['PC2 cutoff [1-specificity] = ',num2str(cutoff(5))];['PC2 cutoff sensitivity = ',num2str(cutoff(6))];[ '  Minimum Distance for PC2 to top left corner = ', num2str(min_dist_Y2)];min_dist_Y2};
title(txt,'FontSize',8)
xlabel('False positive rate [1-Specificity]') 
ylabel('True positive rate [Sensitivity]')

%% Code Objective 3:
%% Scatter plot of new patient (green) relative to score data on score data's principal components.
figure(4)
scatter(scorenew(1:5,1),scorenew(1:5,2),'filled','b')
hold on
scatter(scorenew(6:21,1),scorenew(6:21,2),'filled','r')
hold on
scatter(scorenew(22:22,1),scorenew(22:22,2),'filled','g')

legend('Control','PH','New Patient','PC1','PC2')
xL = xlim;
yL = ylim;
line([0 0], yL);  %x-axis
line(xL, [0 0]);  %y-axis

xlabel('PC1')
ylabel('PC2')
txt = {'Figure 2-3A4';'Scatter Plot of old Score & new data point in green'};
title(txt,'FontSize',8)

%% Code Objective 4: Import mPAPdata from excel 
B= readtable('P3_PA_Flow_Data.xlsx'); 
B= table2array (B);
[nB,mB]=size(B); 
%mPAP is column 3
T(:,2:6)=score(:,1:5); %PC1 for x-axis
T(:,1)=B(:,3); %mPAP for y-axis
m=2; %only plot PC1
headers=char('PC1','PC2','PC3','PC4','PC5');
%% Code Objective 5: Create linear fit & bland altman plots
for i=1:m-1
figure(i+5) % Creats a new figure each time the loop starts
subplot(1,2,1) % adds a subplot on the left to the figure
scatter(T(:,i+1),T(:,1),8,'filled') % what is subplotted
%% Code Objective 6.a: linear fit
coeffs = polyfit(T(:,i+1),T(:,1), 1); %polyfit looks for best fit coefficients of data
% % Get fitted values
 fittedX = linspace(min(T(:,i+1)), max(T(:,i+1)), 200);
 fittedY = polyval(coeffs, fittedX);
% % Plot the fitted line
% R^2
mdl = fitlm(T(:,i+1),T(:,1)); %fitlm gets R^2 & p values from data
R_sq=mdl.Rsquared.Ordinary;
R_sq_table(i)=R_sq;
P_v=mdl.Coefficients.pValue(2);
P_V_table(i)=P_v;
[hv(i),pv(i)]=vartest2(T(:,i+1),T(:,1));
if hv(i) == 1
    [hi(i),pi(i)]=ttest2(T(:,i+1),T(:,1),'Vartype','unequal');
else
    [hi(i),pi(i)]=ttest2(T(:,i+1),T(:,1));
end
 hold on;
 plot(fittedX, fittedY, 'r-', 'LineWidth', 3);
 hold on;
 txt = {['Figure 2-3C-', num2str(i),'A'];[strip(headers(i,:))];['m = ',num2str(coeffs(1)), '  b = ', num2str(coeffs(2))];['R = ',num2str(sqrt(R_sq)), '  P = ',num2str(P_v),' R^2= ',num2str(R_sq)]};
 xlabel(headers(i,:))
 ylabel('mPAP')
 title(txt,'FontSize',8)
 legend(headers(i,:),'Correlation')
subplot(1,2,2)
%% Code Objective 6.b: blandaltman plot
blandaltman(T(:,i+1),T(:,1),['mPAP vs. ',headers(i,:)],i);
hold off;
end
