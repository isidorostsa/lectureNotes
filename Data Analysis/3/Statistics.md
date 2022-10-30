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
Variance:$$$$