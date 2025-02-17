In this [[noise]] model we consider an intermediate between the sender and the reciever in which Gaussian noise is added. As such the recieved signal is:$$r(t) = s(t) + n(t)$$
- The [[Spectral Power Density]] of $n(t)$ is constant accross all frequences:$$S_n(f)=N_0/2,\,f
\in (-\infty, \infty)$$
- The [[Self Similarity]] function of $n(t)$ is$$R_n(t)=\frac{N_0}{2}\delta(t)$$ meaning that even for small time differences there is no self similarity.
-  The amplitude of $n(t)$ follows a Gaussian Distribution with a [[Probability Density Function]] of$$f_n(x)=\frac{1}{\sqrt{2\pi\sigma^2}}e^{-\frac{x^2}{2\sigma^2}}$$with an average value of $0$ and variance equal to $\sigma^2$.
- The [[Commucative probability function]] of $n(t)$ is$$F_n(x)=\int_{-\infty}^{x/\sigma}f(y)\,dy=1-Q(\frac{x}{\sigma})$$ 
### White vs Gaussian:
- The white part refers to the spectral power being constant accross all frequencies.
- The Gaussian part refers to the destribution of the amplitudes of sampled points following a bell curve.
In this Image we see that Non-Gaussian white noise (U distr. instead of Gauss) the amplitudes do not cluster around 0, and instead are equally spread out in $[-1, 1]$.
![[Pasted image 20250106201408.png]]

where $Q$ is the [[Q-function]].

 - It is used to simmulate the common problem case of telecomunications.

### Typical signal:
$$r(t) = s_i(t) + n(t)$$ where $s_i$ is the [[symbol]] and $n$ the gaussian white noise. This is given to be [[Demodulation]]