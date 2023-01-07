function [finalValue finalPoint values points iterations] = ...
    minimize_with_der_all_outputs_bounded(func, gradfunc, max_iterations, epsilon, gamma, s, p0, x_bounds, y_bounds)

    points = [];
    % col vector
    p = p0;
    points = [points p];

    x_min = x_bounds(1);
    x_max = x_bounds(2);
    y_min = y_bounds(1);
    y_max = y_bounds(2);

    values = [];
    v = func(p);
    values = [values v];

    grad_at_p = gradfunc(p);

    iterations = 0;
    while iterations < max_iterations && norm(gradfunc(p)) >= epsilon
        grad_at_p = gradfunc(p);

        % steepest descent
        d = -grad_at_p;

        p_candidate = p + s*d;
        % if p_candidate in bounds
        if(p_candidate(1) > x_min && p_candidate(1) < x_max && p_candidate(2) > y_min && p_candidate(2) < y_max)
            p = p_candidate;
        else 
            p_projection = [max(x_min, min(x_max, p_candidate(1))); max(y_min, min(y_max, p_candidate(2)))];
            p = p + gamma*(p_projection - p);
        end
        
        points = [points p];

        v = func(p);
        values = [values v];

        grad = gradfunc(p);
        iterations = iterations + 1;
    end

    finalPoint = points(:, end);
    finalValue = values(end);

end