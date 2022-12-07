% Οι μεταβλητές εδώ υπολογίστηκαν στα υπόλοιπα αρχεία. Βρίσκονται στο
% data_altered_for_ex5.mat

clearvars -except f1_sol_dicho f2_sol_dicho f3_sol_dicho f1_sol_gol f2_sol_gol f3_sol_gol f1_sol_fib f2_sol_fib f3_sol_fib f1_sol_dider f2_sol_dider f3_sol_dider lambda_iters_list

f1 = @(x) (x-2)^2 + x*log(x+3);
f2 = @(x) 5^x + (2-cos(x))^2;
f3 = @(x) exp(x)*(x^3-1)+(x-1)*sin(x);

%% calculations:

f1_val_dicho = arrayfun(f1, f1_sol_dicho);
f2_val_dicho = arrayfun(f2, f2_sol_dicho);
f3_val_dicho = arrayfun(f3, f3_sol_dicho);

f1_val_gol = arrayfun(f1, f1_sol_gol);
f2_val_gol = arrayfun(f2, f2_sol_gol);
f3_val_gol = arrayfun(f3, f3_sol_gol);

f1_val_fib = arrayfun(f1, f1_sol_fib);
f2_val_fib = arrayfun(f2, f2_sol_fib);
f3_val_fib = arrayfun(f3, f3_sol_fib);

f1_val_dider = arrayfun(f1, f1_sol_dider);
f2_val_dider = arrayfun(f2, f2_sol_dider);
f3_val_dider = arrayfun(f3, f3_sol_dider);

%% visualization:

picturewidth = 20;
hw_ratio = 1;

hfig = figure(1);

fname = 'solutions';

subplot(3, 1, 1);

plot(lambda_iters_list, f1_val_dicho, 'LineWidth', 1.5, 'color', '#0072BD');
hold on;
grid on;
plot(lambda_iters_list, f1_val_gol, 'LineWidth', 1.5, 'color', '#D95319');
plot(lambda_iters_list, f1_val_fib,  'LineWidth', 1.5, 'color', '#EDB120');
plot(lambda_iters_list, f1_val_dider, 'LineWidth', 1.5, 'color', '#7E2F8E');
hold off;
ylim([min(f1_val_dider) 2.35912])
title('$f_1$');
ylabel('$\min{f_1}$');

subplot(3, 1, 2);

plot(lambda_iters_list, f2_val_dicho, 'LineWidth', 1.5, 'color', '#0072BD');
hold on;
grid on;
plot(lambda_iters_list, f2_val_gol,  'LineWidth', 1.5, 'color', '#D95319');
plot(lambda_iters_list, f2_val_fib, 'LineWidth', 1.5, 'color', '#EDB120');
plot(lambda_iters_list, f2_val_dider,  'LineWidth', 1.5, 'color', '#7E2F8E');
hold off;
ylim([min(f2_val_dider) 1.68955]);
title('$f_2$');
ylabel('$\min{f_2}$');

% legend on the left

legend('Dichotomy', 'Golden ratio', 'Fibonacci', 'Dichotomy Derivative', 'Location', 'NorthWest');

subplot(3, 1, 3);

plot(lambda_iters_list, f3_val_dicho,  'LineWidth', 1.5, 'color', '#0072BD');
hold on;
grid on;
plot(lambda_iters_list, f3_val_gol, 'LineWidth', 1.5, 'color', '#D95319');
plot(lambda_iters_list, f3_val_fib, 'LineWidth', 1.5, 'color', '#EDB120');
plot(lambda_iters_list, f3_val_dider, 'LineWidth', 1.5, 'color', '#7E2F8E');
hold off;
ylim([min(f3_val_dider) -1.6839]);
title('$f_3$');
xlabel('$\lambda$');
ylabel('$\min{f_3}$');

sgtitle('Objective function min value after $\lambda$ sized interval was reached') 

set(findall(hfig,'-property','FontSize'),'FontSize',15);
set(findall(hfig,'-property','Box'),'Box','off'); % optional;
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
print(hfig,fname,'-dpdf','-painters','-fillpage');

close all;