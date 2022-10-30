% log L = n log l - l Sum x_i 
% d log L / d l = n / l - Sum x_i = 0 
% l = 1/mu


function mu_lambda_avg = ex_3_2 ()
    M = 5000;
    n = 7;
    lambda = 4;
   
    S = exprnd(lambda, n, M);

    mu_lambda = arrayfun(@(x) n/sum(x), S(,:));
    
    mu_lambda = arrayfun(@(x) n/x, sum(S));
    mu_lambda_avg = sum(mu_lambda)/M
    hist(mu_lambda, 500);
end