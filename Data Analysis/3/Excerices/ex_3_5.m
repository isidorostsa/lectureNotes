function ex_3_5() 
    table = readtable('eruption.dat')

    % waiting and duration 
    w89 = table2array(table(:,1));
    d89 = table2array(table(:,2));
    w06 = table2array(table(:,3));

    n = size(w89, 1);
    
    % var normalizes with n-1 by default, so it gives s

    sigma_sq_w89 = var(w89)

    lo = (n-1)*sigma_sq_w89/(chi2inv(0.975, n-1))
    hi = (n-1)*sigma_sq_w89/(chi2inv(0.025, n-1))

    if (lo < sigma_sq_w89 &)