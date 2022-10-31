Given a set of $n$ samples of $X$, we want to figure out it's distribution. We have 3 methods:
1. Predict a parametrized distribution and find the parameters that fit the data best.
2. Nonparametric 
3. Resampling

## Point Estimation

The value $\hat \theta$ that we estimate $\theta$ to have given the sample data. This should make sure that data fall as close as possible to $F_X(x;\hat \theta)$ 

Specifically, given $x = \set{x_{1},...,x_n}$ we estimate it using $\hat \theta = g(x)$, and $g$ is called the _estimator_.
_Important:_ $x$ is a set of samples of $X$ so $\hat \theta$ is a *Random Variable*. Also $x_{1},x_{2}...$ are also _Random Variables_.

So $\hat \theta$ has a mean and a variance. 

### Important Parametric Estimators
Mean: $$\hat \mu = \bar x = \frac{1}{n}\sum\limits^n_{i=1}x_i$$
Variance:$$s^2=\frac{1}{{n-1}}\sum\limits^n_{i=1}(x_{i}-\bar x)^2$$
_Intuition_: We use $\frac{1}{{n-1}}$ instead of $\frac{1}{n}$ because by using the estimator for the mean, instead of the true mean, we rig the data to be a little closer to what we consider the mean, so the sum is smaller that is should, and we use that substitution to compensate that.
[Bessel's correction - Wikipedia](https://en.wikipedia.org/wiki/Bessel%27s_correction)

### Metrics for good estimators
1. $E[\hat \theta ] = \theta$
Otherwise we define bias: $b(\hat \theta) = E[\hat \theta ] - \theta$
2. As small variance as possible.
Define mean square error: $MSE[\hat \theta] = b(\hat \theta )^{2}+ \sigma_{\hat \theta }^{2}= E[(\hat \theta - \theta )^2]$  

### Finding The Estimator using Maximum Likelihood

Define $L(x;\theta) = f(x_{1};\theta )...f(x_{n};\theta )$ where $f$ is the distribution we are trying to estimate. So we find $\theta$ to maximize $L$: (we maximize $log(L)$ for easier calculations) $$\frac{d \space logL}{d \space \theta } = 0$$
For the normal distribution:
#TODO 


(Examples are in ex 1, 2)
## Estimating confidence intervals

Because $\bar x$ is unbiased: 
- $\mu_{\bar x} = E[\bar x] = \mu$ 
It has variance: $$\sigma_{\bar x}^{2}= \text{var}[\bar x] = \text{var}[\frac{1}{n} \sum\limits x_{i}]= \frac{1}{n^{2}} \sum\limits\text{var} \left[ x_{i}\right] = \frac{1}{n^{2}} (n \sigma ^{2}) = \frac{\sigma^{2}}{n}$$and as such _Standar deviation_: $\sigma_{\bar x} = \frac{\sigma}{\sqrt{n}}$
_This is the standard deviation of $\bar x$ from $\mu$ depending on our sample size $n$_

From the _Central Limit Theorem_, because $\bar x$ is just a sum of independant random variables divided by a constant we know that it will follow a normal distribution $N(\mu, \frac{{\sigma ^ 2}}{n})$. _BUT_ we have no way of definitevely knowing $\sigma$, so we have to use the sample diaspora $s^{2}$. The distribution this follows is _NOT_ the normal, but _Student distribution n - 1_. 

The normalized $\bar x$: $\frac{\bar x - \mu}{s / \sqrt{n}} \sim t_{n-1}$ which is a squished-down and spread out, more uncertain version of the normal distribution, which for large enough $n$ ($\ge 30$) approaches it.

The above means: $$P()$$























