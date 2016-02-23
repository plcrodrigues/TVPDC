# TVPDC - Time-varying PDC

## Introduction

This is my first public repository with the codes that I developed during my master of science at the University of São Paulo. The project lasted approximately 18 months and the results lead, until now, to one publication in an international conference (IEEE EMBC 2015 [1]) and one submission to another international conference (IEEE EMBC 2016 [2]). We intend to submit at least one other paper, this time in a journal.

The main topic of research was on the estimation of **time-varying neural connectivity** from multichannel recordings, such as in EEG and MEG.  

Although there are several estimators for studying neural connectivity, the one I used here was based on the concept of [Granger causality](http://www.scholarpedia.org/article/Granger_causality) between time series. More specifically, I used the notion of Partial Directed Coherence (PDC) between two time series to describe their causal relations in the frequency domain [3].

PDC relies on the estimation of a multivariate autoregressive model (MVAR) of the multichannel recordings under scrutiny. From the matrix coefficients of this model, one estimates the PDC between pairs of channels, revealing how the two channels interact in the **frequency domain**. For instance, one might see that one cortical column influences another one only in the alpha band, and a reverse causal influence may occur in the beta band. See [3] for more information and examples.

My main contribution was to come up with a procedure for estimating the PDC in **dynamics settings**, such as cognitive tasks and somatosensory experiments. For this, I used a two-step procedure, where a sliding-window algorithm would estimate MVAR models in short time intervals and the PDC would be estimated for each one of them. A non-trivial aspect of this procedure was the fact of being able to form a **joint model** from the possibly many trials recorded during an experiment.  

Additionally, I investigated how to assess the statistical significance of these PDC estimates, using an extension to the rigorous asymptotic results available in [4].

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

## Some mathematical definitions

Linear multivariate autoregressive modeling of simultaneously $m$-dimensional data
${\bf x}(n) = \left[x_{1}(n) \;x_{2}(n)\; \dots\; x_{K}(n)\right]^{T}$ observed over $n=1,\cdots, N$ instants consists of finding the $\mathbf{A}(l)$  coefficient matrices in
$$
{\bf x}(n) = \sum_{l = 1}^{p}{\bf A}(l){\bf x}(n-l) + {\bf w}(n),$$
where $p$ is the model order and ${\bf w}(n)$ stands for a zero mean Gaussian stationary innovation process with covariance matrix ${\boldsymbol \Sigma}_{{\bf w}}$ that cannot be predicted based on past observations.

Among many possible approaches [5], order recursive algorithms like the Levinson-Wiggins-Robinson (LWR), Vieira-Morf (VM) and Nuttall-Strand (NS) algorithms are particularly attractive due to their reduced computational complexity and observedly robust numerical stability (mostly for VM and NS) compared to direct solutions via the Yule-Walker equations [5].  

Causal relations between channels $i$ and $j$ can then be described in the frequency domain via gPDC:
$$
\pi_{ij}(f)=
\frac{\bar{A}_{ij}(f)}{\displaystyle \sqrt{{ \sum_{k = 1}^{m}}|\bar{A}_{kj}(f)|^2}},
$$
where
$$\bar{A}_{ij}(f)=\left\{
\begin{array}{l}
1-{\displaystyle \sum\limits_{l=1}^{p}a_{ij}(l)e^{-\mathbf{j}2\pi f l}},\;\text{if}\;\;i=j \\[1em]
-{\displaystyle \sum\limits_{l=1}^{p}a_{ij}(l)e^{-\mathbf{j}2\pi f l}},\;\text{otherwise}
\end{array}
\right.$$
with $\mathbf{j}=\sqrt{-1}$, and $a_{ij}(l)$ corresponds to position $(i,j)$ of matrix ${\textbf A}(l)$.

Nullity of $\pi_{ij}(f)$ indicates absence of Granger causality from time series $x_{j}(n)$ to $x_{i}(n)$ at the normalized frequency $f$.

---
#### References

[1] Rodrigues, P. and Baccalá, Luiz A. "A new algorithm for neural connectivity estimation of EEG event-related potentials"

[2] Rodrigues, P. and Baccalá, Luiz A. "Statistically Significant Time-varying Neural Connectivity using Generalized Partial Directed Coherence"

[3] Baccalá, Luiz A. and Sameshima, K. "Partial directed coherence: a new concept in neural structure determination" (2001)

[4] Baccalá, Luiz A. et al. "Unified asymptotic theory for all partial directed coherence forms" (2013)

[5] Marple, S. L. "Digital Spectral Analysis" (1987)
