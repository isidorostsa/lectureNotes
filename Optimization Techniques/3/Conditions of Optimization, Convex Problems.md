## Optimization Problems
Sample Problem:$$\text{Find } x \in X \subset R^{n} \text{ to minimize } f(x) \text{ and satisfy } g_{i}(x) \le 0, \space i = 1,2,\dots,m$$
- $f$ is called _objective function_
- $g_{i}$ are called _constraints_
- every $x \in X$ that satisfies the _constraints_ is called a _feasible point_ of the problem
- The set $F: \set{x \in X: g_{i}(x) \le 0, \space i = 1, 2,\dots, m}$ of _feasible points_ is called the _feasible region_ of the problem.
- If $F \neq 0$ The Problem is called _Consistent_
- If $\exists x \in F : g_{i}<0, \space i = 1,2,\dots,m$ the problem is called _super - consistent_. 

If $\exists x^{\star} \in F: f(x^{\star}) \le f(x), \space  \forall x \in F$ then $x^{\star}$ is called a _Solution_ to the problem.


## MF
We call $MF$:$$\begin{align*}
\text{MF}  =  &\inf_{x \in X, \space g_{i}(x) \le 0} {f(x)} 
\end{align*}$$This is the greatest lower bound (infimum) of $f$'s value in $F$.

- If $f, X, g_{i} \forall i$ are all convex then the problem is called _convex_

#### Example 3.2.1
$$x \in R: \text{Minimizes } f(x)=e^{x} \text{ and satisfies } g_{1}(x)=x \le 0$$
Here $\mathcal{F} = \set{x \in R: x \le 0}$ so $$\text{MF} = \inf_{x \le 0} {e^{x}} =0$$But there is no $x^{\star}: f(x^{\star} ) = \text{MF} = 0$ 


## MF sensitivity to restraints
Knowing the $MF$ of some problem, we want to examine the problem: $$\text{MF}(z) = \inf_{x \in X, \space g_{i}(x) - z_{i} \le 0} f(x) $$
If the initial problem $\text{MF}$ is convex, then $\text{MF}(z)$ is a convex function of $z$. 