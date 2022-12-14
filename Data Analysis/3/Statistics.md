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

The above means: 
For $t = \frac{\bar x - \mu}{s / \sqrt{n}}$: $$P(k \le t \le \lambda) = \int_k^{\lambda} t_{n-1}dt$$ To find the upper and lower bounds of $\mu$ withing some confidence interval of $1-a$ (meaning $P(\text{lower} \le \mu \le \text{upper}) = 1-a$)  we normalize the bounds, and solve for them using the integral, (in reality they will always be symmetric to $\mu$ so then they will become symmetric to $0$ which allows for the use of $t_{n-1}$ tables). Then for $\text{lower, upper} = \bar x - k, \bar x + k$ becomes:
$$\begin{align*}
\bar{x} -k &\le \mu &\le \bar{x} + k\\
-k  &\le \mu -\bar{x} &\le k\\
-\frac{k}{s / \sqrt{n}} &\le t &\le \frac {k}{s / \sqrt{n}}
\end{align*}$$
So
$$\begin{align*}
P(\bar{x} - k \le \mu \le \bar{x} + k) 
&= P\left(-\frac{k}{s / \sqrt{n}} \le t_{n-1} \le \frac {k}{s / \sqrt{n}}\right) \\
\end{align*}$$ and that is equal to $1-a$ so we define $$\frac{k}{s / \sqrt{n}} = t_{n-1,1 - {a}/{2}}$$ which we can then find in tables.

All in all: $$P\left(\bar{x} -t_{n-1, 1 - a/2}\frac{s}{\sqrt{n}} \le \mu \le \bar{x} + t_{n-1, 1 - a/2}\frac{s}{\sqrt{n}}\right)=1-a$$
## Confidence intervals for $\sigma^2$
Given a population $\set{x_{1}...x_{n}}$ we can estimate the variance as $s^{2}=\frac{1}{{n-1}}\sum {(x_{i}-\bar{x})^{2}}$. We want to find the distribution of $s^2$ for different populations. How accurate is our estimation?

A normalized version of variance would be 
The normalized $(n-1)s^2/\sigma^2$ follows a distribution of $\chi ^ 2$ with $n-1$ degrees of freedom. (the $n-1$ factor is to let the distribution change between sample sizes be appearent only within $\chi_{n-1}$)


So to calculate the confidence interval: $$\left[\frac {(n-1)s^{2}}{\chi^{2}_{n-1,1-a / 2 }},  \frac {(n-1)s^{2}}{\chi^{2}_{n-1,a / 2}}\right]$$

## Hypothesis Control

Four cenaria:
1. Correct decision: Accepting $H_0$ and it is correct $$P(\text {Accepted } H_{0}|H_{0}\text{ Correct} ) = 1-a$$
2. Type $II$ Error: Accepting $H_{0}$ without it being correct $$P(\text {Accepted } H_{0}|H_{0}\text{ Wrong} ) = \beta$$
3. Type $I$ Error: Rejecting $H_0$ while it is correct. $$P(\text {Rejected } H_{0}|H_{0}\text{ Correct} ) = a$$
4. Correct decision: Rejecting $H_{0}$ while it is wrong$$P(\text {Rejected } H_{0}|H_{0}\text{ Wrong} ) = 1 - \beta $$
### Mean Value Hypothesis
Null Hypothesis: $H_{0}: \mu = \mu_{0}$ . Assuming this is true we get $$\bar t = \frac{\bar{x} - \mu_{0}}{s/\sqrt{n}} \sim t_{n-1}$$
We accept this if the real $\mu$ is 'close' to $\bar t$. The rest is some area $R$ in which we reject $\bar t$. The likelyhood of of encountering the sample with statistical mean of $\bar{x}$ given that our real mean is $\mu_{0}$ , is $a$.The lowest $a$ with which we accept $H_{0}$ is called its $p$-value. So $p = 2P(t > |\bar t|)$.

The same is true for $\chi^{2}$. 

## $\chi^2$  goodnes-of-fit test

We want to see how likely some population fits a known distribution. To do that we will compare their cdf. First we descritize our data. Then define $O_{j} = \text{ Frequency of data in bin \#j}$, then we define the test statistic$$\chi^{2}= \sum\limits_{j=1}^{K} \frac{{(O_{j}-E_{j})^{2}}}{{E_{j}}}$$
with $$E_{j}= n(F_{x}(x_{j}^{\text{up limit}}) - F_{x}(x_{j}^{\text{down limit}}))$$
