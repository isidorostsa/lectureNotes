%% Steepest Descent Method
function [finalPoint finalValue iterations] = ex_2_1(f_symbolic, x, y, max_iterations, p0, d_selection_method, gamma_selection_method)
    [func gradfunc hessianfunc] = numerize(f_symbolic, x, y)

    plist = [];
    glist = [];
    p = p0;
    plist = [plist p];

    grad_at_p = [1; 1];
    iterations = 0;
    while norm(gradfunc(p)) > 1e-3 && iterations < max_iterations
        % we want to find the step size that minimizes the function
        % f(p + gamma * grad(p))
        % we can do this by finding the zero of the derivative of f
        % d f(p + gamma * grad(p)) / d gamma = 0
        % we can define the function f as an anonymous function
        % we can use the bisection method to find the zero of the
        % derivative
        % ezplot(@(gamma) temp_func(gamma, p), [0 20])
        grad_at_p = gradfunc(p);

        % steepest descent
        if(d_selection_method == 1)
            d = -grad_at_p;
        % newton
        elseif(d_selection_method == 2)
            hessian_at_p = hessianfunc(p);
            d = -inv(hessian_at_p)*grad_at_p;
        % L-M
        elseif(d_selection_method == 3)
            hessian_at_p = hessianfunc(p);
            u_search_interval = linspace(0, 60, 100);

            matrix_to_be_pos_def = @(u) hessian_at_p + u*eye(2);

            u = -100;

            for i = 1:length(u_search_interval)
                if (det(matrix_to_be_pos_def(u_search_interval(i))) > 0 && hessian_at_p(1, 1) + u_search_interval(i) > 0)
                    u = u_search_interval(i);
                    break;
                end
            end

            if u == -100
                disp('No u found');
            end

            d = inv(matrix_to_be_pos_def(u))*(-grad_at_p);
        end

        % constant
        if(gamma_selection_method == 1)
            gamma = 0.01;
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
        plist = [plist p];

        grad = gradfunc(p);
        iterations = iterations + 1;
    end
    finalPoint = p;
    finalValue = func(p);

end