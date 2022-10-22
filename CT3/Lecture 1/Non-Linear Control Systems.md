Main model is:$$\dot{x}(t) = f \lbrack x(t), u(t), t \rbrack$$ where $x, u, f \in \mathbb{R}^n$ 

- e.g. $f$ can be linear: $$f = A(t)x + b(t)u$$
We study known input -> known output

### Controllers:
- Static state feedback:$$u = u(x, t)$$
- Dynamic state feedback:$$u = u(z, x, t), \space \dot{z} = g(z, x, t)$$
## Non-Linear systems: (ΜΓΣΕ)
$$\dot{x} = f[x(t), t]: \space x(t_0) = x_0$$
- e.g. $$\dot{x} = A(t)x$$
We classify them based on external factors affecting them as:

1. Autonomous Systems: $$\dot x(t) = f[x(t)]$$
2. Non-Autonomous Systems:$$\dot x(t)=f[x(t), t]$$
   - e.g. $\dot x = -x + u, \space u = -x^2 sin(t)$

So in general $$x = x(t; x_0, t_0)$$
## Equilibrium Points

In an open loop system, ($u$ is incorporated in $x$) $x_e \in \mathbb R^n$ is an e.p. iff $$f[x_e, t] = 0$$
- $X_e := \{\text {all eq. points}\} = \{x\in \mathbb R^n : f[x(t; x_0 = x), t] = 0 \}$

- NLS can have many such points 
- They can present as limit cycles, meaning periodic loops.

Ομοιόμορφη Ευστάθεια (αγγλικός όρος λείπει): The "range" and the nature of the e.p. does not depend on $t$.

- Limit Cycles always surround an E.Q. (Poincare theorem) 

- If an orbit of a $n = 2$ system stays in a finite region of $\mathbb R^2$ then one of the following is true: (Poincare-Bendixson theorem)
	1. It approaches an e.p.
	2. It approaches a stable or semi-stable limit cycle
	3. It is a limit cycle

- In a finite region $S$ of the state space there can not be a limit cycle uless the scalar quantity $$(\nabla f)[x] = \sum^n \frac {\partial f_i}{\partial x_i}$$changes sign or equals zero in some $x \in S$. (Bendixson theorem)






