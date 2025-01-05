We map bit strings $\set{a_1, a_2,...,a_K}$ to waveforms $s_1(t),...,s_M(t)$, $M = 2^K$ belonging to a [[Constellation]]. Each of the waveforms has coordinates $s_i(t) = \set{s_{i1}, s_{i2},...,s_{iN}}$ so we transmit $s_i(t)$ as $$s_i(t)=\sum_{j=1}^N s_{ij}\phi_j(t)$$where $N$ is the [[Dimension]] of the [[Signal Space]] of the [[Constellation]].  This mapping proccess is called [[Modulation]].

To recap: 
- We want to transmit a series of N bits. We split it in chunks of K-bits each. Each chunk is mapped into a [[symbol]]. Our constellation is comprised of $M = 2^K$ symbols. Each symbol is a linear combination of one of the N basis signals, i.e. it is a point in an N-dimemnsional symbol space. Each waveform takes time $T$ to tansmit.


- When $N=2$ we call it [[I/Q Modulation]].

 We choose a type of [[Modulation]] by considering the [[noise]] it has to withstand.
 