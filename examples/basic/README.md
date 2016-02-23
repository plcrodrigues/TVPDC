# Basic examples

Here we have four examples which are basically reproductions from papers in the literature. Each example was carefully chosen so that it would show important concepts regarding the PDC. Note that inside each subfolder you have another README file with more details about the examples and a brief discussion on the results.

PS: Unfortunately, Github's markdown manager doesn't allow for mathematical rendering with MathJax. With that said, it might be better to read the `html` files in each subfolder.

### Example 1 - Baccala2001

Here I simply reproduce some of the figures from the first article where the Partial Directed Coherence was formally presented to the scientific community. All examples were done on toy models and reflect some interesting properties of the PDC.

Baccalá, Luiz A. and Sameshima, K. "Partial directed coherence: a new concept in neural structure determination" (2001)

### Example 2 - Baccala2008

This is a rather short article where Baccalá and Sameshima show an annoying feature of the PDC: it is not invariant to scale. With this in mind, they use an example where PDC's values lead to wrong causality conclusions. Then, they propose a normalized version for this estimator, which they call the Generalized Partial Directed Coherence (gPDC), and successfully apply it to the example just mentioned.

Baccalá, Luiz A. and Sameshima, K. "Generalized Partial Directed Coherence" (2008)

### Example 3 - Astolfi2008

This article is one of the main references for my M.S. research. It applies a Recursive Least Squares algorithm for estimating a time-varying MVAR model from multichannel recordings. With these time-varying coefficients, the PDC can be estimated at each time instant, allowing us to talk about time-varying neural connectivity analysis. In this folder I do the same simulations as in the reference and then use my sliding-window algorithm to compare results with the RLS approach.

Astolfi, Laura et al. "Tracking the time-varying cortical connectivity patterns by adaptive multivariate estimators"

### Example 4 - SunspotData

In this example, I use real data from Andrews and Herzberg's book "Data: A Collection of Problems from Many Fields for the Student and Research Worker". The data is composed of two time-series with the melanoma incidence in the state of Connecticut and the Wolfer sunspot number measured from 1936 to 1972 (37 time points). Note that this has nothing to do with EEGs, but we can still do causality analysis and see whether our estimations will conclude that sunspots cause greater incidence of melanoma or the contrary.

Stein, Carlos et al. "Asymptotic Behavior of Generalized Partial Directed Coherence"
