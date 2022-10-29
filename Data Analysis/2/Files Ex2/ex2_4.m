N = 10:10:10^3;
for i=1:size(N,2)
    n = N(i);
    x = rand(n, 1) + 1;
    M(i) = 1/mean(x);
    M_inv(i) = mean(arrayfun(@(t) 1/t, x));
end
plot(N, M);
hold on;
plot(N, M_inv);