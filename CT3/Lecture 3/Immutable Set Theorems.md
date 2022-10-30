## Lasalle Theorem

In an _Autonomous System_ $$\dot x(t) = f(x(t)), \space x(t_{0}) = x_{0}, \space x_{e}= 0$$ If $\exists r > 0$:
1. $V(x) \text{ def. positive } \forall x \in G_{r}$
2. $\dot V (x) \le 0, \space \forall x \in G_{r}, \space \forall t \ge t_{0}$ 
3. $$\left[{\begin{matrix*}
\dot V(x(t)) = 0, \space \forall t \ge t_{0} \\
\dot x(t) = f(x(t)) , \space \forall t \ge t_{0}\\
x(t) \in G_{r}
\end{matrix*}}\right] \implies x(t) =0 , \space \forall t \ge t_{0}$$

Then $x_{e}$ is _asymptoticaly stable_.

- If $G_{r} = \mathbb{R}$ then the stability is _Global_ 

### Example:
$$\begin{align*}
\dot x_{1} &= \dot \theta = x_{2}\\
\dot x_{2} &= \ddot\theta = -a \theta - k sin (\theta)     
\end{align*}$$
For $$\begin{align*}
V(x) &=  k(1- cos(x_{1})) +  \frac{x_{2}}{2}\\
\dot V(x) &= -a x_{2}^2 
\end{align*}$$ 
1. $V(x) \text{ def. positive } \forall x \in G_{r}, \space r \in [0, 2\pi)$ 
2. $\dot V(x) \le 0$
From those two we deduce $x_{e}= 0$ is _stable_.
But since $- \dot V$ is not definite positive, we need to invoke Lasalle:

1. $\dot V = 0 \implies x_{2} = 0$
2. $$\left[\begin{matrix*}
\dot x_{1} = x_{2} \\
\dot x_{2} = -a x_{2} - k sin (x_{1}) \\
x_{2} = 0
\end{matrix*}\right]
\implies
x_{1} = 0, \pi, 2\pi, 3\pi ...
$$But $x \in G_{r} \implies x_{1} = 0 \implies x = 0, \space \forall t \ge t_{0}$. 
By Lasalle: $x_{e}= 0$ is asymptoticaly stable.

Another way of going about this is: 
2. If $x \in \set{x: x_{2} = 0}, \space \forall t \ge t_{0} \implies \dot x_{2} = -a sin(x_{1}), \space {x \in G_{r}} \implies x_{1} = 0$ other wise $\exists t: x_{2} \neq 0$ .  


## Immutable Set
M is immutable if:
$$x_{0} \in M \implies x(t) \in M, \space \forall t$$_x once in M $\implies$ x stays in M_





