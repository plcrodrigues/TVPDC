# TVPDC - Time-varying PDC

This is my first public repository with the codes (in Matlab) that I developed during my master of science at the University of São Paulo. The project lasted approximately 18 months and the results lead, until now, to two publications in international conferences (IEEE EMBC 2015 and 2016).

The main topic of research was on the estimation of **time-varying neural connectivity** from multichannel recordings, such as in EEG and MEG.  

Although there are several estimators for studying neural connectivity, the one I used here was based on the concept of Granger causality between time series. More specifically, I used the notion of Partial Directed Coherence (PDC) between two time series, which relies on the estimation a multivariate autoregressive model (MVAR) of the multichannel recordings under scrutiny. From the matrix coefficients of this MVAR model, one estimates the PDC between pairs of channels. See [1] for more information.

My main contribution was to come up with a procedure for estimating the PDC during intrinsically dynamics settings, such as cognitive tasks and somato-sensory experiments. Additionally, my works allowed us to assess the statistical significance of these PDC estimates without recurring to resampling techniques, but rather an extension to rigorous asymptotic results available in [2].

[1]: Baccalá, Luiz A. and Sameshima, K. "Partial directed coherence: a new concept in neural structure determination" (2001)

[2]: Baccalá, Luiz A. et al. "Unified asymptotic theory for all partial directed coherence forms" (2013)
