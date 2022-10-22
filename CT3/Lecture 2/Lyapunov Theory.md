
Tetragonical Lyapunov scalar function:$$V(x) = x^TCx$$ where $$C \in R^{n \times n}, \space C^T = C \succ 0$$
- So _$V$ represents the norm of $x$ on a scaled and rotated version of the coordinate system_. As a transformation, it maps the unit circle to an ellipse of arbitrary orientation and size. 

- This is an effective way to approximate many systems' "natural" lyapunov function with relatively few parameters to tune.

For $\dot x(t) = f[x(t)]$ and $V(x) = (x-x_e)^TC(x-x_e)$:
- $x_e$ is stable if $$\frac{dV[x(t; x_0, t_0)]}{dt} \le 0, \space\forall t \ge t_0, \space \forall x_0 \in \mathbb R^n$$
Usual Lyapunov Definitions hold:
- If 