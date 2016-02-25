clear all
clc



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
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold')
xlabel('frequency (Hz)')
ylabel('magnitude')

set(gcf,'position',[348   247   744   488])

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

%% Plot the PAR for PRE and POS

figure; hold on; freqs = linspace(5,50,Nf);
channel = 3;

spectplot = reshape(abs(spectpre(channel,channel,:)),1,[]);
PRE = plot(freqs,10*log10(spectplot),'Color','blue','LineWidth',3.0);
spectplot = reshape(abs(spectpos(channel,channel,:)),1,[]);
POS = plot(freqs,10*log10(spectplot),'Color','red','LineWidth',3.0);
xlim([freqs(2) freqs(end)])
grid on; 
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold')
xlabel('frequency (Hz)')
ylabel('magnitude')

psdplot = psdpre(c,:);
Nfft = size(psdpre,2);
freqs = [0:(Nfft-1)]*1/Nfft*Fs;
plot(freqs,10*log10(psdplot),'Color','black','LineWidth',1.0);
xlim([freqs(2) 50])
legend([PRE, POS],'pre','pos')

set(gcf,'position',[348   247   744   488])

%% Plot the gPDC from channel 3 to channel 1 for the PRE and POS

figure; hold on; freqs = linspace(5,50,Nf);
cj = 3;
gpdcplot = zeros(1,Nf);
for ci = [1]
    if ci ~= cj
        gpdcplot = gpdcplot + reshape(cpre.pdc(ci,cj,:),1,[]);
    end
end
plot(freqs,gpdcplot,'Color','blue','LineWidth',2.0);

thrplot = reshape(cpre.th(ci,cj,:),1,[]);
plot(freqs,thrplot,'Color','blue','LineStyle','--')

gpdcplot = zeros(1,Nf);
for ci = [1:1]
    if ci ~= cj
        gpdcplot = gpdcplot + reshape(cpos.pdc(ci,cj,:),1,[]);
    end
end
plot(freqs,gpdcplot,'Color','red','LineWidth',2.0);

thrplot = reshape(cpos.th(ci,cj,:),1,[]);
plot(freqs,thrplot,'Color','red','LineStyle','--')

grid on; set(gca,'LineWidth',1.2)
xlim([0 50])