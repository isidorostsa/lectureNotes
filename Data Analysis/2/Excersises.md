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
3. In multivariable normal distribution we have a p.d.f. of:$$f(\vec x) = \frac{1}{2\pi}exp(-\frac{1}{2}(x^{2}+y^{2}))$$ In matlab we use func: `mvnrnd( means vector, covariance matrix, variable amount)`
```Matlab
N = 1000;
X = mvnrnd([0 0], [1 0; 0 1], N);
var(X(:, 1)) + var(X(:,2))
var(X(:, 1) + X(:,2))
```
4. In matlab we can mimic list comprehension with: `arrayfun(@(t) 1/t, x)` 
```Matlab
N = []
```