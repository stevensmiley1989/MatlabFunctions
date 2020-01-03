function [h_f,p_f,h_t,p_t,ttest_type] = ttest_unpaired_sjs(Y1,Y2)
%[h_f(i,:),p_f(i,:),h_t(i,:),p_t(i,:),ttest_type(i,:)]=ttests_unpaired_sjs(T(:,i+1),T(:,1));

% F-test for equal or unequal variance
[h_f,p_f]=vartest2(Y1,Y2);

% T-test based on F-test
if h_f == 1
    [h_t,p_t]=ttest2(Y1,Y2,'Vartype','unequal');
    ttest_type={'Unpaired, Unequal Variance, T-test'};
else
    [h_t,p_t]=ttest2(Y1,Y2);
    ttest_type={'Unpaired, Equal Variance, T-test'};
end
end