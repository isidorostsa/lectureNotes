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