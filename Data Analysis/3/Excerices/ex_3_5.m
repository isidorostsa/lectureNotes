function ex_3_5() 
    table = readtable('eruption.dat')

    w1989 = table2array(table(:,1));
    d1989 = table2array(table(:,2));
    w2006 = table2array(table(:,3));

    n = size(w1989, 2)
    