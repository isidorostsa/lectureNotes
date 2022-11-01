function ex_3_3()
    n = 5;
    M = 1000;
    
    lambda = 1/15;
    
    s = exprnd(1/lambda, n, M);
    
    cnt = 0;
    for sample=1:M
        1/lambda;
        cnt = cnt + ttest(s(:,sample), lambda);
    end
    cnt/M
end

% for n = 5 we get  0.442, for n = 100 we get 1
