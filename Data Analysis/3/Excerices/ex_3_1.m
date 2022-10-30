% 1.
% log L = -l * n + (Sum x_i) log l - Sum log (x_i!)
% d log L / d l = -n + (Sum x_i) / l = 0 
% QED

% 2.

M = 50;
n = 70;
lambda = 4;

for sample=1:M
    for i=1:n
        S(sample, i) = poissrnd(lambda);
    end
end

for sample=1:M
    ac = 0
    for i=1:n
        ac = ac + S(sample, i)
    end
    mu_lambda(sample) = ac/n;
end
%mu_lambda = sum(S')/n;
mu_lambda
mu_lambda_avg = sum(mu_lambda)/M
hist(mu_lambda, 300);
 % no because the estimator is biased 