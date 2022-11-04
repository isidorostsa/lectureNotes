## 1. Norms

1. _Vector Norm_: ...
2. _Induced Matrix Norm_: $$\|{A}\| = \sup_{x \in R^{n}} \frac{|Ax|}{|x|} = \sup_{|x|=1} |Ax|$$Which is the largest a unit vector can get by transforming it by $A$. This is the magnitude of the largest eigenvalue. Some useful properties are:
	1. $|Ax| \le \|{A}\| \|{x}\|$ 
	2. $\|{A+B}\| \le \|{A}\| + \|{B}\|$
	3. $\|{AB}\| \le \|{A}\| \|{B}\|$

Generally useful norms use the notation:
- $|x|_{\infty}= \max{|x_{i}|}$  
- $|{x}|_{1} = \sum_i |x_{i}|$ 
- $|x|^{2} = (\sum_{i}x_{i}^{2})^\frac{1}{2}$
- $\|{A}\|_{\infty}= \max_{i}\sum_{j}|a_{ij}|$ (sum of row elements)
- $\|{A}\|_{1}= \max_{j}\sum_{i}|a_{ij}|$ (sum of column elements)
- $\|{A}\|_{2} = \lambda_{max}(A^{T}A)$ 
