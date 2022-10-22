Main model is:$$\dot{x}(t) = f \lbrack x(t), u(t), t \rbrack$$ where $x, u, f \in \mathbb{R}^n$ 

- e.g. $f$ can be linear: $$f = A(t)x + b(t)u$$
We study known input -> known output

### Controllers:
- Static state feedback:$$u = u(x, t)$$
- Dynamic state feedback:$$u = u(z, x, t), \space \dot{z} = g(z, x, t)$$
### Non-Linear systems: (ΜΓΣΕ)
$$\dot{x} = f[x(t), t]: \space x(t_0) = x_0$$
- e.g. $$\dot{x} = A(t)x$$
We classify them based on external factors affecting them as:

1. Autonomus Systems: $$\dot x(t) = f[x(t)]$$
2. Non-Autonomus Systems:$$\dot x(t)=f[x(t), t]$$
   - e.g. $\dot x = -x + u, \space u = -x^2 sin(t)$

So in general $$x = x(t; x_0, t_0)$$
## Equilibrium Points

In an open loop system, ($u$ is incorporated in $x$) $x_e \in \mathbb R^n$ is an e.p. iff $$f[x_e, t] = 0$$
- $X_e := \{\text {all eq. points}\} = \{x\in \mathbb R^n : f[x(t; x_0 = x), t] = 0 \}$

- NLS can have many such points 
- They can present as limit cycles, meaning periodic loops.

Homiomorfick 





