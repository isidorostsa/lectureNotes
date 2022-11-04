## 1. Norms

1. _Induced Matrix Norm_: $$\|{A}\| = \sup_{x \in R^{n}} \frac{|Ax|}{|x|} = \sup_{|x|=1} |Ax|$$Which is the largest a unit vector can get by transforming it by $A$. This is the magnitude of the largest eigenvalue. Some useful properties are:
	1. $|Ax| \le \|{A}\| \|{x}\|$ 
	2. $\|{A+B}\| \le \|{A}\| + \|{B}\|$
	3. $\|{AB}\| \le \|{A}\| \|{B}\|$
2. _Generally useful norms_:
- $|x| := |x|_{2} = (\sum_{i}x_{i}^{2})^\frac{1}{2}$
- $|{x}|_{1} = \sum_i |x_{i}|$ 
- $|x|_{\infty}= \max{|x_{i}|}$  
- $|x|_{p} := (\sum_{i}x_{i}^{p})^\frac{1}{p}$ 
- $\|{A}\|_{\infty}= \max_{i}\sum_{j}|a_{ij}|$ (sum of row elements)
- $\|{A}\|_{1}= \max_{j}\sum_{i}|a_{ij}|$ (sum of column elements)
- $\|{A}\|_{2} = \sqrt{\lambda_{max}(A^{T}A)}$ 

## Other Definitions

### Positive Definite Symmetric Matrix $A\in R^{n \times n}$:
$$x^{T}A x > 0, \space \forall x \in R^{n}$$
This is true if any of the following propositions is true:
1. All $A$ eigenvalues are positive (They are definitely real since $A^T=A$)
2. $\exists A_{1}: \det(A_{1}) \neq 0, \space A = A_{1}A_{1}^{T}$ 
3. All leading principal minors are positive (determinants on square submatrices starting in the top left)


