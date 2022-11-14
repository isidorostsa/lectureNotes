%% clean
clear all;


%% Parameters
bounds = [-1 3];
max_iter = 50;

foldername = 'figs/';

% number of detail points for the plots
nx = 1000;

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


% the number of iterations of the algorithm for each of the functions given a large sample of lambda values
for i = 1:lambda_sample_amount_iters
    [f1_sol_iters_lambda(i) a a f1_iter_iters_lambda(i)] = ex_1_2(f1, bounds(1), bounds(2), lambda_iters_list(i), max_iter)
    [f2_sol_iters_lambda(i) a a f2_iter_iters_lambda(i)] = ex_1_2(f2, bounds(1), bounds(2), lambda_iters_list(i), max_iter);
    [f3_sol_iters_lambda(i) a a f3_iter_iters_lambda(i)] = ex_1_2(f3, bounds(1), bounds(2), lambda_iters_list(i), max_iter);
end

% the lower and upper bounds in each step of the algorithm for each of the functions for the different lambdas
f1_lb_lambda = cell(1, lambda_sample_amount);
f1_ub_lambda = cell(1, lambda_sample_amount);

f2_lb_lambda = cell(1, lambda_sample_amount);
f2_ub_lambda = cell(1, lambda_sample_amount);

f3_lb_lambda = cell(1, lambda_sample_amount);
f3_ub_lambda = cell(1, lambda_sample_amount);

for i = 1:lambda_sample_amount
    [f1_sol_lambda(i) f1_lb_lambda{i} f1_ub_lambda{i} f1_iter_lambda(i)] = ex_1_2(f1, bounds(1), bounds(2), lambda_list(i), max_iter)
    [f2_sol_lambda(i) f2_lb_lambda{i} f2_ub_lambda{i} f2_iter_lambda(i)] = ex_1_2(f2, bounds(1), bounds(2), lambda_list(i), max_iter);
    [f3_sol_lambda(i) f3_lb_lambda{i} f3_ub_lambda{i} f3_iter_lambda(i)] = ex_1_2(f3, bounds(1), bounds(2), lambda_list(i), max_iter);
end

%% Visualizations

picturewidth = 20;
hw_ratio =1.0;

% plot of f1_iter_iters for different lambda values, the plots for f1,2,3 are identical 

hw_ratio = 0.65;
fignum = fignum+1;
hfig = figure(fignum);
fname = foldername + string('') + 'lambda_iters';

pred = @(t) log(t/4)/log((sqrt(5)-1)/2)

plot(lambda_iters_list, f1_iter_iters_lambda, 'color','g','LineWidth', 1.5);
hold on
plot(lambda_iters_list, ceil(pred(lambda_iters_list)),'--','LineWidth', 1.5);
grid on;
xlabel('$\lambda$');
ylabel('Iterations');
title('Iterations for different $\lambda$ values for any function');

legend('Iterations', 'Predicted iterations', 'Location', 'northwest');

set(findall(hfig,'-property','FontSize'),'FontSize',15);
set(findall(hfig,'-property','Box'),'Box','off'); % optional;
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
print(hfig,fname,'-dpdf','-painters','-fillpage');

% subplots of the upper and lower bounds for the different lambda values in the small list

fignum = fignum+1;
hfig = figure(fignum);
fname = foldername  + string('') + 'lambda_bounds_f1';
hw_ratio = 1.0;

subplot(lambda_sample_amount, 1, 1)
for i=1:lambda_sample_amount
    subplot(lambda_sample_amount, 1, i)
    plot(f1_lb_lambda{i}(1, 1:f1_iter_lambda(i)-1),'LineWidth',1.5);
    hold on;
    plot(f1_ub_lambda{i}(1, 1:f1_iter_lambda(i)-1),'LineWidth',1.5);
    grid on;
    title(sprintf('$\\lambda$ = %g, stopped after %d iterations', lambda_list(i), f1_iter_lambda(i)));
    if i == lambda_sample_amount
        xlabel('Step Number');
    end
    ylabel('Bounds');
end
sgtitle(sprintf('$f_1$ upper and lower bounds for varying $\\lambda$')) 

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
fname = foldername  + string('') + 'lambda_bounds_f2';

subplot(lambda_sample_amount, 1, 1)
for i=1:lambda_sample_amount
    subplot(lambda_sample_amount, 1, i)
    plot(f2_lb_lambda{i}(1, 1:f2_iter_lambda(i)-1),'LineWidth',1.5);
    hold on;
    plot(f2_ub_lambda{i}(1, 1:f2_iter_lambda(i)-1),'LineWidth',1.5);
    grid on;
    title(sprintf('$\\lambda$ = %g, stopped after %d iterations', lambda_list(i), f2_iter_lambda(i)));
    if i == lambda_sample_amount
        xlabel('Step Number');
    end
    ylabel('Bounds');
end
sgtitle(sprintf('$f_2$ upper and lower bounds for varying $\\lambda$')) 

set(findall(hfig,'-property','FontSize'),'FontSize',17);
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
fname = foldername + string('')  + 'lambda_bounds_f3';

subplot(lambda_sample_amount, 1, 1)
for i=1:lambda_sample_amount
    subplot(lambda_sample_amount, 1, i)
    plot(f3_lb_lambda{i}(1, 1:f3_iter_lambda(i)-1),'LineWidth',1.5);
    hold on;
    plot(f3_ub_lambda{i}(1, 1:f3_iter_lambda(i)-1),'LineWidth',1.5);
    grid on;
    title(sprintf('$\\lambda$ = %g, stopped after %d iterations', lambda_list(i), f3_iter_lambda(i)));
    if i == lambda_sample_amount
        xlabel('Step Number');
    end
    ylabel('Bounds');
end
sgtitle(sprintf('$f_3$ upper and lower bounds for varying $\\lambda$')) 

set(findall(hfig,'-property','FontSize'),'FontSize',17);
set(findall(hfig,'-property','Box'),'Box','off'); % optional;
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
print(hfig,fname,'-dpdf','-painters','-fillpage');


%{
%plot of f_iter_iters_lambda for the different lambda values

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

%}

%% Finish 
close all;
