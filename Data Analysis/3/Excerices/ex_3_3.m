function ex_3_3()
    n = 5;
    M = 10;
    
    lambda = 1/15;
    
    s = exprnd(lambda, n, M);
    
    cnt = 0;
    for sample=1:M
        s(:,sample)
        cnt = cnt + ttest(s(:,sample), lambda);
    end
    cnt/M
end