
function [sol lb_list ub_list iter] = ex_1_4(f, f_prime, lower_bound, upper_bound, lambda, max_iter)
    iter = 0; 
    lb_list = []; 
    ub_list = []; 

    n = ceil((log(lambda)-log(upper_bound-lower_bound))/log(1/2));

    x = (lower_bound + upper_bound)/2;
    f_prime;

    while iter <= n
        iter = iter + 1; 
        x = (lower_bound + upper_bound)/2;

        if (f_prime(x) > 0)
            upper_bound = x;
        elseif (f_prime(x) < 0)
            lower_bound = x;
        else
            break;
        end

        lb_list = [lb_list lower_bound]; 
        ub_list = [ub_list upper_bound]; 
    end

    sol = (lower_bound + upper_bound) / 2; 
    
    iter = n;

