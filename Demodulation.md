### Definition:
Extracting the components of a modulated signal. I.E.:
$$r(t) \rightarrow (r_1, r_2, ...)$$ with $$r_{i}= \int_0^Tr(t)\phi_i(t)dt$$ 

but $$r_{j} = <r, \phi_j>$$
$$= s_{ij} + n_j$$
where $n_j$ is the j-th component of the noise and $s_{i}= (s_{i1}, s_{i2},...)$

This means that $r_j$ is a random variable, with $$E[r_{j}] = s_{ij}$$ and $$\sigma^{2} = \frac {N_0} {2}$$ 
So to wrap this:$$f(r|s_{i})= \text {some expression dependent on: } ||r - s_{i}||^2$$
