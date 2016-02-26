
clear all
clc

%% This is the toy model from the paper by Astolfi et al. in 2008. 
% My main goal was to reproduce their results and show that the
% sliding-window I'm proposing works just fine. In addition, I'm
% calculating the thresholds for PDC significance.

Nc  = 3;
Ns  = 450;
Nt  = 80;
Nf  = 256;

SNR = 5;
  C = 0.05;
  L = 32;
  
% load the simulated EEG signal from a neural mass model
% the signal had its temporal mean extracted in each trial
% Fs was 256 Hz
load('inputSignal')
load('results.mat')

%% Show the PSD of the input EEG coming from channel 1 and being propagated to channels 2 and 3

% just take out the temporal mean, don't do any normalization regarding standard deviation
s = preprocess_temporalNormalization_alternative(s(1,:,1:Nt)); 

psd = zeros(1,Ns);
for t = 1:Nt
   
    datatrial = abs(fft(s(1,:,t))).^2/Ns;
    psd = psd + datatrial/Nt;
    
end

freqs = [0:(Ns-1)]/Ns*Fs;
plot(freqs,10*log10(psd),'LineWidth',2.0)
grid on
xlim([freqs(2) Fs/2])
set(gca,'LineWidth',3.0,'FontWeight','bold','FontSize',14,'GridAlpha',0.05)
title('PSD of the signal at channel (1)','FontWeight','bold','FontSize',18)
xlabel('Frequency (Hz)','FontWeight','bold','FontSize',16)
ylabel('PSD (dB)')
set(gcf,'Position',[290 140 647 529])

%% Plot the time-frequency PDC estimated with RLS and SW

nswitch = 225;
figRLS = pdctf_plot(pdcRLS,spectRLS,L,Fs,nswitch);
figSW  = pdctf_plot(pdcSW,spectSW,L,Fs,nswitch);

%% Plot just one PDC at one frequency 
%  Compare results for SW and RLS estimation

freqInterest = 26;
figure; hold on
ci = 3; cj = 1;

pdcplot = reshape(pdcRLS(ci,cj,freqInterest,:),1,[]);
RLS = plot(abs(pdcplot).^2,'LineWidth',3.0,'Color','red');
pdcplot = reshape(pdcSW(ci,cj,freqInterest,:),1,[]);
SW  = plot(abs(pdcplot).^2,'LineWidth',3.0,'Color','blue');

plot([nswitch nswitch],[0 1],'Color','black','LineWidth',3.0,'LineStyle','--')
xlim([50 Ns])
ylim([0 1])
set(gca,'LineWidth',3.0,'FontSize',14,'FontWeight','bold','GridAlpha',0.05)
set(gcf,'Position',[1 1 892 644])
title(['|PDC (' num2str(cj) ') -> (' num2str(ci) ')|^2 @ f = ' num2str(freqs(freqInterest),'%.2f') ' Hz'],'FontSize',20,'FontWeight','bold')
legend([RLS SW],'RLS','SW')
xlabel('sample','FontSize',16,'FontWeight','bold')
set(gcf,'position',[259   139   695   521])
grid on









