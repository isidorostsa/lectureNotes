function ex_3_7()
M = 100;
n = 10;
B = 1000;
a = 0.05;

X = normnd(0, 1, n, M);

bs_mu = zeros(B, M);
ci_par = zeros(2, M);
ci_bs = zeros(2, M);

bs_var = zeros(B, M);

for m=1:M
    [h p ci] = ttest(X(:,m));
    lo_par = ci(1);
    hi_par = ci(2);
    
    ci_par(1, m) = lo_par;
    ci_par(2, m) = hi_par;

    % bootstrap method
    for b=1:B
        sample = randsample(X(:,m), n, true);
        bs_mu(b, m) = mean(sample);
    end
    
    lo_bs = sort(bs_mu)()

end 

end 
