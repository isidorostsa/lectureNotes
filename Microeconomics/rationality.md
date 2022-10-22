Rationality means that the decision maker can completely order a set of choices in respect to their value to him. It is embodied in two assumptions:

- **Completeness**: $\forall x, y \in X: x \succsim y \text{ or } y \succsim x \text{ (or both)}$ 
- **Transitivity**: $\forall x,y,z \in X, x \succsim y \text{ and } y \succsim z \implies x \succsim z$  

In the real world this fails due to human irrationality:

Here are some examples:

1. Fruits:
	One can prefer an apple over a bannana, a bannana over an orange and an orange over an apple. This creates a cycle and it breaks transitivity.

2. Another example is the following scenario:
	You need to buy a stereo for 125\$ and a calculator for 10\$. You have 3 choices, given that another store gives a 5\$ discount to one of the items:
	- $x$ = *travel to the other store to get a 5\$ discount on the stereo*
	- $y$ = *travel to the other store to get a 5\$ discount on the calculator*
	- $z$ = *buy both items at the first store*
	
	Studies reveal that human decision makers picked $z \succ x$, $y \succ z$ while in reality $x \sim y$

3. Another example is the *Condorcet Paradox*:
	Here the majority vote of 3 rational people is irational. It goes as follows:
	We have 3 choices {O, R, I} and 3 voters {M, D, C}:
	- M has ordered preferences: O, R, I
	- D has ordered preferences: I, O, R
	- C has ordered preferences: R, I, O
	
	By taking 3 majority votes:
	- O vs R (O wins)
	- R vs I (R wins)
	- I vs O (I wins)
	
	So we have: O, R, I, O despite starting from 3 rational voters.

4. Iterative change also leads to intransitivity:
	A non smoker will prefer staying a non smoker to becoming a hard smoker, while prefering to become a soft smoker over staying a non smoker, meanwhile a soft smoker prefers to become a hard smoker rather than becoming a non smoker. This way $\text{non} \succ \text{hard}$, $\text{soft} \succ \text{non}$, $\text{hard} \succ \text{soft}$, which is cyclical.

To systematicaly rank choices we use [[utility functions]], or [[choice structures]] 
