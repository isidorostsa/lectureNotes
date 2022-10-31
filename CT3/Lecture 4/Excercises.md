## 1 
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
\end{align*}$$ since $u$ is a scalar $$\frac{\partial{J}}{\partial{u}}= 2b^TPx+2u$$so it has a minimum at $u=-b^TPx$, which somewhat minimizes usage of our controller and $\dot V$ meaning time to reach the $V=0$
(Note: All matrix expressions that result in a scalar are equal to their transpose)

## 2
$$\dot x =Ax + g(x)$$
$$x ,g(x) \in \mathbb{R}^{n}, \space A\in \mathbb{R}^{n \times n} $$
$A$ is asymptotically stable, $$\|{g(x)}\| \le \mu \|{x}\|, \space \mu >0$$
define $$A^{T}P+ PA = -Q > 0$$
1. Find $\mu$ so $x_{e}$ asymptotically stable
$$\begin{align*}
V &=  x^TPx\\
\dot V &= ... = -x^{T}Qx + 2x^{T}Pg(x) \\
&\le -\lambda_{min}(Q)\|{x}\|^{2}+ 2\|{x}\|\|{P}\| \|{g(x)}\| \\
&\le -\lambda_{min}(Q) \|{x}\|^{2}+2\|{x}\|^{2} \|{P}\|\mu\\
&= \|{x}\|^{2}(2\|{P}\|\mu -\lambda_{min}(Q)) 
\end{align*}$$ So we want $\mu$ to make this $< 0$ ..... taking $Q = I$ and solving the lyapunov eq. 
2. To make this asymptotically stable we want $$\dot V  \le -a \|{x}\|^2 $$so solve again for $\mu$.
3. prove that $x_{e}= 0$ of following system is exponentially stable$$\begin{align*}
\dot x &=  \left[\begin{matrix*}
x_{2}(\sin (x_{2}) -5)\\
-3x_{2} + x_{1} \left(6+\frac{1}{x_{2}^{2}+1}\right)
\end{matrix*}\right] \\
&= \left[\begin{matrix*}
0 & -5\\
6 & -3
\end{matrix*}\right] x + \left[\begin{matrix*}
x_{2} \sin (x_{2} )\\
\frac{x_{1}}{{x_{2}^{2} + 1}}
\end{matrix*}\right]
\end{align*}$$ take the second vector $=g(x)$ and prove that $\|{g(x)}\| \le \|{x}\|^2$, so $\mu = 1$ and we can easilly prove that it covers the requirements of 1. and 2., solving for $Q = I$ and $P$ with the lyapunov equation. (Note: we take $Q = aI$ almost always because we want all states to tend to 0 with the same uniform speed).

## 3. 
$$\begin{align*}
\dot x &= Ax + bu\\
y &= c^{T}x\\
x,b,c &\in \mathbb{R}^{n},\space A \in \mathbb{R}^{n \times n}\\
u, y &\in \mathbb{R}  \\
u &= \text{sat}(ky)
\end{align*}$$
1. $$\begin{align*}
\dot x &= Ax + b \text{sat}(ky) \\
&= Ax + kbc^{T}x + b (\text{sat}(ky) - ky)\\
&= \tilde A x + b u_{d} \text{    (just grouping stuff)}
\end{align*}$$ So $\tilde A$ system is easy around $x=0$, also $u_d$ is bounded by $\|{ky}\|$, and also we can change the eigenvalues of $\tilde A$. $$\begin{align*}
V &= x^{T}Px\\
\dot V &= -x^{T}\tilde Q x + 2b^TPxu_{d}\\
&\le ...   
\end{align*}$$

## 4.
$$\begin{align*}
\dot x_{1} &= x_{2}\\
\dot x_{2} &= -x_{1} - 3x_{2} +0,25x_{3} ^2\\
\dot x_{3} &= x_{1} x_{3} -x_{3} 
\end{align*}
$$
So we have 3 e.p. : $(0, 0, 0), \space (1, 0 ,2), \space (1, 0, -2)$ and we find out if they are stable by calculating the eigenvalues of the Jacobian around each point. $$...$$

