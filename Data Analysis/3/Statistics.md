Given a set of $n$ samples of $X$, we want to figure out it's distribution. We have 3 methods:
1. Predict a parametrized distribution and find the parameters that fit the data best.
2. Nonparametric 
3. Resampling

## Point Estimation

The statistic value $\hat \theta$ that we calculate to determine $\theta$ given the sample data.

Specifically, given $x = \set{x_{1},...,x_n}$ we estimate it using $\hat \theta = g(x)$, which is called the _estimator_. _Important:_ since $x$ is a set of samples of $X$, $\hat \theta$ is a *Random Variable*, and also $x_{1},x_{2}...$ are also _Random Variables_.
