## Convex Set
A set $S \subseteq R^n$ is called convex iff:$$\forall x, y \in S: \lambda x + (1 - \lambda ) y = z \in S, \space \forall \lambda \in [0, 1]$$
### Theorem 3.1.1
For $S$ _convex_, $x_{1},...,x_{k} \in S$ then for $\lambda_{1},...,  \lambda_{k}$ with $\sum \lambda_{i} = 1$ then:$$\sum_{i} \lambda_{i}x_i \in S$$
This sum is called a _Convex combination of $x_{1}...x_{n}$_
- The set of the _convex combinations_ of any $n$ vectors of $R^k$ is the hyper-polygon traced by them

## Convex Function
For $f: S\to R$ where $S \subseteq R^{n}$ is convex, $f$ is called convex if:
- $f(\lambda x + (1-\lambda) y) \le \lambda f(x) + (1-\lambda) f(y)$ 


$$\begin{align*}
f\left(\sum\limits \lambda_{i} x_{i}\right) \le \sum \lambda_{i}f(x_{i})\\\\

\forall x_{i} \in S,\lambda_{i} > 0, \sum \lambda_{i} = 1
\end{align*}$$
- If $f$ is _strictly convex_ then the equality is true iff: $x_{1} = x_{2} =...=x_{n}$.
- Local minima of $f$ are also global. If $f$ is _strictly convex_ they are also unique.
- 

