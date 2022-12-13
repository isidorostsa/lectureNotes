function hfig = plotIterations(d_selection_method, gamma_selection_method, p_id, epsilon, identifier)
    syms xvar yvar f(xvar,yvar)

    f = xvar^5*exp(-xvar^2-yvar^2);

    [func gradfunc hessianfunc] = numerize(f, xvar, yvar);

    max_iterations = 300;
    gamma_const = 5e-2;

    fignum = 0;

    if p_id == 1
        p0 = [-1; 1];
    elseif p_id == 2
        p0 = [1; -1];
    elseif p_id == 3
        p0 = [0; 0];
    end

    foldername = 'Ex' + string(d_selection_method) + '/figs';
    fname = foldername + string('/') + string(identifier) + 'method_' + string(d_selection_method) + '_gamma_' + string(gamma_selection_method) + '_point_' + string(p_id)';

%    minimize_with_der_all_outputs
% (func, gradfunc, hessianfunc, max_iterations, 
% epsilon, gamma_const, p0, d_selection_method, gamma_selection_method)

    wrapper = @() minimize_with_der_all_outputs(func, gradfunc, hessianfunc,...
                    max_iterations, epsilon, gamma_const, p0, d_selection_method, gamma_selection_method);


    [fvalue fpoint values points iterations] = wrapper();

    picturewidth = 20;
    hw_ratio = 0.65;

    hw_ratio = 0.65;
    fignum = fignum+1;
    hfig = figure(fignum);

    plot(values, 'LineWidth', 1.5);
    grid on;
    xlabel('k');
    ylabel('$f(x_k)$');
    title('Value of $f$ on each iteration');

    set(findall(hfig,'-property','FontSize'),'FontSize',18);
    set(findall(hfig,'-property','Box'),'Box','off'); % optional;
    set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
    set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
    set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
    pos = get(hfig,'Position');
    set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
    print(hfig,fname,'-dpdf','-painters','-fillpage');


    %% draw heatmap of f

    hw_ratio = 0.65;
    fignum = fignum+1;
    hfig = figure(fignum);
    fname = fname + '_heatmap';
    
    % get down and up limits of x and y in the previous plot
    x_down = min(points(1, :));
    x_up = max(points(1, :));

    y_down = min(points(2, :));
    y_up = max(points(2, :));


    % get the limits of x and y in the heatmap

    x_lim = max(abs(x_down), abs(x_up));
    y_lim = max(abs(y_down), abs(y_up));

    if x_lim > y_lim
        x_lim = ceil(x_lim);
        y_lim = x_lim * hw_ratio;
    else
        y_lim = ceil(y_lim);
        x_lim = y_lim / hw_ratio;
    end
    
    x = linspace(-x_lim, x_lim, 100);
    y = linspace(-y_lim, y_lim, 100);

    % draw the heatmap of f on all x, y points
    [X,Y] = meshgrid(x,y);
    Z = zeros(size(X));
    for i = 1:size(X,1)
        for j = 1:size(X,2)
            Z(i,j) = func([X(i,j) Y(i,j)]);
        end
    end

    contourf(X,Y,Z, 100, 'LineStyle', 'none');
    colormap(jet);
    colorbar;

    hold on;
    plot(points(1, :), points(2, :), 'LineWidth', 1.5, 'Color', 'black');
    hold off;

    xlabel('$x$');
    ylabel('$y$');
    title('Heatmap of $f$ and iterations');

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

