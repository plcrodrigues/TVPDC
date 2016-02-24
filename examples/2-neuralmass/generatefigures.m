
%% Plotting the figures for the SINGLE column case

clear all; clc
load('data_single')
load('results_single')

Nc = size(x,1);
Ns = size(x,2);
Nt = size(x,3);

% plotting the signal in time
t = [0:(Ns-1)]/Fs;
plot(t,x(1,:,1),'LineWidth',3.0)
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold')
set(gcf,'position',[273   244   917   423])
xlabel('time (s)')
ylabel('amplitude (mV)')
title('EEG signal simulated with a neural mass model','FontSize',18,'FontWeight','bold')
grid on

% plotting the estimated power spectral density (using the periodogram)
psd = zeros(1,Ns);
for trial = 1:Nt  
    datatrial = (x(1,:,trial)-mean(x(1,:,trial),2));
    psd = psd + 1/Nt*1/Ns*abs(fft(datatrial)).^2;         
end
figure; hold on
freqs = [0:(Ns-1)]/Ns*Fs;
plot(freqs,10*log10(psd),'Color','blue','LineWidth',3.0)
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold')
xlim([freqs(2) 100])
set(gcf,'position',[368   189   680   529])
grid on
xlabel('frequency (Hz)')
ylabel('magnitude (dB)')
title('PSD of the simulated EEG','FontSize',18,'FontWeight','bold')

figure
pmax = size(aic,2);
plot(aic,'LineWidth',4.0)
hold on
plot([6 6],[-9 -7],'LineWidth',2.0,'LineStyle','--','Color','black')
xlim([1 pmax])
ylim([-8.15 -7.95])
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold')
grid on
xlabel('model order')
ylabel('AIC')
title('AIC for the simulated EEG signal','FontSize',18,'FontWeight','bold')
set(gcf,'position',[297 165 598 446])

figure
Nf = size(Par,3);
freqs = linspace(0,0.5,Nf)*Fs;
spectplot = reshape(Par(1,1,:),1,[]);
AR = plot(freqs,10*log10(abs(spectplot)),'LineWidth',4.0,'Color','blue');
hold on
freqs = [0:(Ns-1)]/Ns*Fs;
PSD = plot(freqs,10*log10(psd),'Color','black','LineWidth',2.0);
xlim([freqs(2) Fs/2])
set(gcf,'Position',[303 189 677 527])
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold')
grid on
xlabel('frequency (Hz)')
ylabel('magnitude (dB)')
legend([AR PSD],'AR','PSD')
title('Autospectra with AR model and periodogram','FontSize',18,'FontWeight','bold')

%% Plotting the figures for the DOUBLE column case

clear all; clc
load('data_double')
load('results_double')

Nc = size(x,1);
Ns = size(x,2);
Nt = size(x,3);

% plotting the signal in time
t = [0:(Ns-1)]/Fs;

subplot(Nc,1,1)
plot(t,x(1,:,1),'LineWidth',3.0,'color','blue')
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold')
ylabel('amplitude (mV)')
title('EEG signal simulated on column 1','FontSize',18,'FontWeight','bold')
grid on

subplot(Nc,1,2)
plot(t,x(2,:,1),'LineWidth',3.0,'color','red')
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold')
ylabel('amplitude (mV)')
xlabel('time (s)')
title('EEG signal simulated on column 2','FontSize',18,'FontWeight','bold')
grid on

set(gcf,'position',[243   129   949   580])

% plotting the estimated power spectral density (using the periodogram)

figure

colors = {'b','r'};
for c = 1:2
    
    subplot(1,2,c)
    psd = zeros(1,Ns);
    for trial = 1:Nt  
        datatrial = (x(c,:,trial)-mean(x(c,:,trial),2));
        psd = psd + 1/Nt*1/Ns*abs(fft(datatrial)).^2;         
    end
    freqs = [0:(Ns-1)]/Ns*Fs;
    plot(freqs,10*log10(psd),'Color',colors{c},'LineWidth',3.0)
    set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold')
    xlim([freqs(2) 100])
    set(gcf,'position',[368   189   680   529])
    grid on
    xlabel('frequency (Hz)')
    ylabel('magnitude (dB)')
    title(['PSD at channel ' num2str(c)],'FontSize',18,'FontWeight','bold')
    
end
set(gcf,'position',[194 227 1133 454])

