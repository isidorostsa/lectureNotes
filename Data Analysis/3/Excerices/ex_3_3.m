function ex_3_3()
    n = 15;
    M = 1000;
    
    lambda = 15;
    
    s = exprnd(lambda, n, M);
    
    cnt = 0;
    for sample=1:M
        s(:, sample)
        1/lambda;
        cnt = cnt + ttest(s(:,sample)', 1/lambda);
    end
    cnt
end