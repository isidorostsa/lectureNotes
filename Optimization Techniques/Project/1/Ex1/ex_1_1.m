function [sol lb_list ub_list iter] = ex_1_1(func, lower_bound, upper_bound, epsilon, limit_width, max_iterations)
    x1 = 0;
    x2 = 0;

    iter = 1;

    lb_list = [];
    ub_list = [];

    while upper_bound - lower_bound > limit_width && iter < max_iterations
        lb_list = [lb_list lower_bound];
        ub_list = [ub_list upper_bound];

        x1 = (upper_bound + lower_bound) / 2 - epsilon;
        x2 = (upper_bound + lower_bound) / 2 + epsilon;

        if func(x1) <= func(x2)
            upper_bound = x2;
        end 

        if func(x1) >= func(x2)
            lower_bound = x1;
        end

        iter = iter + 1;
    end

    sol = (upper_bound + lower_bound)/2;
end