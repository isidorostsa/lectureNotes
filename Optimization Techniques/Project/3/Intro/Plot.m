%% Definitions

clear all

syms x y f(x,y)

f = x^5*exp(-x^2-y^2);

%% Plot

% close all figures

close all

% Define the x, y, and z coordinates
[x, y] = meshgrid(-3:.1:3, -3:.1:3);
z = x.^5 .* exp(-x.^2 - y.^2);

% Create a new figure and set the figure size
hfig = figure(1);

% aspect ratios

hw_ratio = 0.7; % height/width
picturewidth = 20; % cm

fname = 'Intro/figs/surf_plot.pdf'

surf(x, y, z);
%contour(x, y, z);
axis tight;

xlabel('x');
ylabel('y');
title('$f(x,y) = x^5 \cdot e^{-x^2 - y^2}$', 'Interpreter', 'latex')

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
