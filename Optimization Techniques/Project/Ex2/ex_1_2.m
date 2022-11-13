% function implementing golden section method to find minimum 

function [sol lb_list ub_list iter] = ex_1_2(func, lower_bound, upper_bound, lambda, max_iter)
    gamma = (sqrt(5) - 1) / 2;

    lb_list = [];
    ub_list = [];

    iter = 0;

    x1 = lower_bound + (1 - gamma) * (upper_bound - lower_bound);
    x2 = lower_bound + gamma * (upper_bound - lower_bound);

    lb_list = [lb_list lower_bound];
    ub_list = [ub_list upper_bound];

    f_at_x1 = func(x1);
    f_at_x2 = func(x2);

    while (upper_bound - lower_bound) > lambda && iter < max_iter
        iter = iter + 1;

        if (f_at_x1 < f_at_x2)
            upper_bound = x2;
            x2 = x1;
            f_at_x2 = f_at_x1;
            x1 = lower_bound + (1 - gamma) * (upper_bound - lower_bound);
            f_at_x1 = func(x1);
        else
            lower_bound = x1;
            x1 = x2;
            f_at_x1 = f_at_x2;
            x2 = lower_bound + gamma * (upper_bound - lower_bound);
            f_at_x2 = func(x2);
        end

        lb_list = [lb_list lower_bound];
        ub_list = [ub_list upper_bound];

    end
    sol = (lower_bound + upper_bound) / 2;
end