% 1.
% log L = -l * n + (Sum x_i) log l - Sum log (x_i!)
% d log L / d l = -n + (Sum x_i) / l = 0 
% QED

% 2.

M = 50;
n = 7;
lambda = 4;
S = [];

for sample=1:M
    for i=1:n
        S(sample, i) = poissrnd(lambda);
    end
end

S = S';

mu_lambda = sum(S)/n;
mu_lambda_avg = sum(mu_lambda)/M
hist(mu_lambda, 300);