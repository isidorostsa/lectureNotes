function ex_3_7()
M = 100;
n = 10;
X = norrnd(0, 1, n, M);

bs_mu = zeros(n, M);
bs_var = zeros(n, M);

for i=1:M
    bs_mu =         sample = randsample(X, 10, true);

    