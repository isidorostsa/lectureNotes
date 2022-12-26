function [finalValue finalPoint values points iterations] = ...
    minimize_with_der_all_outputs(func, gradfunc, hessianfunc, max_iterations, epsilon, gamma_const, p0, d_selection_method, gamma_selection_method)

    points = [];
    p = p0;
    points = [points p];

    values = [];
    v = func(p);
    values = [values v];

    grad_at_p = gradfunc(p);
    hessian_at_p = hessianfunc(p);

    iterations = 0;
    while (norm(gradfunc(p)) > epsilon) && iterations < max_iterations
        % we want to find the step size that minimizes the function
        % f(p + gamma * grad(p))
        % we can do this by finding the zero of the derivative of f
        % d f(p + gamma * grad(p)) / d gamma = 0
        % we can define the function f as an anonymous function
        % we can use the bisection method to find the zero of the
        % derivative
        % ezplot(@(gamma) temp_func(gamma, p), [0 20])
        grad_at_p = gradfunc(p);
        hessian_at_p = hessianfunc(p);

        % steepest descent
        if(d_selection_method == 1)
            d = -grad_at_p;
        % newton
        elseif(d_selection_method == 2)
            d = -hessian_at_p\grad_at_p;
        % L-M
        elseif(d_selection_method == 3)
            u_search_interval = 0:0.2:10;

            matrix_to_be_pos_def = @(u) hessian_at_p + u*eye(2);

            u = -100;

            for i = 1:length(u_search_interval)
                if ( (det(matrix_to_be_pos_def(u_search_interval(i))) > 0) && (hessian_at_p(1, 1) + u_search_interval(i) > 0) )
                    u = u_search_interval(i);
                    break;
                end
            end

            if u == -100
                disp('No u found');
            end

            d = -matrix_to_be_pos_def(u)\grad_at_p;
        end

        % constant
        if(gamma_selection_method == 1)
            gamma = gamma_const;
        % simple minimize
        elseif(gamma_selection_method == 2)
            gamma = fminbnd(@(gamma) func(p + gamma*d), 0, 10);
        %armijo
        elseif(gamma_selection_method == 3)
            a = 1e-3;
            b = 1e-1;
            s = 1e-1;

            gamma = armijo(func, gradfunc(p), d, a, b, s, p);
        end

        p = p + gamma*d;
        points = [points p];

        v = func(p);
        values = [values v];

        grad = gradfunc(p);
        iterations = iterations + 1;
    end
    finalPoint = p;
    finalValue = func(p);

end