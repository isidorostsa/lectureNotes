%1.
% log L = n log l - l Sum x_i 
% d log L / d l = n / l - Sum x_i = 0 
% l = 1/x_bar

%2.
function mu_lambda_avg = ex_3_2 ()
    M = 5000;
    n = 7;
    lambda = 4;
   
    % M columns of n rows
    S = exprnd(1/lambda, n, M);

    % sum(S) returns vector of the sums of columns
    mu_lambda = arrayfun(@(x) n/x, sum(S));

    mu_lambda_avg = sum(mu_lambda)/M
    hist(mu_lambda, 500);
end
% for small n it is biased 
    