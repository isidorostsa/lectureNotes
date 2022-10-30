## Lasalle Theorem

In an _Autonomous System_ $$\dot x(t) = f(x(t)), \space x(t_{0}) = x_{0}, \space x_{e}= 0$$ If $\exists r > 0$:
1. $V(x) \text{ def. positive } \forall x \in G_{r}$
2. $\dot V (x) \le 0, \space \forall x \in G_{r}, \space \forall t \ge t_{0}$ 
3. $$\lbrack{\begin{align*}
\dot V(x(t)) &= 0, \space \forall t \ge t_{0} \\
x(t) &\in G_{r}
\end{align*}}\rbrack \implies x(t) =0 , \space \forall t \ge t_{0}$$

Then $x_{e}$ is _asymptoticaly stable_.

- If $G_{r} = \mathbb{R}$ then the stability is _Global_ 

### Example:
$$\begin{align*}
\dot x_{1} &= \dot \theta = x_{2}\\
\dot x_{2} &= \ddot\theta = -a \theta - k sin (\theta)     
\end{align*}$$
For $$V(x) = k(1- cos(x_{1}))$$