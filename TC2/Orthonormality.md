A set of [[Signal|singlals]] $\phi_1(t), \phi_2(t)...\phi_M(t) \in \mathbb{S}$ where $\mathbb{S}$ is a [[Signal Space]] is orthonormal iff:$$\forall \phi_i, \phi_j: \langle\phi_i, \phi_j\rangle=
\left\{
	\begin{array} {ll}
		0 & \text{if } i \neq j \\
		1 & \text{if } i = j 
	\end{array}
\right.$$If a space is orthogonal (meaning only the $i\neq j$ is satisfied from the above equation) then we can conclude that the set $$\{\theta_i = \frac{\phi_i}{||\phi_i||}, \, i =\text{1,2...M}\}$$is orthonormal.

Any signal $s_i(t)$ belonging in a [[Signal Space]] $s_1, s_2,...,s_M$ can be expressed as a linear combination of an orthonormal basis $\phi_1, \phi_2,...,\phi_N$, with $N\leq M$ $$s_i(t)=\sum_{j=1}^N a_{ij}\phi_j(t)=\sum_{j=1}^N \langle s_i,\phi_j \rangle \, \phi_j(t)$$So $s_i$ has in the basis of $\phi_i$ coordinates:$$\bf{s_i}=\{
\langle s_i,\phi_1 \rangle ,
\langle s_i,\phi_2 \rangle ,...,
\langle s_i,\phi_N \rangle \}$$If we have $$\textbf{s}_1 = \{a_1, a_2,...,a_N\}$$$$\textbf{s}_2 = \{b_1, b_2,...,b_N\}$$then$$\langle s_1, s_2 \rangle = a_1b_1 + a_2b_2 +...$$$$||s_1(t)||=\sqrt{|a_1|^2 + |a_2|^2+...}$$$$d_{s_1,s_2}=\sqrt{|a_1-b_1|^2+...}$$
## Example excersise (6.1)

We use the [[Isidoros' amazing sigma function]] for ease of notation.

Define the waveforms: $$\begin{array}{ll}
\phi_1(t) =\frac{1}{2}\sigma_{0,2}(t)-\frac{1}{2}\sigma_{2,4}(t)\\
\phi_2(t) =\frac{1}{2}\sigma_{0,4}(t)\\
\phi_3(t) =\frac{1}{2}\sigma_{0,1}(t)-\frac{1}{2}\sigma_{1,2}(t)+\frac{1}{2}\sigma_{2,3}(t)-\frac{1}{2}\sigma_{3,4}(t)\\
\end{array}$$
1. Prove they are an orthonormal basis.
	We first prove they all have norms $||\phi_n|| = \sqrt{\int_{0}^{4}|\phi_n|^2\,dt} = 1$  (trivial)
	Then prove all pairs $\phi_i,\phi_j$ have $\langle \phi_i, \phi_j \rangle = 0, \text{ if } i \neq j$ (trivial) 
2. Define: $$s(t) = -\sigma_{0,1}(t) + \sigma_{1,3}(t)-\sigma_{3,4}(t)$$can we express $s$ in terms of the basis $\phi$?
	Since $\phi_n$ are  orthonormal, if $s$ belongs to their span then we can calculate it's coordinates though inner products with each basis vector, and after multiplying the basis vectors with the coordinates we should get back $s(t)$.  However all three inner products turn out to be equal to zero meaning $s(t)$ is linearly independent from the basis vectors, and thus we can't express it in terms of $\phi$ .
---
We can algorithmicaly construct an equivalent orthonormal basis given some arbitrary basis $s_i$ using the [[Gram-Schmidt process]].