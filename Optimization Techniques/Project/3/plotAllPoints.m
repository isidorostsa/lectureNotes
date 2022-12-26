function plotAllPoints(d_method, g_method, epsilon, identifier)
    syms xvar yvar f

    f = xvar^5*exp(-xvar^2-yvar^2);

    [func gradfunc hessianfunc] = numerize(f, xvar, yvar);

    folder = 'Ex' + string(d_method) + '/figs/allpoints';
    fignum = 1;

    max_iterations = 1000;

    gamma = 1e-2;


    % Create a new figure and set the figure size
    

    picturewidth = 20;
    hw_ratio = 0.65;

    hfig = figure(fignum);
    fignum = fignum + 1;
    fname = folder + string('/') + 'allpoints_method_' + string(d_method) + '_gamma_' + string(g_method);

    func_to_plot = @(p) minimize_with_der(func, gradfunc, hessianfunc, max_iterations, epsilon, gamma, p, d_method, g_method);

    x = linspace(-3, 3, 200);
    y = linspace(-3, 3, 200);

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