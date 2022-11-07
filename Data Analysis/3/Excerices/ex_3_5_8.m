function ex_3_7()
M = 1000;
n = 10;
B = 100;
a = 0.05;
bins = M/10;

X = normrnd(0, 1, n, M);
X = X.^2;

bs_var = zeros(B, M);
ci_par = zeros(2, M);
ci_bs = zeros(2, M);
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
    
    bs_sorted = sort(bs_mu(:,m));

    k = floor((B + 1)*a/2);

    lo_bs = bs_sorted(k);
    hi_bs = bs_sorted(B+1-k);

    ci_bs(1, m) = lo_bs;
    ci_bs(2, m) = hi_bs;
end 

% parametric
subplot(2, 2, 1);
hist(ci_par(1,:), bins);
title('Parametric low bound');
hold on;

subplot(2, 2, 2);
hist(ci_par(2,:), bins);
title('Parametric high bound');
hold on;

% bootstrap
subplot(2, 2, 3);
hist(ci_bs(1,:), bins);
title('Bootstrap low bound');
hold on;

subplot(2, 2, 4);
hist(ci_bs(2,:), bins);
title('Bootstrap high bound');
hold on;

end 