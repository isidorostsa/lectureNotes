A constellation is a collection of $M$ [[Signal|signals]] in a [[Signal Space]] $\mathbb{S}$. 
- Each signal is represented with a point in the constellation and it matches a certain [[Waveform]]/[[Symbol]]. All waveforms belong to the same [[Orthonormality|orthonormal]] basis. 
- The average energy of a constellation is given by:$$\mathcal{E}_{\mathbb{S}} = \sum_{i=1}^M|| \textbf{s}_i ||^2 \text{Pr}(\textbf{s}_i)$$where$$||\textbf{s}_i||^2 = \sum_{j = 1}^N s_{ij}^2$$$s_{ij}$ being the $j$-th component of the $i$-th [[Symbol]] and $\text{Pr}(\textbf{s}_i)$ is the proportion of the times we send that [[Symbol]].
- To reduce the average energy we need to place the symbols closer to $\vec 0 = \lbrack 0,0,...,0 \rbrack$, however this reduces their [[Eucledian Distance]], which is critical to [[error rate]].

The important take away is that a signal $s_i(t)$ of a [[Signal Space]] with [[Dimension]] $M$ and basis functions $\phi_1(t),...,\phi_M(t)$ can be considered as a vector of an $M$-dimensional vector space$$\textbf{s}_i=\set{s_{i1}, ...,s_{iM}}$$
The waveforms are transmitted through a [[digital communications chanel]] 