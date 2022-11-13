function [sol lb_list ub_list iter] = ex_1_3(f, lower_bound, upper_bound, lambda, epsilon) 
    %calculate the fibonacci numbers
    fib = [1 1];
    while true
        fib(end+1) = fib(end) + fib(end-1);
        
        if fib(end) > (upper_bound - lower_bound)/lambda
            break;
        end 
    end
    n = length(fib);
    
    lb_list = zeros(1, n);
    ub_list = zeros(1, n);

    lb_list(1) = lower_bound;
    ub_list(1) = upper_bound;

    x1 = lower_bound + fib(n-2)/fib(n) * (upper_bound - lower_bound);
    x2 = lower_bound + fib(n-1)/fib(n) * (upper_bound - lower_bound);

    f_at_x1 = f(x1);
    f_at_x2 = f(x2);

    k = 1;
    while k < n - 1
        % to fix indexing
        n = n+1;
        % calculate x_k+1
        if f_at_x1 > f_at_x2
            lower_bound = x1;
            % upper bound stays the same
            x1 = x2;
            x2 = lower_bound + fib(n-k-1)/fib(n-k) * (upper_bound - lower_bound)

            f_at_x1 = f_at_x2;
            f_at_x2 = f(x2);
        else
            upper_bound = x2;
            % lower bound stays the same
            x2 = x1;
            x1 = lower_bound + fib(n-k-2)/fib(n-k) * (upper_bound - lower_bound);

            f_at_x2 = f_at_x1;
            f_at_x1 = f(x1);
        end
        n = n-1;

        k = k+1;
        lb_list(k) = lower_bound;
        ub_list(k) = upper_bound;
    end
    % k = n-1 now
    x1 = x1;
    x2 = x1 + epsilon;

    if f_at_x1 > f(x2)
        lower_bound = x1;
        % upper bound stays the same
    else
        upper_bound = x1;
        % lower bound stays the same
    end

    lb_list(n) = lower_bound;
    ub_list(n) = upper_bound; 
    iter = k
    sol = (lower_bound + upper_bound)/2

end