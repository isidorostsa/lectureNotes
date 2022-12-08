%% Steepest Descent Method
function [plist glist] = ex_2_1(func, gradfunc, max_iterations)
    plist = [];
    glist = [];
    p = [0; 0];
    plist = [plist p];

    while max_iterations > 0
        d = gradfunc(p);

        
    end