1. 
```Matlab
N = [10, 20, 30, 100, 200, 300, 1000, 2000, 3000];
X = [];
for i=1:size(N,2)
	rate = 0;
	for toss=1:N(i)
		rate = rate + (rand>0.5)/N(i);
	end
	X(i) = rate;
end
plot(N,X);
```
2. For $X \sim U[0, 1]$, we know $F^{-1}_{Y}(X) \sim Y$. Here $f_{Y}(y)=e^{-y} \implies F_{Y}(y)=\int_{0}^{y}f(y)dy=1-e^{-y} \implies F^{-1}_{Y}(y)=-ln(1-y)$   
```Matlab
N = 1000;
F_inv = @(y) -log(1-y);
for i=1:N
	X(i) = F_inv(rand);
end
hist(X, 30);
```
3. In multivariable normal distribution we have a p.d.f. of:$$f(\vec x) = \frac{1}{2\pi}exp(-\frac{1}{2}(x^{2}+y^{2}))$$ _MISTAKE!_
  *Important:* Full formula is $$f(x) = \frac{1}{(2\pi)^\frac{d}{2}|\Sigma|^\frac{1}{2}}\exp(-\frac{1}{2}(x^T \Sigma^{-1} x))$$
   In matlab we use func: `mvnrnd( means vector, covariance matrix, variable amount)`

```Matlab
N = 1000;
X = mvnrnd([0 0], [1 0; 0 1], N);
var(X(:, 1)) + var(X(:,2))
var(X(:, 1) + X(:,2))
```
4. In matlab we can mimic list comprehension with: `arrayfun(@(t) 1/t, x)` 
```Matlab
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
```
5. $$N(0, 1) = \frac{N(4, 0.01)-4}{0.01}$$
```Matlab
normcdf((3.9-4)/0.01)
4 + norminv(0.01)
```
6. This is true because $\bar \mu = \left(\text{constant } \frac{1}{n}\right) \sum\limits x_{i}$   
```Matlab
N = 10000;
n = 100;
for i=1:N
	Y(i) = mean(rand(n, 1));
end
hist(Y, 100);
```