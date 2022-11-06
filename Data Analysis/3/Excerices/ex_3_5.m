function ex_3_5() 
    table = readtable('eruption.dat')

    % waiting and duration 
    w89 = table2array(table(:,1));
    d89 = table2array(table(:,2));
    w06 = table2array(table(:,3));

    n = size(w1989, 1);
    
    % var normalizes with n-1 by default, so it gives s

    sigma_sq_w89 = var(w89);

    