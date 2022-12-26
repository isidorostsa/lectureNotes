function plotAllPoints(gamma_method, gamma, identifier)
    syms xvar yvar f;

    f = 1/3 * xvar^2 + 3 * yvar ^ 2;
    
    [func gradfunc hessianfunc] = numerize(f, xvar, yvar);
    hessianfunc = @(p) 0;

    folder = 'Ex' + string('') + '/figs/allpoints';
    fignum = 1;

    % Create a new figure and set the figure size
    picturewidth = 20;
    hw_ratio = 0.65;

    hfig = figure(fignum);
    fignum = fignum + 1;
    fname = folder + string('/') + 'allpoints_' + 'gamma_' + string(gamma).replace('.', '') + '_' + string(identifier);

    d_method = 1;
    g_method = 1;
    epsilon = 0.001;
    max_iterations = 1000;
    func_to_plot = @(p) minimize_with_der(func, gradfunc, hessianfunc, max_iterations, epsilon, gamma, p, d_method, g_method);

    lim = 15;
    points = 50;
    x = linspace(-lim, lim, points);
    y = linspace(-lim, lim, points);

    % draw the heatmap of f on all x, y points
    [X,Y] = meshgrid(x,y);
    Z = zeros(size(X));
    for i = 1:size(X,1)
        for j = 1:size(X,2)
            Z(i,j) = func_to_plot([X(i,j); Y(i,j)]);
        end
    end

    contourf(X,Y,Z, 100, 'LineStyle', 'none');
    colormap(jet);
    colorbar;

    xlabel('$x$');
    ylabel('$y$');
    title('Heatmap of $f$ final point depending on starting point');

    set(findall(hfig,'-property','FontSize'),'FontSize',18);
    set(findall(hfig,'-property','Box'),'Box','off'); % optional;
    set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
    set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
    set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
    pos = get(hfig,'Position');
    set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
    print(hfig,fname,'-dpdf','-painters','-fillpage');

    close all;
end