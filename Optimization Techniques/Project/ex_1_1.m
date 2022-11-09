function res = ex_1_1(func, lower_bound, upper_bound, epsilon, limit_width, limit_iterations)
    x1 = 0;
    x2 = 0;

    iter = 1;

    while upper_bound - lower_bound > limit_width && iter < limit_iterations

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

    res = (upper_bound + lower_bound)/2;
end