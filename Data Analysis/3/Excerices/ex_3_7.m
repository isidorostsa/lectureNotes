function ex_3_7()
M = 100;
n = 10;
B = 1000;

X = normnd(0, 1, n, M);

bs_mu = zeros(B, M);
conf_ints = zeros(2, M);

bs_var = zeros(B, M);

for m=1:M
    [h p ci] = ttest(X(:,m));
    lo = ci(1);
    hi = ci(2);
    
    conf_ints(1, m) = lo;
    conf_ints(2, m) = hi;

    % bootstrap method
    for b=1:B
        sample = randsample(X(:,m), n, true);
        bs_mu(b, m) = mean(sample)
    end
end 
