function [data_mean,data_diff,md,sd] = blandaltman(Yraw,Ycalc,Yname,i)
%blandaltman(Yn(:,i),Y1,[strip(Y1_name),' vs. ',strip(Yn_name(i,:))],fc);

data_mean = mean([Yraw,Ycalc],2);  % Mean of values from each instrument 
data_diff = Yraw - Ycalc;              % Difference between data from each instrument
md = mean(data_diff);               % Mean of difference between instruments 
sd = std(data_diff);                % Std dev of difference between instruments 
plot(data_mean,data_diff,'ok','MarkerSize',5,'LineWidth',2,'MarkerFaceColor','k')   % Bland Altman plot
hold on,plot(data_mean,md*ones(1,length(data_mean)),'-r')             % Mean difference line  
plot(data_mean,2*sd*ones(1,length(data_mean)),'-b')                   % Mean plus 2*SD line  
plot(data_mean,-2*sd*ones(1,length(data_mean)),'-g')                  % Mean minus 2*SD line   
grid on
txt2 = {['Figure ', num2str(i),'B'],['Bland Altman Plot ', Yname]};
title(txt2,'FontSize',8)
xlabel(['Mean of two measures for - ',Yname],'FontSize',8)
ylabel(['Difference between two measures - ',Yname],'FontSize',8)
legend('bland altman','Mean','+2std','-2std')
end
