function k = smallestZero(func)
    point = 0;
    while(fzero(func, point) < 0)
        point = point + 1e-3;
    end
    k = fzero(func, point);