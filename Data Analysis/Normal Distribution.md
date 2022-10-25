A normal distribution of variance $1$ and mean $0$ looks like:$$f(z)=\frac{1}{\sqrt{2\pi}}e^{-\frac{z^2}{2}}$$Here is is centered around $0$. We can take a normal distribution of arbitrary mean $\mu$ and variance $\sigma^2$ : $X \sim N(\mu, \sigma^2)$ and map it to $f$ with:$$Z = \frac{X - \mu}{\sigma} \sim N(0, 1)$$And then we can use the table for $\phi(z) = P(Z \le z)$ to calculate the probabilities of $X$ taking certain values.

N.D. is important cause:
1. Central Limit Theorem: For ${X_{i}}$ _independent_ random variables $$\sum\limits X_{i} $$