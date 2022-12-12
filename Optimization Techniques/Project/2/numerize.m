function [numf numgrad numhess] = numerize(f, x, y)
    numfxy = matlabFunction(f);
    numf = @(p) numfxy(p(1), p(2));

    numgradxy = matlabFunction(gradient(f, [x y]));
    numgrad = @(p) numgradxy(p(1), p(2));

    numhessxy = matlabFunction(hessian(f, [x y]));
    numhess = @(p) numhessxy(p(1), p(2));
end
