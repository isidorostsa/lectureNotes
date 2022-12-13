function finalValue = minimize_with_der(func, gradfunc, hessianfunc, max_iterations, epsilon, gamma_const, p0, d_selection_method, gamma_selection_method)
    [finalValue a a a a] = minimize_with_der_all_outputs(func, gradfunc, hessianfunc, max_iterations, epsilon, gamma_const, p0, d_selection_method, gamma_selection_method);
end