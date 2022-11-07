function ex_3_5() 
    table = readtable('eruption.dat')

    % waiting and duration 
    w89 = table2array(table(:,1));
    d89 = table2array(table(:,2));
    w06 = table2array(table(:,3));

    n = size(w89, 1);
    
    % var normalizes with n-1 by default, so it gives s^2

    sigma2_w89 = var(w89);
    lo_s2_w89 = (n-1)*sigma2_w89/(chi2inv(0.975, n-1));
    hi_s2_w89 = (n-1)*sigma2_w89/(chi2inv(0.025, n-1));
    sprintf("The 95 confidence interval of the standard deviation of the waiting period is:\n[%0.5g, %0.5g]", sqrt(lo_s2_w89), sqrt(hi_s2_w89))

    sigma2_d89 = var(d89);
    lo_s2_d89 = (n-1)*sigma2_d89/(chi2inv(0.975, n-1));
    hi_s2_d89 = (n-1)*sigma2_d89/(chi2inv(0.025, n-1));
    sprintf("The 95 confidence interval of the standard deviation of the duration is:\n[%0.5g, %0.5g]", sqrt(lo_s2_d89), sqrt(hi_s2_d89))

    [h p ci] = ttest(w89);
    sprintf("The 95 confidence interval of the mean of the waiting period is:\n[%0.5g, %0.5g]", ci(1), ci(2))
    
    [h p ci] = ttest(d89);
    sprintf("The 95 confidence interval of the mean of the duration is:\n[%0.5g, %0.5g]", ci(1), ci(2))
   

end

