# TVPDC - Time-varying PDC

##Introduction
This is my first public repository with the codes that I developed during my master of science at the University of São Paulo. The project lasted approximately 18 months and the results lead, until now, to one publication in an international conference (IEEE EMBC 2015 [1]) and one submission to another international conference (IEEE EMBC 2016 [2]). We intend to submit at least one other paper, this time in a journal.

The main topic of research was on the estimation of **time-varying neural connectivity** from multichannel recordings, such as in EEG and MEG.  

Although there are several estimators for studying neural connectivity, the one I used here was based on the concept of [Granger causality](http://www.scholarpedia.org/article/Granger_causality) between time series. More specifically, I used the notion of Partial Directed Coherence (PDC)[3] between two time series to describe their causal relations in the frequency domain.

PDC relies on the estimation of a multivariate autoregressive model (MVAR) of the multichannel recordings under scrutiny. From the matrix coefficients of this model, one estimates the PDC between pairs of channels, revealing how the two channels interact in the **frequency domain**. For instance, one might see that one cortical column influences another one only in the alpha band, and a reverse causal influence may occur in the beta band. See [3] for more information and examples.

My main contribution was to come up with a procedure for estimating the PDC in **dynamics settings**, such as cognitive tasks and somatosensory experiments. For this, I used a two-step procedure, where a sliding-window algorithm would estimate MVAR models in short intervals of time and the PDC would be estimated for each one of them. A non-trivial aspect of this procedure was the fact of being able to form a **joint model** from the possibly many trials recorded during an experiment.  

Additionally, I investigated how to assess the statistical significance of these PDC estimates, using an extension to the rigorous asymptotic results available in [4]. This avoided the use of computer intensive resampling techniques such as Bootstrap and Jacknife, who do not take into consideration the mathematical structure of the estimator.

[1]: Rodrigues, P. and Baccalá, Luiz A. "A new algorithm for neural connectivity estimation of EEG event-related potentials"

[2]: Rodrigues, P. and Baccalá, Luiz A. "Statistically Significant of Time-varying Neural Connectivity using Generalized Partial Directed Coherence"

[3]: Baccalá, Luiz A. and Sameshima, K. "Partial directed coherence: a new concept in neural structure determination" (2001)

[4]: Baccalá, Luiz A. et al. "Unified asymptotic theory for all partial directed coherence forms" (2013)

## Structure of this repository

The folders in this repository are organized as follows:

    - source
        - connectivity
        - multichannelmodel
        - preprocessing
        - tools
    - examples
        - basic
        - embc2015
        - embc2016
        - neuralmass
        - ratsep
    - etc

In *source* you will find all the .m files necessary for the MVAR and PDC estimations. Note that they were not written with a very broad public in mind, so comments may be missing in some important places. Nevertheless, things work quite fine for generating the results in the folder *examples*. In fact, the examples in this folder were chosen as to reproduce important demonstrations in papers from the literature of PDC and also from my two papers. The *etc* folder has some miscelanea, like .tex files for generating diagrams, some texts that might be useful for understanding the theory, etc.
