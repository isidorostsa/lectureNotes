%% Steepest Descent Method
function [plist glist] = ex_2_1(func, max_iterations)
    plist = [];
    glist = [];
    p = [0; 0];
    plist = [plist p];
    glist = [glist g];

    for i = 1:max_iterations
        p = p - g;
        plist = [plist p];
        g = gradient(func, p);
        glist = [glist g];
    end
