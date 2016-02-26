
clear all
clc

side = 'G';

load(['RN060616A/data_RN060616A_' side])
load(['results_RN060616A_' side])

%load(['IC070523/data_IC070523_' side])
%load(['results_IC070523_' side])

Nc = size(x,1);
Ns = size(x,2);
Nt = size(x,3);
nstimulus = 120;

% setting colors like in the electrodemap
colors = [136 137 142
           52  54 128
           91 140 207
          111 169  84
          227 236  59
          212 170  49
          170   0   0
            0   0   0
          136 137 142
           52  54 128
           91 140 207
          111 169  84
          227 236  59
          212 170  49
          170   0   0]/256;
      
figure      
time = 1000*([0:(Ns-1)]-nstimulus)/Fs;
subplot(1,2,1)
for c = 1:8   
    erp = reshape(mean(x(c,:,:),3),1,[]);
    plot(time,erp,'Color',colors(c,:),'LineWidth',4.0)
    hold on    
end
ylim([-600 +600])
xlim([-10 +80])
Ylim = get(gca,'YLim');
plot([0 0],Ylim,'Color','black','LineStyle','--','LineWidth',2.0)
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold','GridAlpha',0.05)
grid on
xlabel('time (ms)')
ylabel('voltave (uV)')
title('ERPs on the left side (G)')

subplot(1,2,2)
for c = 8:15   
    erp = reshape(mean(x(c,:,:),3),1,[]);
    plot(time,erp,'Color',colors(c,:),'LineWidth',4.0)
    hold on    
end
ylim([-600 +600])
xlim([-10 +80])
Ylim = get(gca,'YLim');
plot([0 0],Ylim,'Color','black','LineStyle','--','LineWidth',2.0)
set(gca,'LineWidth',2.0,'FontSize',14,'FontWeight','bold','GridAlpha',0.05)
grid on
xlabel('time (ms)')
ylabel('voltave (uV)')
title('ERPs on the right side (D)')

set(gcf,'position',[86 194 1354 470])

%% Plotting the S transform

figure
I = abs(mean(spectn_ST,3)).^2;
freqs = linspace(0,0.5,size(spectn_ST,1))*Fs;
times = ([0:(Ns-1)]-120)/Fs*1000;
imagesc(times,freqs(2:end),I(2:end,:))
hold on
plot([0 0],[0 Fs/2],'LineWidth',3.0,'LineStyle','--','Color','red')
set(gca,'YDir','normal')
set(gca,'FontWeight','bold','FontSize',12,'LineWidth',2.0)
xlabel('time (ms)','FontSize',14,'FontWeight','bold')
ylabel('frequency (Hz)','FontSize',14,'FontWeight','bold')
clb = colorbar;
set(clb,'FontSize',14,'FontWeight','bold')
title('Time-frequency |PSD|^2 via S-Transform','FontSize',18,'FontWeight','bold')
set(gcf,'Position',[243   188   877   488])

figure
I = 10*log10(abs(mean(spectn_ST,3)));
freqs = linspace(0,0.5,size(spectn_ST,1))*Fs;
times = ([0:(Ns-1)]-120)/Fs*1000;
imagesc(times,freqs(2:end),I(2:end,:),[-30 +30])
hold on
plot([0 0],[0 Fs/2],'LineWidth',3.0,'LineStyle','--','Color','white')
set(gca,'YDir','normal')
set(gca,'FontWeight','bold','FontSize',12,'LineWidth',2.0)
xlabel('time (ms)','FontSize',14,'FontWeight','bold')
ylabel('frequency (Hz)','FontSize',14,'FontWeight','bold')
clb = colorbar;
set(clb,'FontSize',14,'FontWeight','bold')
title('Time-frequency PSD via S-Transform [dB]','FontSize',18,'FontWeight','bold')
set(gcf,'Position',[243   188   877   488])

%% Plotting the AIC 

figure; hold on
for i = 1:size(aicw,1)

    aicplot = (aicw(i,:)-min(aicw(i,:)))/(max(aicw(i,:))-min(aicw(i,:)));
    plot(aicplot,'LineWidth',2.0)
    
