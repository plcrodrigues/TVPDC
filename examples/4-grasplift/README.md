# Grasp and Lift
In this folder we have two scripts: `generateresults.m` and `generatefigures.m`. The first one is for making the estimations of things we're interested, whereas the second one loads the results from the `results.mat` file and plot them.

We used real EEG data available [here](http://www.nature.com/articles/sdata201447) and described in a very detailed article [1]. The dataset has been used in a competition for the [Kaggle](https://www.kaggle.com/c/grasp-and-lift-eeg-detection) website and is a very good example of application for the algorithms that I've developed in my M.S. research.

## Description
Although the dataset from [1] has a lot of interesting features and different events to explore, my only goal here was to investigate how the neural connectivity between the EEG recordings changed after a visual cue and the movement of the subject's right arm.

Here below you see a map with all 32 electrodes used in the experiment. To facilitate our estimations, and reduce the complexity of our models, I only used a subset of these channels: F3, F4, C3, C4, P3 and P4.  The reason for choosing them was the fact that many articles in the literature show that the electrodes C3 and C4 are the most affected by arm movement [2]. With this said, we thought it would be interesting to see how the flow of information leaving Cx would behave: either upwise (to Fx) or downwise (to Px).

<div style="text-align: center; margin-top: 10px;"><img src="./EEG_Electrode_Numbering.jpg" align="middle" width="400"></div>
<br>

## Comparing periodograms

First thing we thought would be interesting was to estimate the power spectral density at C3 electrode before and after the visual stimulus (which is when the right arm movement begins). To do this, we averaged the periodograms from each of the $N_{T}=232$ trials in two windows of $L = 500$ points, which we called the **pre** window and **pos** window. Sampling frequency being $F_{S} = 500$ Hz means that each window lasted 1 second.

<div style="text-align: center; margin-top: 10px;"><img src="./figure1.svg" align="middle" width="450"></div>
<br>

From the results in the above figure we see that there is a strong decrease ($\simeq 5$ dB) at the alpha band ($f \simeq 10$ Hz) and also a change in the beta band ($f \simeq 22$ Hz) when going from the **pre** window to the **pos** window.

An important thing to mention here is the PSD's behavior in the lowest frequencies ($\leq 5$ Hz). We see that there's almost as much power in this band as in the peak at $10$ Hz. In fact, these very-low oscillations are not believed to have physiological meaning, being probably due to problems in the measuring apparatus or artifacts induced by subject's muscle contractions. This lower band power causes severe problems to the signal's MVAR model estimation, since it ends up masking the main features which we would like to model. With that said, it would be interesting if we could estimate a MVAR model in just a sub-band of the frequency domain, for instance, from 5 Hz to 50 Hz. Well, this is what we did.

## Sub-band modeling
Here below you see the original signals in channel C3 (pre and pos stimulus) and compare them with what is left when we take only the contribution in the sub-band of interest. Note that besides the absence of high frequency wiggles, the new signal doesn't have slow oscillations, maintaining a constant baseline around zero. To get this, we did the following steps for each trial and each condition:

1. Calculate the FFT of the signal
2. Window the FFT, taking only the samples that correspond to the 5 Hz - 50 Hz band
3. Use the inverse FFT to get the new signal

Note that with this procedure we will have necessarily less samples in each trial, since we have windowed the FFT.

<div style="text-align: center; margin-top: 10px;"><img src="./figure2.svg" align="middle" width="550"></div>
<br>

We can now estimate a MVAR model on these new signals and plot the autospectrum at channel C3, as shown below. The figure compares the new autospectrum with the PSD that we would obtain for the original signals. Note that with the MVAR model we get to model much better the peak at 10 Hz.

<div style="text-align: center; margin-top: 10px;"><img src="./figure3.svg" align="middle" width="450"></div>
<br>

## The gPDC leaving C3
With the MVAR model in hands we can also estimate gPDC between pairs of channels. Our main interest was to see how channel C3 interacted with its nearest neighbours (F3 and P3) before and after visual stimulus. The figures below reveal that this connectivity changed in each state, with the disappearance of connectivity post stimulus both for the (C3)$\to$(P3) and the (C3)$\to$(F3) connections. Note that the dashed lines represent the thresholds of statistical significance, which helps us to be more certain about the existence (or not) of connectivity in different frequencies.

<div style="text-align: center; margin-top: 10px;"><img src="./figure4.svg" align="middle" width="450"></div>
<br>

<div style="text-align: center; margin-top: 10px;"><img src="./figure5.svg" align="middle" width="450"></div>
<br>

## Conclusion
The analysis we did here is certainly a bit **superficial**, and lacks a statistical comparison between subjects and conditions. Indeed, the variability in the EEG between subjects could (and did) lead us to different conclusions regarding the connectivity relations between electrodes. Nevertheless, it is interesting to see how useful a sub-band autoregressive modeling can be, providing us an efficient way for studying the spectrum and connectivity only in a region of interest which would probably be masked by the large peak in the lower frequencies had we done nothing about it.

It should be noted that all our signals were modeled in the sensor space, so the **volume conductance effect** certainly could have caused problems in terms of connectivity inference. A next natural step for us would be to study and apply methods which takes the recordings from the sensor space to the source space, and then use MVAR models to infer connectivity between them.

---
#### References

[1] Luciw, M. et al. "Multi-channel EEG recordings during 3,936 grasp and lift trials with varying weight and friction"

[2] Pfurtscheller, G. et al. "Mu rhythm (de)synchronization and EEG single-trial classification of different motor imagery tasks"
