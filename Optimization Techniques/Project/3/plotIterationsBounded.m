function hfig = plotIterationsBounded(gamma, s, starting_points, x_bounds, y_bounds, identifier)
    syms xvar yvar f(xvar,yvar)

    f = 1/3 * xvar^2 + 3 * yvar ^ 2;

    [func gradfunc hessianfunc] = numerize(f, xvar, yvar);

    d_method = 1;
    g_method = 1;
    epsilon = 0.01;
    max_iterations = 1000;
    fignum = 0;

    p_id = 5;
    if p_id == 1
        p0 = [-1; 1];
    elseif p_id == 2
        p0 = [1; -1];
    elseif p_id == 3
        p0 = [0; 0];
    end

    foldername = 'ExBounded' + string('') + '/figs';

%    minimize_with_der_all_outputs
% (func, gradfunc, hessianfunc, max_iterations, 
% epsilon, gamma_const, p0, d_selection_method, gamma_selection_method)

    wrapper = @(p) minimize_with_der_all_outputs_bounded(func, gradfunc,... 
                    max_iterations, epsilon, gamma, s, p, x_bounds, y_bounds);

    picturewidth = 20;

    fname = string('heatmap_bounded')

    %{
    for i = 1:size(starting_points, 2)
        p0 = starting_points(:,i)
        [fvalue fpoint values points iterations] = wrapper(p0);

        x_down_temp = min(points(1, :));
        x_up_temp = max(points(1, :));
        y_down_temp = min(points(2, :));
        y_up_temp = max(points(2, :));

        x_down = min(x_down, x_down_temp);
        x_up = max(x_up, x_up_temp);
        y_down = min(y_down, y_down_temp);
        y_up = max(y_up, y_up_temp);

        fname = foldername + string('/') + string(i) + '_plot_gamma_' + string(gamma).replace('.', '');
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
        %print(hfig,fname,'-dpdf','-painters','-fillpage');
    end
    %}

    %% draw heatmap of f

    hw_ratio = 0.65;
    fignum = fignum+1;
    hfig = figure(fignum);
    fname = foldername + string('/') + fname + '_heatmap';
    
    % get down and up limits of x and y in the previous plot
    %

    % get the limits of x and y in the heatmap

    datapoints = 50;
    x = linspace(x_bounds(1) - 1, x_bounds(2) + 5, datapoints);
    y = linspace(y_bounds(1) - 5, y_bounds(2) + 1, datapoints);

    % draw the heatmap of f on all x, y points
    [X,Y] = meshgrid(x,y);
    Z = zeros(size(X));
    for i = 1:size(X,1)
        for j = 1:size(X,2)
            p0 = [X(i,j); Y(i,j)];
            %[a fpoint values points Z(i,j)] = wrapper(p0);
            %[Z(i,j) fpoint values points iterations] = wrapper(p0);
            Z(i, j) = func(p0);
        end
    end

    contourf(X,Y,Z, 100, 'LineStyle', 'none');
    colormap(jet);
    colorbar;

    hold on;

% draw the square of the bounds
    x = [x_bounds(1) x_bounds(1) x_bounds(2) x_bounds(2) x_bounds(1)];
    y = [y_bounds(1) y_bounds(2) y_bounds(2) y_bounds(1) y_bounds(1)];
    plot(x, y, 'LineWidth', 1.5, 'Color', 'black');

    for i = 1:size(starting_points, 2)
        p0 = starting_points(:,i)
        [fvalue fpoint values points iterations] = wrapper(p0);
        hold on;
        plot(points(1, :), points(2, :), 'o-', 'LineWidth', 0.2, 'Color', 'white', 'MarkerSize', 3, 'MarkerFaceColor', 'black');
    end

    xlabel('$x_1$');
    ylabel('$x_2$');
    title('Heatmap of iterations');
    %, took ' + string(iterations) + ' iterations');

    set(findall(hfig,'-property','FontSize'),'FontSize',18);
    set(findall(hfig,'-property','Box'),'Box','off'); % optional;
    set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
    set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
    set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
    pos = get(hfig,'Position');
    set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
    print(hfig,fname,'-dpdf','-fillpage');

    close all;
    clear all;
end