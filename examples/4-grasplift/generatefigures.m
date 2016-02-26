clear all
clc

load('results')

%% Plot the PSD via periodogram for PRE and POS

figure; hold on; freqs = linspace(5,50,Nf);
channel = 3;

psdplot = psdpre(c,:);
Nfft = size(psdpre,2);
freqs = [0:(Nfft-1)]*1/Nfft*Fs;
PRE = plot(freqs,10*log10(psdplot),'Color','blue','LineWidth',3.0);

psdplot = psdpos(c,:);
Nfft = size(psdpre,2);
freqs = [0:(Nfft-1)]*1/Nfft*Fs;
POS = plot(freqs,10*log10(psdplot),'Color','red','LineWidth',3.0);

xlim([freqs(2) 50])
legend([PRE, POS],'pre','pos')
grid on; 
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold','GridAlpha',0.05)
xlabel('frequency (Hz)')
ylabel('magnitude (dB)')

set(gcf,'position',[348   247   744   488])
title('Periodogram at C3','FontSize',18,'FontWeight','bold')

%% Compare the signals before and after the subband extraction

xpre_new2 = zeros(Nc,numel(window),Nt);
xpos_new2 = zeros(Nc,numel(window),Nt);
for c = 1:Nc
    for t = 1:Nt
    
        psd = fft(xpre(c,:,t));
        psd(1:5) = 0;
        psd(end-3:end) = 0;
        psd(51:451) = 0;       
        xpre_new2(c,:,t) = ifft(psd);
        
        psd = fft(xpos(c,:,t));        
        psd(1:5) = 0;
        psd(end-3:end) = 0;
        psd(51:451) = 0;        
        xpos_new2(c,:,t) = ifft(psd);        
        
    end
end

figure
channel = 3; 
time    = [0:(L-1)]*1/Fs*1000;

subplot(2,1,1); hold on
raw = plot(time,xpre(channel,:,1),'Color','blue','LineWidth',1.0);
sub = plot(time,xpre_new2(channel,:,1),'Color','black','LineWidth',2.0);
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold','GridAlpha',0.05)
title('signal at C3 - pre stimulus')
ylim([-400 +400])
ylabel('voltage (uV)')
legend([raw sub],'raw','sub')
grid on

subplot(2,1,2); hold on
raw = plot(time,xpos(channel,:,1),'Color','red','LineWidth',1.0);
sub = plot(time,xpos_new2(channel,:,1),'Color','black','LineWidth',2.0);
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold','GridAlpha',0.05)
xlabel('time (ms)')
ylabel('voltage (uV)')
title('signal at C3 - pos stimulus')
ylim([-400 +400])
legend([raw sub],'raw','sub')
grid on

set(gcf,'position',[210   113   781   569])

%% Plot the PAR for PRE and POS

figure; hold on; freqs = linspace(5,50,Nf);
channel = 3;

spectplot = reshape(abs(spectpre(channel,channel,:)),1,[]);
PRE = plot(freqs,10*log10(spectplot),'Color','blue','LineWidth',4.0);
spectplot = reshape(abs(spectpos(channel,channel,:)),1,[]);
POS = plot(freqs,10*log10(spectplot),'Color','red','LineWidth',4.0);
xlim([freqs(2) freqs(end)])
grid on; 
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold','GridAlpha',0.05)
xlabel('frequency (Hz)')
ylabel('magnitude (dB)')

psdplot = psdpre(c,:);
Nfft = size(psdpre,2);
freqs = [0:(Nfft-1)]*1/Nfft*Fs;
plot(freqs,10*log10(psdplot),'Color','black','LineWidth',2.0,'LineStyle','--');
xlim([freqs(2) 50])
legend([PRE, POS],'pre','pos')

set(gcf,'position',[348   247   744   488])
title('Autospectrum at C3 via MVAR model','FontSize',18,'FontWeight','bold')

%% Plot the gPDC from channel 3 (C3) to channel 1 (F3) for the PRE and POS

figure; hold on; freqs = linspace(5,50,Nf);

cj = 3;
gpdcplot = zeros(1,Nf);
for ci = [1]
    if ci ~= cj
        gpdcplot = gpdcplot + reshape(cpre.pdc(ci,cj,:),1,[]);
    end
end
PRE = plot(freqs,gpdcplot,'Color','blue','LineWidth',4.0);
thrplot = reshape(cpre.th(ci,cj,:),1,[]);
plot(freqs,thrplot,'Color','blue','LineStyle','--','LineWidth',2.0)

gpdcplot = zeros(1,Nf);
for ci = [1:1]
    if ci ~= cj
        gpdcplot = gpdcplot + reshape(cpos.pdc(ci,cj,:),1,[]);
    end
end
POS = plot(freqs,gpdcplot,'Color','red','LineWidth',4.0);
thrplot = reshape(cpos.th(ci,cj,:),1,[]);
plot(freqs,thrplot,'Color','red','LineStyle','--','LineWidth',2.0)

grid on
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold','GridAlpha',0.05)
xlabel('frequency (Hz)')

xlim([0 50])
legend([PRE, POS],'pre','pos')
ylim([0 0.040])
set(gcf,'position',[192   157   837   488])
title('|gPDC|^2 (C3) -> (F3)','FontSize',18,'FontWeight','bold')
set(gca,'YTick',[0 0.01 0.02 0.03 0.04])