end
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',2.0,'GridAlpha',0.05)
xlabel('model order')
title('AIC criterion (L = 30)','FontSize',18','FontWeight','bold')
set(gcf,'Position',[396   247   619   360])
grid on

%% Plotting the PAR in time-frequency

figure
Nf = size(spectn_SW,1);
channel = 4;
times = ([0:(Ns-1)]-120)/Fs*1000;
freqs = linspace(0,0.5,Nf)*Fs;
I = spectn_SW;
imagesc(times, freqs, (abs(I)).^2)
hold on
plot([0 0],[0 Fs/2],'LineWidth',3.0,'LineStyle','--','Color','red')
set(gca,'YDir','normal')
set(gca,'FontWeight','bold','FontSize',12,'LineWidth',2.0)
xlabel('time (ms)','FontSize',14,'FontWeight','bold')
ylabel('frequency (Hz)','FontSize',14,'FontWeight','bold')
clb = colorbar;
set(clb,'FontSize',14,'FontWeight','bold')
title('Time-frequency |PSD|^2 via MVAR model (L = 30)','FontSize',18,'FontWeight','bold')
set(gcf,'Position',[243   188   877   488])

figure
Nf = size(spectn_SW,1);
channel = 4;
times = ([0:(Ns-1)]-120)/Fs*1000;
freqs = linspace(0,0.5,Nf)*Fs;
I = spectn_SW;
imagesc(times, freqs, 10*log10(abs(I)),[-30 +30])
hold on
plot([0 0],[0 Fs/2],'LineWidth',3.0,'LineStyle','--','Color','red')
set(gca,'YDir','normal')
set(gca,'FontWeight','bold','FontSize',12,'LineWidth',2.0)
xlabel('time (ms)','FontSize',14,'FontWeight','bold')
ylabel('frequency (Hz)','FontSize',14,'FontWeight','bold')
clb = colorbar;
set(clb,'FontSize',14,'FontWeight','bold')
title('Time-frequency PSD via MVAR model [dB] (L = 30)','FontSize',18,'FontWeight','bold')
set(gcf,'Position',[243   188   877   488])
%ylim([freqs(2) 200])


%%

nbwindow = size(gpdcn_SW,4);
Nf       = size(gpdcn_SW,3);

gpdcn_outward = zeros(Nf,nbwindow);
for ci = [2 4 3 5]

    if ci ~= 4
        gpdcn_outward = gpdcn_outward + reshape(abs(gpdcn_SW(ci,4,:,:)).^2,Nf,[]);
    end
    
end

times = ([0:(Ns-1)]-120)/Fs*1000;
freqs = linspace(0,0.5,Nf)*Fs;
imagesc(times,freqs,gpdcn_outward,[0 1])
hold on
plot([0 0],[0 Fs/2],'LineWidth',3.0,'LineStyle','--','Color','red')
set(gca,'YDir','normal')
set(gca,'FontWeight','bold','FontSize',12,'LineWidth',2.0)
xlabel('time (ms)','FontSize',14,'FontWeight','bold')
ylabel('frequency (Hz)','FontSize',14,'FontWeight','bold')
title('Summed |gPDC|^2 leaving cS1','FontSize',18,'FontWeight','bold')
ylim([0 200])
clb = colorbar;
set(clb,'FontSize',12,'FontWeight','bold')
set(gcf,'position',[328   279   818   441])
xlim([-10 60])
colormap jet

%%

L = 30;
gpdcplot = reshape(gpdcn_outward(7,:),1,[]);
times = (L/2 + [0:(nbwindow-1)] - 120)/Fs*1000;
plot(times,gpdcplot,'Color','blue','LineWidth',3.0)
ylim([0 1])
set(gcf,'Position',[325   255   712   409])
set(gca,'FontWeight','bold','FontSize',12,'LineWidth',2.0)
hold on
plot([0 0],[0 1],'LineWidth',2.0,'LineStyle','--','Color','red')
xlim([-40 +100])
title('Summed |gPDC|^2 leaving cS1','FontSize',18,'FontWeight','bold')
xlabel('time (ms)')









