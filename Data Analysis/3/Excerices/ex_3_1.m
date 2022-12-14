% 1.
% log L = -l * n + (Sum x_i) log l - Sum log (x_i!)
% d log L / d l = -n + (Sum x_i) / l = 0 
% QED

% 2.

function mu_lambda_avg = ex_3_1()
    M = 50;
    n = 7;
    lambda = 4;
   
    for sample=1:M
        for i=1:n
            S(sample, i) = poissrnd(lambda);
        end
    end

    S = S';

    mu_lambda = sum(S)/n;
    mu_lambda_avg = sum(mu_lambda)/M
    hist(mu_lambda, 300);
end