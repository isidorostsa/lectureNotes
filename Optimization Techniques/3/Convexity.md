## Convex Set
A set $S \subseteq R^n$ is called convex iff:$$\forall x, y \in S: \lambda x + (1 - \lambda ) y = z \in S, \space \forall \lambda \in [0, 1]$$
### Theorem 3.1.1
For $S$ _convex_, $x_{1},...,x_{k} \in S$ then for $\lambda_{1},...,  \lambda_{k}$ with $\sum \lambda_{i} = 1$ then:$$\sum_{i} \lambda_{i}x_i \in S$$
This sum is called a _Convex combination of $x_{1}...x_{n}$_
- The set of the _convex combinations_ of any $n$ vectors of $R^k$ is the hyper-polygon traced by them

## Convex Function
For $f: S\to R$ where $S \subseteq R^{n}$ is _convex_, $f$ is called: 
1. _Convex_:$$f(\lambda x + (1-\lambda) y) \le \lambda f(x) + (1-\lambda) f(y)$$
2. _Strictly convex_ if the equality is only true for $x = y$
3. _Quasi-Convex_:$$f(\lambda x + (1-\lambda)y) \le \max(f(x), f(y))$$
4. _Strictly quasi-convex_ if the equality is only true for $x = y$
5. _Pseudo-Convex_: #TODO Only if it is ever needed


### Theorem 3.1.2
$f$ convex $\implies$ $f$ continuous

### Theorem 3.1.3
If $f$ is _convex_
$$\begin{align*}
f\left(\sum\limits \lambda_{i} x_{i}\right) \le \sum \lambda_{i}f(x_{i})\\\\

\forall x_{i} \in S,\lambda_{i} > 0, \sum \lambda_{i} = 1
\end{align*}$$
- If $f$ is _strictly convex_ then the equality is true iff: $x_{1} = x_{2} =...=x_{n}$.

### Theorem 3.1.4
If $f$ is _Convex_ local minima of $f$ are also global. If $f$ is _strictly convex_ they are also unique.

### Theorem 3.1.5
$f$ is _Convex_ iff:$$\nabla f^{T}(x_{1})(x_{1} - x_{2}) \le f(x_{2}) - f(x_{1}) ,\forall x_{1}, x_{2} \in S$$
- _strictly convex_ if the equality is true for $x_{1} = x_{2}$
(This is saying that the derivative is increasing, think Mean Value Theorem)


### Theorem 3.1.6
If the matrix $\nabla^{2}f > 0$ (positive definite) then $f$ is convex.
(Using this we can easily prove the convexity of multivariable funcs)


### Theorem 3.1.7
The sum of $n$ convex functions is convex

