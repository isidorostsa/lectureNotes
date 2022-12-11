function gamma = armijo(func, grad_at_p, d, a, b, s, p)
    gamma_of_m = @(m) s*b^m;
    
    func_at_p = func(p);

    func_to_be_positive = ...
        @(m) func_at_p - func(p+d*gamma_of_m(m)) + a*b^m*s*d'*grad_at_p;

    interval_size = 20;
    m_search_values = linspace(0, interval_size - 1, interval_size);
    
    m = -1;

    % fplot(func_to_be_positive);

    for i = 1:length(m_search_values)
        if func_to_be_positive(m_search_values(i)) > 0
            m = m_search_values(i);
            break;
        end
    end

    if m == 1
        disp('No m found')
    end

    gamma = gamma_of_m(m);
end