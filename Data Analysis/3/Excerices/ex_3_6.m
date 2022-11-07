function ex_3_6()
    n = 10;
    X = normrnd(0,1,n,1);
    % uncomment for c)
    % X = exp(X)

    B = 1000;

    bs_mu = zeros(B, 1);
    bs_se = zeros(B, 1);

    for i=1:B
        sample = randsample(X, 10, true);
        bs_mu(i) = mean(sample);
        bs_se(i) = sqrt(var(sample));
    end

    subplot(2, 1, 1);
    hist(bs_mu, 50);
    hold on;
    xline(mean(X));

    subplot(2, 1, 2);
    hist(bs_se, 50);
    hold on;
    xline(var(X));
end