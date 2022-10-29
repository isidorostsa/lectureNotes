N = 10:10:10^3;
for i=1:size(N,2)
    n = N(i);
    x = rand(n, 1) + 1;
    m(i) = 1/mean(x);
    m_inv(i) = mean(arrayfun(@(t) 1/t, x));
end
n
m
plot(n, m);
hold on;
plot(n, m_inv);