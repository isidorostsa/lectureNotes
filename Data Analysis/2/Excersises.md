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
2. For $X \sim U[0, 1]$, we know $F^{-1}_{Y}(X) \sim Y$. Here $f_{X}(x)=e^{-x} \implies $
   ```Matlab
   
```




bi:\binom{#cursor}{#tab};
sq:\sqrt{};2
bb:\mathbb{};
bf:\mathbf{};
te:\text{};
inf:\infty;
cd:\cdot;
qu:\quad;
ti:\times;
al:\alpha;
be:\beta;
ga:\gamma;
Ga:\Gamma;
de:\delta;
De:\Delta;
ep:\epsilon;
ze:\zeta;
et:\eta;
th:\theta;
Th:\Theta;
io:\iota;
ka:\kappa;
la:\lambda;
La:\Lambda;
mu:\mu;
nu:\nu;
xi:\xi;
Xi:\Xi;
pi:\pi;
Pi:\Pi;
rh:\rho;
si:\sigma;
Si:\Sigma;
ta:\tau;
up:\upsilon;
Up:\Upsilon;
ph:\phi;
Ph:\Phi;
ch:\chi;
ps:\psi;
Ps:\Psi;
om:\omega;
Om:\Omega;
fa:\forall;
pa:\partial;
sp:\space;
ge:\ge;
le:\le;
;
x0:x_{0};
x1:x_{1};
x2:x_{2};
x3:x_{3};
;
t0:t_{0};
t1:t_{1};
t2:t_{2};
;
dot:\dot;
vep:\varepsilon;
,f:,\space \forall;
in:\in;
norm:\|{#cursor}\|;
;
im:\implies;