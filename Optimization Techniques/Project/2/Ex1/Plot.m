%% Definitions

clear all

syms xvar yvar f(xvar,yvar)

f = xvar^5*exp(-xvar^2-yvar^2);

[func gradfunc hessianfunc] = numerize(f, xvar, yvar);

folder = 'Ex1/figs/';
fignum = 1;

max_iterations = 50;
epsilon = 0;
p0 = [-1;1];

d_method = 1;
g_method = 1;

gamma = 0.1;
%% Plot

% close all figures

close all

% Create a new figure and set the figure size
hfig = figure(fignum);
fignum = fignum + 1;
fname = folder + string('') + 'sd_allpoints_gamma0d1.pdf';

x = -3:.2:3;
y = -3:.2:3;

% create a meshgrid
func_to_plot = @(p1, p2) minimize_with_der(func, gradfunc, hessianfunc, max_iterations, epsilon, [p1;p2], d_method, g_method);
Z = zeros(length(x),length(y));

for i = 1:length(x)
    for j = 1:length(y)
        Z(i,j) = func_to_plot(y(j),x(i));
    end
end


% aspect ratios

hw_ratio = 0.7; % height/width
picturewidth = 20; % cm

%surf(x, y, Z);
contour(x,y,Z, 'Fill', 'on');
axis tight;

xlabel('x');
ylabel('y');
title('Finishing value, Steepest descent, $\gamma = 0.001$', 'Interpreter', 'latex')

set(findall(hfig,'-property','FontSize'),'FontSize',15);
set(findall(hfig,'-property','Box'),'Box','off'); % optional;
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);

% Plot the surface using the surf function

% Add axis labels, a title, and a colorbar
colorbar;

% Choose a custom colormap for the plot
colormap('jet');

print(hfig,fname,'-dpdf', '-fillpage');

close all;