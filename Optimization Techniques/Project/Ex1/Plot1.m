%% clean
clear all;


%% Parameters
bounds = [-1 3];
max_iter = 50;

foldername = 'figs/';

% number of detail points for the plots
nx = 1000;

epsilon_sample_amount = 500;
% list of epsilon values starting from 0 exclusive to 1 inclusive
epsilon_list = linspace(0.0001, 0.05, epsilon_sample_amount);


lambda_sample_amount = 3;
lambda = 0.0;
% same as above for lambda
lambda_list = linspace(0.0001, 0.004, lambda_sample_amount);

lambda_sample_amount_iters = 500;
% same as above for lambda
lambda_iters_list = linspace(0.0001, 0.04, lambda_sample_amount_iters);


% the functions we will be minimizing
f1 = @(x) (x-2)^2 + x*log(x+3);
f2 = @(x) 5^x + (2-cos(x))^2;
f3 = @(x) exp(x)*(x^3-1)+(x-1)*sin(x);

% to keep track of figures
fignum = 0;

%% Calculations
x = linspace(bounds(1), bounds(2), nx);

% functions applied elementwise to the x vector
f1_y = arrayfun(f1, x);
f2_y = arrayfun(f2, x);
f3_y = arrayfun(f3, x);

% the values of ex_1_1 for the different epsilon values, lambda set to 0.01
lambda = 0.01;

f1_lb_eps = cell(1, epsilon_sample_amount);
f1_ub_eps = cell(1, epsilon_sample_amount);

f2_lb_eps = cell(1, epsilon_sample_amount);
f2_ub_eps = cell(1, epsilon_sample_amount);

f3_lb_eps = cell(1, epsilon_sample_amount);
f3_ub_eps = cell(1, epsilon_sample_amount);

for i = 1:epsilon_sample_amount
    [f1_sol_eps(i) f1_lb_eps{i} f1_ub_eps{i} f1_iter_eps(i)] = ex_1_1(f1, bounds(1), bounds(2), epsilon_list(i), lambda, max_iter);
    [f2_sol_eps(i) f2_lb_eps{i} f2_ub_eps{i} f2_iter_eps(i)] = ex_1_1(f2, bounds(1), bounds(2), epsilon_list(i), lambda, max_iter);
    [f3_sol_eps(i) f3_lb_eps{i} f3_ub_eps{i} f3_iter_eps(i)] = ex_1_1(f3, bounds(1), bounds(2), epsilon_list(i), lambda, max_iter);
end

% the values of the vectors f_up and f_lb for the different lambda values, epsilon set to 0.001
epsilon = 0.001;

f1_lb_lambda = cell(1, lambda_sample_amount);
f1_ub_lambda = cell(1, lambda_sample_amount);

f2_lb_lambda = cell(1, lambda_sample_amount);
f2_ub_lambda = cell(1, lambda_sample_amount);

f3_lb_lambda = cell(1, lambda_sample_amount);
f3_ub_lambda = cell(1, lambda_sample_amount);

for i = 1:lambda_sample_amount
    [f1_sol_lambda(i) f1_lb_lambda{i} f1_ub_lambda{i} f1_iter_lambda(i)] = ex_1_1(f1, bounds(1), bounds(2), epsilon, lambda_list(i), max_iter)
    [f2_sol_lambda(i) f2_lb_lambda{i} f2_ub_lambda{i} f2_iter_lambda(i)] = ex_1_1(f2, bounds(1), bounds(2), epsilon, lambda_list(i), max_iter);
    [f3_sol_lambda(i) f3_lb_lambda{i} f3_ub_lambda{i} f3_iter_lambda(i)] = ex_1_1(f3, bounds(1), bounds(2), epsilon, lambda_list(i), max_iter);
end

% this is with a lot more samples to calculate only the iterations of the
% algorithm

for i = 1:lambda_sample_amount_iters
    [f1_sol_iters_lambda(i) a a f1_iter_iters_lambda(i)] = ex_1_1(f1, bounds(1), bounds(2), epsilon, lambda_iters_list(i), max_iter)
    [f2_sol_iters_lambda(i) a a f2_iter_iters_lambda(i)] = ex_1_1(f2, bounds(1), bounds(2), epsilon, lambda_iters_list(i), max_iter);
    [f3_sol_iters_lambda(i) a a f3_iter_iters_lambda(i)] = ex_1_1(f3, bounds(1), bounds(2), epsilon, lambda_iters_list(i), max_iter);
end

%% Visualizations

picturewidth = 20;
hw_ratio =1.0;

% subplots of f_sol_eps for the different functions, as a function of epsilon

hw_ratio = 1.0;
fignum = fignum+1;
hfig = figure(fignum);
fname = foldername + string('') + 'epsilon_sols';

subplot(3,1,1);
plot(epsilon_list, f1_sol_eps,'LineWidth',1.5);
grid on;
title('$f_1(x)$');
xlabel('$\epsilon$');
ylabel('solution');

subplot(3,1,2);
plot(epsilon_list, f2_sol_eps,'LineWidth',1.5);
grid on;
title('$f_2$(x)');
xlabel('$\epsilon$');
ylabel('solution');

subplot(3,1,3);
plot(epsilon_list, f3_sol_eps,'LineWidth',1.5);
grid on;
title('$f_3(x)$');
xlabel('$\epsilon$');
ylabel('solution');

sgtitle(sprintf('f final solution as a function of $\\epsilon$, with $\\lambda$ = %g', lambda));

set(findall(hfig,'-property','FontSize'),'FontSize',15);
set(findall(hfig,'-property','Box'),'Box','off'); % optional;
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
print(hfig,fname,'-dpdf','-painters','-fillpage');

% subplots of f1_hb and f1_lb for the different lambda values

