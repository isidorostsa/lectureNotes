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

```
