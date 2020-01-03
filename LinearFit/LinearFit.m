function [R_table,R_sq_table,P_V_table] = LinearFit(Y1,Yn,Y1_name,Yn_name,fc)
%  fc=fc+1; %figure counter
%  [R_table_f(i),R_sq_table_f(i),P_V_table_f(i)] = LinearFit(Y1,Yn(:,i),Y1_name,Yn_name(i,:),fc);

%% Function Objective 1: Create linear fit 
figure(fc) % Creats a new figure each time the loop starts
scatter(Yn,Y1,8,'filled') % what is subplotted
%% Function Objective 1.a: linear fit
coeffs = polyfit(Yn,Y1, 1); %polyfit looks for best fit coefficients of data
% % Get fitted values
 fittedX = linspace(min(Yn), max(Yn), 200);
 fittedY = polyval(coeffs, fittedX);
% % Plot the fitted line
% R^2
mdl = fitlm(Yn,Y1); %fitlm gets R^2 & p values from data
R_sq=mdl.Rsquared.Ordinary;
R_sq_table=R_sq;
R_table=sqrt(R_sq);
P_v=mdl.Coefficients.pValue(2);
P_V_table=P_v;
 hold on;
 plot(fittedX, fittedY, 'r-', 'LineWidth', 3);
 hold on;
 txt = {['Figure ', num2str(fc)];[strip(Yn_name)];['m = ',num2str(coeffs(1)), '  b = ', num2str(coeffs(2))];['R = ',num2str(sqrt(R_sq)), '  P = ',num2str(P_v),' R^2= ',num2str(R_sq)]};
 xlabel(Yn_name)
 ylabel(Y1_name)
 title(txt,'FontSize',8)
 legend(Yn_name,'Correlation')
end

