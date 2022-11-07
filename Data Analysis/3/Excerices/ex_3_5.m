function ex_3_5() 
    table = readtable('eruption.dat')

    % waiting and duration 
    w89 = table2array(table(:,1));
    d89 = table2array(table(:,2));
    w06 = table2array(table(:,3));

    n = size(w89, 1);
    
    % var normalizes with n-1 by default, so it gives s^2

    sigma2_w89 = var(w89)

    lo = (n-1)*sigma2_w89/(chi2inv(0.975, n-1))
    hi = (n-1)*sigma2_w89/(chi2inv(0.025, n-1))

    if (lo < sigma2_w89 & sigma2_w89 < hi)
        sprintf("The 95 confidence interval is:\n[%0.5g, %0.5g]", lo, hi)
    end 

    % H0: sigma2u = 10
    