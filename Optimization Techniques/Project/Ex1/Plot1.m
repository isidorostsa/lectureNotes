%% clean
clear all

%% Parameters
bounds = [-1 3];
max_iter = 100;

% number of detail points for the plots
nx = 1000;

epsilon_sample_amount = 50;
% list of epsilon values starting from 0 exclusive to 1 inclusive
epsilon_list = linspace(0.0001, 0.01, epsilon_sample_amount);


lambda_sample_amount = 5;
lambda = 0.0;
% same as above for lambda
lambda_list = linspace(0.0001, 0.05, lambda_sample_amount);

% the functions we will be minimizing
f1 = @(x) (x-2)^2 + x*log(x+3);
f2 = @(x) 5^x + (2-cos(x))^2;
f3 = @(x) exp(x)*(x^3-1)+(x-1)*sin(x);

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

%% Visualizations

% subplots of f_sol_eps for the different functions, as a function of epsilon

figure(1);
subplot(3,1,1);
plot(epsilon_list, f1_sol_eps);
title('f1 solution as a function of epsilon');
xlabel('epsilon');
ylabel('solution');

subplot(3,1,2);
plot(epsilon_list, f2_sol_eps);
title('f2 solution as a function of epsilon');
xlabel('epsilon');
ylabel('solution');

subplot(3,1,3);
plot(epsilon_list, f3_sol_eps);
title('f3 solution as a function of epsilon');
xlabel('epsilon');
ylabel('solution');

% subplots of f1_hb and f1_lb for the different epsilon values

figure(2);
subplot(lambda_sample_amount, 1, 1)
for i=1:lambda_sample_amount
    subplot(lambda_sample_amount, 1, i)
    plot(f1_lb_lambda{i}(1, 1:f1_iter_lambda(i)-1));
    hold on;
    plot(f1_ub_lambda{i}(1, 1:f1_iter_lambda(i)-1));
    title(sprintf('f1 upper and lower bounds for lambda = %f, after %d iterations', lambda_list(i), f1_iter_lambda(i)));
    xlabel('x');
    ylabel('f1');
end

% same as above for f2 and f3

figure(3);
subplot(lambda_sample_amount, 1, 1)
for i=1:lambda_sample_amount
    subplot(lambda_sample_amount, 1, i)
    plot(f2_lb_lambda{i}(1, 1:f2_iter_lambda(i)-1));
    hold on;
    plot(f2_ub_lambda{i}(1, 1:f2_iter_lambda(i)-1));
    title(sprintf('f2 upper and lower bounds for lambda = %f, after %d iterations', lambda_list(i), f2_iter_lambda(i)));
    xlabel('x');
    ylabel('f2');
end

figure(4);
subplot(lambda_sample_amount, 1, 1)
for i=1:lambda_sample_amount
    subplot(lambda_sample_amount, 1, i)
    plot(f3_lb_lambda{i}(1, 1:f3_iter_lambda(i)-1));
    hold on;
    plot(f3_ub_lambda{i}(1, 1:f3_iter_lambda(i)-1));
    title(sprintf('f3 upper and lower bounds for lambda = %f, after %d iterations', lambda_list(i), f3_iter_lambda(i)));
    xlabel('x');
    ylabel('f3');
end

% subplots of the 3 functions in red, with heavy lines

figure(8);
subplot(3,1,1);
plot(x, f1_y, 'r', 'LineWidth', 2);
title('f1');
xlabel('x');
ylabel('f1');

subplot(3,1,2);
plot(x, f2_y, 'r', 'LineWidth', 2);
title('f2');
xlabel('x');
ylabel('f2');

subplot(3,1,3);
plot(x, f3_y, 'r', 'LineWidth', 2);
title('f3');
xlabel('x');
ylabel('f3');