figure
pmax = size(aic,2);
plot(aic,'LineWidth',4.0)
hold on
plot([12 12],[-14 -12],'LineWidth',2.0,'LineStyle','--','Color','black')
xlim([1 pmax])
ylim([-13.5 -12])
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold')
grid on
xlabel('model order')
ylabel('AIC')
title('AIC for the case of two columns','FontSize',18,'FontWeight','bold')
set(gcf,'position',[297 165 598 446])

Nf = size(Par,3);
figure; n = 1;
for ci = 1:Nc
    for cj = 1:Nc
   
        subplot(Nc,Nc,n)
        if ci == cj
            
            hold on
            freqs = linspace(0,0.5,Nf)*Fs;
            spectplot = reshape(Par(ci,cj,:),1,[]);
            plot(freqs,10*log10(abs(spectplot)),'Color','blue','LineWidth',4.0)
              
            xlim([freqs(2) Fs/2])
            
            set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold')             
            title(['PAR ' num2str(cj) num2str(ci) ' (dB)'],'FontSize',18)
            
        else
            freqs = linspace(0,0.5,Nf)*Fs;
            gpdcplot = reshape(gpdc(ci,cj,:),1,[]);
            plot(freqs,abs(gpdcplot).^2,'Color','blue','LineWidth',4.0)
            ylim([0 1])
            xlim([0 Fs/2])      
            
            set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold') 
            title(['|gPDC|^2 (' num2str(cj) ') -> (' num2str(ci) ')'],'FontSize',18)
            
        end        
               
        xlabel('frequency (Hz)')
        n = n+1;
        
    end
end
set(gcf,'Position',[275 57 808 713])

%%

Nf = size(Par,3);
figure

ci = 1; cj = 1;
subplot(1,2,1)
spectplot = reshape(Par(ci,cj,:),1,[]);
freqs = linspace(0,0.5,Nf)*Fs;
plot(freqs,10*log10(abs(spectplot)),'LineWidth',4.0,'Color','blue')
psd = zeros(1,Ns);
for trial = 1:Nt  
    datatrial = (x(ci,:,trial)-mean(x(ci,:,trial),2));
    psd = psd + 1/Nt*1/Ns*abs(fft(datatrial)).^2;         
end
freqs = [0:(Ns-1)]/Ns*Fs;
hold on
plot(freqs,10*log10(psd),'Color','black','LineWidth',2.0)
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold') 
title(['Autospectrum channel ' num2str(cj)],'FontSize',18)
xlabel('frequency (Hz)')
xlim([freqs(2) Fs/2])
grid on

ci = 2; cj = 2;
subplot(1,2,2)
spectplot = reshape(Par(ci,cj,:),1,[]);
freqs = linspace(0,0.5,Nf)*Fs;
plot(freqs,10*log10(abs(spectplot)),'LineWidth',4.0,'Color','blue')
psd = zeros(1,Ns);
for trial = 1:Nt  
    datatrial = (x(ci,:,trial)-mean(x(ci,:,trial),2));
    psd = psd + 1/Nt*1/Ns*abs(fft(datatrial)).^2;         
end
freqs = [0:(Ns-1)]/Ns*Fs;
hold on
plot(freqs,10*log10(psd),'Color','black','LineWidth',2.0)
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold') 
title(['Autospectrum channel ' num2str(cj)],'FontSize',18)
xlabel('frequency (Hz)')
xlim([freqs(2) Fs/2])
grid on

set(gcf,'Position',[105 193 1294 511])

%%

Nf = size(c001.pdc,3);
freqs = linspace(0,0.5,Nf);

figure

ci = 2; cj = 1;
subplot(1,2,1)
pdcplot = reshape(c001.pdc(ci,cj,:),1,[]);
plot(freqs,pdcplot,'LineWidth',4.0,'Color','blue')
hold on
thrplot = reshape(c001.th(2,1,:),1,[]);
plot(freqs,thrplot,'LineWidth',2.0,'LineStyle','--','Color','black')
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold') 
title(['|gPDC|^2 (' num2str(cj) ') -> (' num2str(ci) ')'],'FontSize',18)
xlabel('frequency (Hz)')

ci = 1; cj = 2;
subplot(1,2,2)
pdcplot = reshape(c001.pdc(ci,cj,:),1,[]);
plot(freqs,pdcplot,'LineWidth',4.0,'Color','blue')
hold on
thrplot = reshape(c001.th(1,2,:),1,[]);
plot(freqs,thrplot,'LineWidth',2.0,'LineStyle','--','Color','black')
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold') 
title(['|gPDC|^2 (' num2str(cj) ') -> (' num2str(ci) ')'],'FontSize',18)
xlabel('frequency (Hz)')

set(gcf,'Position',[191 241 966 392])


















