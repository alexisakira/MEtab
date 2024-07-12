Replication files for "Tuning Parameter-Free Nonparametric Density Estimation from Tabulated Summary Data" by Lee, Sasaki, Toda, & Wang
Journal of Econometrics, 2024
https://doi.org/10.1016/j.jeconom.2023.105568

[Files]
- Jlambda.m	computes the objective function in Proposition 1
- get_lambda.m	computes the Lagrange multiplier in maximum entropy problem
- fhat.m	defines truncated exponential distribution
- Jstar.m	computes minimized KL divergence
- mePDF.m	computes maximum entropy density (piecewise exponential)
- meCDF.m	computes CDF of maximum entropy density (piecewise exponential)
- meTailExp.m	computes tail expectation of maximum entropy density (piecewise exponential)
- MEtab.m	estimates maximum entropy density from tabulation
- main.m	main file to obtain outputs
- TabFig2018.xls	Piketty & Saez data (for comparison only)

[How to use files]
1. Set path to the entire "replication files" folder
2. run "main.m"
3. If you just want to play around with the nonparametric estimation, use MEtab.m