fignum = fignum+1;
hfig = figure(fignum);
fname = foldername  + string('') + 'epsilon_bounds_f1';
hw_ratio = 1.0;

subplot(lambda_sample_amount, 1, 1)
for i=1:lambda_sample_amount
    subplot(lambda_sample_amount, 1, i)
    plot(f1_lb_lambda{i}(1, 1:f1_iter_lambda(i)-1),'LineWidth',1.5);
    hold on;
    plot(f1_ub_lambda{i}(1, 1:f1_iter_lambda(i)-1),'LineWidth',1.5);
    grid on;
    title(sprintf('$\\lambda$ = %g, stopped after %d iterations', lambda_list(i), f1_iter_lambda(i)));
    %xlabel('Step Number');
    if i == lambda_sample_amount
        xlabel('Step Number');
    end
    ylabel('Bounds');
end
sgtitle(sprintf('$f_1$ upper and lower bounds for varying $\\lambda$, $\\epsilon$ = %g', epsilon)) 

set(findall(hfig,'-property','FontSize'),'FontSize',17);
set(findall(hfig,'-property','Box'),'Box','off'); % optional;
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
print(hfig,fname,'-dpdf','-painters','-fillpage');

% f2

fignum = fignum+1;
hfig = figure(fignum);
fname = foldername  + string('') + 'epsilon_bounds_f2';

subplot(lambda_sample_amount, 1, 1)
for i=1:lambda_sample_amount
    subplot(lambda_sample_amount, 1, i)
    plot(f2_lb_lambda{i}(1, 1:f2_iter_lambda(i)-1),'LineWidth',1.5);
    hold on;
    plot(f2_ub_lambda{i}(1, 1:f2_iter_lambda(i)-1),'LineWidth',1.5);
    grid on;
    title(sprintf('$\\lambda$ = %g, stopped after %d iterations', lambda_list(i), f2_iter_lambda(i)));
    %xlabel('Step Number');
    if i == lambda_sample_amount
        xlabel('Step Number');
    end
    ylabel('Bounds');
end
sgtitle(sprintf('$f_2$ upper and lower bounds for varying $\\lambda$, $\\epsilon$ = %g', epsilon)) 

set(findall(hfig,'-property','FontSize'),'FontSize',15);
set(findall(hfig,'-property','Box'),'Box','off'); % optional;
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
print(hfig,fname,'-dpdf','-painters','-fillpage');

%f3

fignum = fignum+1;
hfig = figure(fignum);
fname = foldername + string('')  + 'epsilon_bounds_f3';

subplot(lambda_sample_amount, 1, 1)
for i=1:lambda_sample_amount
    subplot(lambda_sample_amount, 1, i)
    plot(f3_lb_lambda{i}(1, 1:f3_iter_lambda(i)-1),'LineWidth',1.5);
    hold on;
    plot(f3_ub_lambda{i}(1, 1:f3_iter_lambda(i)-1),'LineWidth',1.5);
    grid on;
    title(sprintf('$\\lambda$ = %g, stopped after %d iterations', lambda_list(i), f3_iter_lambda(i)));
    %xlabel('Step Number');
    if i == lambda_sample_amount
        xlabel('Step Number');
    end
    ylabel('Bounds');
end
sgtitle(sprintf('$f_3$ upper and lower bounds for varying $\\lambda$, $\\epsilon$ = %g', epsilon)) 

set(findall(hfig,'-property','FontSize'),'FontSize',17);
set(findall(hfig,'-property','Box'),'Box','off'); % optional;
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
print(hfig,fname,'-dpdf','-painters','-fillpage');


% plot of f_iter_iters_lambda for the different lambda values

fignum = fignum+1;
hfig = figure(fignum);
fname = foldername + string('') + 'f_iters_lambda';
hw_ratio = 0.65;


plot(lambda_iters_list, f1_iter_iters_lambda, 'LineWidth', 1.5);
hold on;
plot(lambda_iters_list, f2_iter_iters_lambda, 'LineWidth', 1.5);
plot(lambda_iters_list, f3_iter_iters_lambda, 'LineWidth', 1.5);
grid on;
xline(epsilon*2, '-', {'$2\epsilon$'});
xlabel('$\lambda$');
ylabel('Iterations');
legend('$f_1$', '$f_2$', '$f_3$');
title(sprintf('Iterations for varying $\\lambda$, $\\epsilon$ = %g', epsilon))

set(findall(hfig,'-property','FontSize'),'FontSize',15);
set(findall(hfig,'-property','Box'),'Box','off'); % optional;
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
print(hfig,fname,'-dpdf','-painters','-fillpage');

% subplots of the 3 functions in heavy lines

fignum = fignum+1;
hfig = figure(fignum);
fname = foldername + string('') + 'function_graphs';
hw_ratio = 1.0;

subplot(3,1,1);
plot(x, f1_y,'LineWidth',1.5);
grid on;
title('$f_1(x)=(x-2)^2+x \ln(x+3)$');
xlabel('$x$');
ylabel('$f_1(x)$');

subplot(3,1,2);
plot(x, f2_y,'LineWidth',1.5);
grid on;
title('$f_2(x)=5^x+(2-\cos(x))^2$');
xlabel('$x$');
ylabel('$f_2(x)$');

subplot(3,1,3);
plot(x, f3_y,'LineWidth',1.5);
grid on;
title('$f_3(x)=e^x(x^3-1)+(x-1)\sin(x)$');
xlabel('$x$');
ylabel('$f_3$');

sgtitle('The function plots on the relevant domain') 

set(findall(hfig,'-property','FontSize'),'FontSize',15);
set(findall(hfig,'-property','Box'),'Box','off'); % optional;
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
print(hfig,fname,'-dpdf','-painters','-fillpage');

%% Finish
close all