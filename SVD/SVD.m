clc 
clear all
close all

%%%Steven Smiley - BioE5020 - Homework 2 - Problem 2
%% Code Objective 0: Import data from excel 
A= readtable('P2. SVD Data.xlsx'); %Px1,Px2,Qx1,Qx2 (mm)
A= table2array (A);
[n,m]=size(A);
P=A(:,1:2);
q=A(:,3:4);
scatter(P(:,1),P(:,2),'bo') %before
hold on;
scatter(q(:,1),q(:,2),'filled','ro') %after

%% Code Objective 1: Define the centroids of P & q
P_cnt(1,1)=0.; P_cnt(1,2)=0.; 
q_cnt(1,1)=0.; q_cnt(1,2)=0.;
for i=1:n
    P_cnt(1,1) = P(i,1)+P_cnt(1,1);
    P_cnt(1,2) = P(i,2)+P_cnt(1,2);
    q_cnt(1,1) = q(i,1)+q_cnt(1,1);
    q_cnt(1,2) = q(i,2)+q_cnt(1,2);
end
P_cnt(1,1)=P_cnt(1,1)/n; P_cnt(1,2)=P_cnt(1,2)/n; 
q_cnt(1,1)=q_cnt(1,1)/n; q_cnt(1,2)=q_cnt(1,2)/n;


%% Code Objective 2:  Remove any Translation
Pp(:,1)=P(:,1)-P_cnt(1,1); Pp(:,2)=P(:,2)-P_cnt(1,2);
qp(:,1)=q(:,1)-q_cnt(1,1); qp(:,2)=q(:,2)-q_cnt(1,2);

%% Code Objective 3:  Define [H]
H=0.;
for i=1:n
        H=Pp(i,:).*qp(i,:)'+H;
end

%% Code Objective 4:  Perform Single Value Decomposition (SVD)
[U,S,V]=svd(H);

%% Code Objective 5:  Gives you Rotation Matrix [R]
[R]=[V]*([U]'); %Rotation
alpha=-asind(R(2,1));

%% Code Objective 6:  Gives you Translation Matrix [T]
T=-[R]*P' + q'; %Translation

% Plot over q to show that R & T correctly rotated & translated respectively the P vectors to to q
qtest=(R*P'+T)';
hold on;
scatter(qtest(:,1),qtest(:,2),'go','linewidth',2)
legend({'P','q','qtest'});
title({'Figure 2-2a','P vs. q vs. qtest'});


%% Code Objective 7:  Gives you Error
%error = 0.;
TotalError=0.;
for i=1:n
    error(i)=(norm([R]*P(i,:)' + [T(:,i)] - q(i,:)')).^2;
    TotalError=error(i)+TotalError;
end






