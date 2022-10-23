# Lyapunov for Autonomous Systems

### Quadratic Lyapunov scalar function:
$$V(x) = x^TCx$$ where $$C \in R^{n \times n}, \space C^T = C \succ 0$$
- So _$V$ represents the norm of $x$ on a scaled and rotated version of the coordinate system_. As a transformation, $C$ maps the unit circle to an ellipse of arbitrary orientation and size.
- This is an effective way to approximate many systems' "natural" lyapunov function with relatively few parameters to tune.

For $\dot x(t) = f[x(t)]$ and $V(x) = (x-x_e)^TC(x-x_e)$ (lyapunov centered at $x_e$):
- $x_e$ is stable if $$\frac{dV[x(t; x_0, t_0)]}{dt} \le 0, \space\forall t \ge t_0, \space \forall x_0 \in \mathbb R^n$$
Usual Lyapunov Definitions hold:
- If $\exists r > 0:$ 
	1. $V(x)$ positive definite in $G_r$ (sphere centered at $x_e$ with radius $r$)
	2. $V(x) \rightarrow \inf$ as $||x|| \rightarrow \inf$ (else $\inf$ might be an "e.p.") Meaning $V$ is not _radialy bounded_.
	3. $- \dot{V}(x)$ positive semidefinite in $G_r, \space \forall t \geq t_0$ 
	then $x_e$ is asymptoticaly stable.

## Region of attraction

The region of attraction of some e.p. is defined: $$D(x_e) = \{x_0 \in \mathbb R^n: x(t; x_0, t_0) \rightarrow x_e \}$$
# Lyapunov for Non Autonomous Systems
$$\begin{split}
\frac {\partial V(\vec x(t), t)}{\partial t} & = \frac {\partial V(\vec x, t)}{\partial \vec x}\frac{\partial \vec x(t)}{\partial t} + \frac {\partial V(\vec x, t)}{\partial t} \\ & = \text{spacial change + temporal change}
\end{split}
$$

#### class-$K$ functions:
1. $\psi(0) = 0$ 
2. $\psi(||x||) > 0, \space \forall ||x||>0, \space x \in G_{r}$
3. $\psi$ continuous and strictly increasing in $G_{r}$ 
class-k functions are like the _norm_ except for the triangular inequality.
- If $\lim_{x\to\infty} \psi(x) = \infty$ then $\psi \in K_{\infty}$ (class $K_\infty$)

### Positive definite for N.A. systems:
1. $V(0, t) = 0$
2. 
	- $V(x, t) \ge \psi(\|x\|), \space \forall x \in G_{r}, \space \forall t \ge t_{0}$ for $\psi$ some class-$K_\infty$ function
	OR
	- $V(x, t) \ge V_0(x), \space \forall x \in G_{r}, \space \forall t \ge t_{0}$ for $V_{0}(x)$ some positive definite and not radialy bound function.
So there is a lower bound to $V$ dependant only on the state.

### Upper boundedness for N.A. systems:
A function $V(x, t)$ is bound upwards in $G_{r}$ if:
- there exists class-$K$ function $\phi$ such that:$$V(x, t) \le \phi(\|x\|), \space \forall t \ge t_{0}, \space x \in G_{r}$$
OR
- there exists positive definite function $V_1$ such that:$$V(x, t) \le V_{1}(x), \space \forall t \ge t_{0}, \space x \in G_{r}$$
For example for $V(x, t) = x_{1}^{2}+ 2x_{2}^{2}(1 + e^{-t})$ we could have $$\begin{align*}
\phi(\|x\|) &= \|x\|^{2}+ 4\|x\|^{2}\\ \psi(\|x\|) &= \|x\|^2
\end{align*}$$so$$\phi(\|x\|)\ge V(x, t) \ge \psi(\|x\|),\space \forall x \in \mathbb{R}^{n}, \space \forall t \ge t_{0}$$then depending on the distance from the origin $V$ is bound both up and down no matter the time, in a way that means it hits $\infty$ when $\|x\| \to \infty$ . 

### homeomorphic stability (doesn't escape)
If $\dot V(x(t), t) \le 0, \space \forall t \ge t_{0}$ then if we pick any arbitrary max distance $\varepsilon$ from the origin we can find some starting distance $\|{x_{0}}\| = \delta \le \varepsilon$ for which the orbit never goes past $\varepsilon ,\space \forall t \ge t_{0}$. If $\psi(\|{x_{0}}\|) = $



Being both up and down bound by class k functions means you can have a global minimum only at 0, you can not have a global max either.