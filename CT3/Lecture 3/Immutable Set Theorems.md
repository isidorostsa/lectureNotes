## Lasalle Theorem for Asymptotic Stability

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

### Immutable Set Theorem:
In an _Autonomous System_ $$\dot x(t) = f(x(t)), \space x(t_{0}) = x_{0}, \space x_{e}= 0$$Let $V(x)$:
1. $$S_{a}= \set{x \in \mathbb{R}^n:V(x)<a}$$is a bounded region.
2. $$\dot V(x) \le 0, \space \forall x \in S_{a}$$
3. $$Z(S_{a}) = \set{x \in S_{a}: \dot V(x) = 0}$$
4. $M_{Z(S_a)}$ is the biggest of all immutable sets within $Z(S_{a})$ 
Then:
- If $x_{0} \in S_{a} \implies x \to M, \space t \to \infty$.   

_IMPORTANT FOR STUDYING SYSTEMS WITH STABILITY SETS INSTEAD OF POINTS_

## Lyapunov Theorem For Field of Attraction
In an _Autonomous System_ $$\dot x(t) = f(x(t)), \space x(t_{0}) = x_{0}, \space x_{e}= 0$$
With $S_a$ as above, if $V(x)$ $\dot V(x)$ positive definite $\forall x \in S_{a}$ then $S_{a} \subset D(x_e)$. 

And the stronger version:
If:
1. $V(x)$ definite positive $\forall x \in S_a$ 
2. $\dot V(x) \le 0, \space \forall x \in S_a$ 
3. $$\left[{\begin{matrix*}
\dot V(x(t)) = 0, \space \forall t \ge t_{0} \\
\dot x(t) = f(x(t)) , \space \forall t \ge t_{0}\\
x(t) \in S_{a}
\end{matrix*}}\right] \implies x(t) =0 , \space \forall t \ge t_{0}$$
Then $S_{a} \subset D(x_e)$.


## Barbalat Lemma

If:
1. $f(t) \to \infty, t \to \infty$ 
2. $\dot f(t)$ uniformly continuous (not like $\frac{1}{x}$ , values of nearby $x$ can't evolve infinitely apart)
*($\dot f$ bounded $\implies f$ uniformly continuous)*
Then:
- $\dot f (t) \to 0, t \to 0$ 

## Lyapunov type Lemma
If:
1. $\exists k < \infty: \space V(x, t) \ge k, \forall x,t$
2. $\dot V(x, t) \le 0$ 
3. $\dot V$ uniformly continuous both in respect to $t$ 
Then:
- $\dot V(x, t) \to 0, t \to \infty$
### Example:
$$\begin{align*}
\dot e &= -e + \theta w(t)\\
\dot \theta &= -e w(t), \space \space w(t) < k, \space k < \infty 
\end{align*}$$
With $$V = e^{2} + \theta ^2$$
1. $V(t) > 0$
2. $\dot V = -2e^{2}\le 0$ 
1, 2 $\implies V(t) \le V(0) \implies e, \theta$ bounded
3. $\ddot V =  -4e(-e+\theta w)$ is bounded $\implies \dot V$
