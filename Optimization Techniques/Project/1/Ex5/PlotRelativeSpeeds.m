% Οι μεταβλητές εδώ υπολογίστηκαν στα υπόλοιπα αρχεία. Βρίσκονται στο
% data_altered_for_ex5.mat
clearvars -except f1_sol_dicho f2_sol_dicho f3_sol_dicho f1_sol_gol f2_sol_gol f3_sol_gol f1_sol_fib f2_sol_fib f3_sol_fib f1_sol_dider f2_sol_dider f3_sol_dider lambda_iters_list

picturewidth = 20;
hw_ratio = 0.65;

hfig = figure(1);

fname = 'results_evals_';

plot(lambdas_iters, dicho_evals, 'LineWidth', 1.5);
hold on;
plot(lambdas_iters, gold_evals, 'LineWidth', 1.5);
plot(lambdas_iters, fib_evals, 'LineWidth', 1.5);
plot(lambdas_iters, dider_evals, 'LineWidth', 1.5);
grid on;
ylim([5 30]);
xlabel('$\lambda$');
ylabel('Evaluations');
title('$f$ evaluations for different $\lambda$ values for the four algorithms');
legend('Dichotomy', 'Golden Section', 'Fibonacci', 'Dichotomy with Derivative');

set(findall(hfig,'-property','FontSize'),'FontSize',16);
set(findall(hfig,'-property','Box'),'Box','off'); % optional;
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') ;
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex');
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth]);
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
print(hfig,fname,'-dpdf','-painters','-fillpage');

close all;