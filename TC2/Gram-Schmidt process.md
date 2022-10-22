Given a set of $M$ signals, $s_1(t),...,s_M(t)$ spaning a [[Signal Space]] $\mathbb{S}$, we can find an [[Orthonormality|orthonormal]] basis $\phi_1(t),...,\phi_N(t)$ of dimension $N\leq M$ for $\mathbb{S}$.

The process:
1. Define $$g_1(t) = s_1(t)$$The first base signal is $$\phi_1(t) = \frac{g_1(t)}{||g_1(t)||}$$
2. Define $$g_2(t)=s_2(t)-\phi_1(t)\,\langle s_2, \phi_1 \rangle$$This is just $s_2(t)$ **without** the $\phi_1(t)$ component, so by design it will be [[Orthogonality|orthogonal]] to $\phi_1$, which represents all the basis signals we have for now. Now we normalise $g_2$ to obtain:$$\phi_2(t) = \frac{g_2(t)}{||g_2(t)||}$$
3. Generalizing for the rest of $s_i$, in step number $k$, define $$g_k(t) = s_k(t) - \sum_{i=1}^{k-1}\phi_i(t)\,\langle s_i, \phi_i \rangle$$and $$\phi_k(t) = \frac{g_k(t)}{||g_k(t)||}$$constructing once again a signal [[Orthogonality|orthogonal]] to the rest of the basis signals, until we have a complete basis.

## Example excersise (6.2)

Using the [[Gram-Schmidt process]] find an orthonormal basis for the signal space of $s_1, s_2, s_3$ with:$$
\begin{array}{ll}
s_1(t) = A\sigma_{0,T}(t)\\
s_2(t) = -A\sigma_{0,T/2}(t)\\
s_3(t) = -A\sigma_{0,T/2}(t)+A\sigma_{T/2,T}(t)\\
\end{array}
$$The process is:
1. $$g_1(t) = s_1(t)$$and normalizing:$$\phi_1(t) = \frac{g_1(t)}{||g_1(t)||} = \frac{1}{\sqrt{T}}\sigma_{0,T}(t)$$
2. $$
\begin{split}
g_2(t) & = s_2(t) - \phi_1(t) \langle s_2, \phi_1 \rangle \\
& =-A\sigma_{0,T/2}(t) + \frac{1}{\sqrt{T}}\sigma_{0,T}(t) A \frac{1}{\sqrt{T}}\frac{T}{2} \\
& = -\frac{A}{2}\sigma_{0,T/2}(t) + \frac{A}{2}\sigma_{T/2,T}(t)
\end{split}
$$and normalizing:$$\begin{split}
\phi_2(t) & = \frac{g_2(t)}{T/2*3A/2+T/2*A/2}\\
&= -\frac{1}{\sqrt T}\sigma_{0,T/2}(t) + \frac{1}{\sqrt T}\sigma_{T/2,T}(t)
\end{split}$$
3. $$
\begin{split} g_3(t) & = s_3(t) - \phi_1(t) \langle s_3, \phi_1\rangle-\phi_2(t) \langle s_3,\phi_2 \rangle \\
&= 0
\end{split}$$so the basis is complete with $\phi_1$ and $\phi_2$ 






















