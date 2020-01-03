function [ht_p,pt_p,ttest_type] = ttests_paired_sjs(Y1,Y2,Y1_name,Y2_name,Y_label,fc)

% fc=fc+1
% Y_label='RV Wall Thickness (mm)';
% [ht_p,pt_p,ttest_type] = ttests_paired_sjs(T(:,1),T(:,3),'PH 7 wk','PH 1 wk',Y_label,fc)


%% Function Objective 1:  Paired T-test between time point 1 (Y1) an time point 2 (Y2)
[ht_p,pt_p]=ttest(Y1,Y2); %Paired T-Test
ttest_type={'Paired T-Test'};
%% Function Objective 2:  Boxplot
figure(fc), boxplot([Y1,Y2],'Labels',{Y1_name,Y2_name})
ylabel(Y_label)
titlelabel2='T-Test, paired';
title({['Figure -',num2str(fc)],['Boxplot'],[titlelabel2],['p = ',num2str(pt_p)]})
end
