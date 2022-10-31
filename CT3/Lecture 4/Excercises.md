$$\dot x =Ax + bu$$
$$A = [-1,0;0,-2], b=[1;1]$$

1. For the closed loop system we have:
$$A^{T}P+PA=-Q \space \space (1)$$
- $$P^{T}  = P >0$$so $$\begin{align*}
p_{11} > 0\\
p_{11}p_{22} - p_{12}^{2} > 0
\end{align*}$$
For $$Q = \left[\begin{matrix*}
q_{1} & 0\\
0 & q_{2}
\end{matrix*}\right]$$
$$(1) \implies \begin{align*}
p_{11}=\frac{q_{1}}{2}\\
p_{22}=\frac{-q_{2}}{2}
\end{align*}$$
And we take $$p_{12}=0$$
2. We want to minimize the expression$$J = \dot V  + u^2$$We assume a quadratic lyapunov:$$\begin{align*}
V &= x^{T}Px\\
\dot V &= ...=x^T(A^{T}P+PA)x+2ub^TPx\\
&= -x^{T}Qx+ 2ub^TPx
\end{align*}$$ since $u$ is a scalar $$\frac{\partial{J}}{\partial{u}}= 2b^TPx+2u$$so it has a minimum at $u=-b^TPx$, which somewhat minimizes usage of our controller and $\dot V$ meaning time to reach the 
(Note: All matrix expressions that result in a scalar are equal to their transpose)