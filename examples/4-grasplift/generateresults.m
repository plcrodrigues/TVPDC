
clear all
clc

load(['data/subject.mat'])

% the data has only 6 channels from the EEG recordings, which are
% F3, F4, C3, C4, P3, P4

interval = nstimulus+[-250:500];
x  = x(:,interval,:);

Nc = size(x,1);
Ns = size(x,2);
Nt = size(x,3);

whos

xnorm = zeros(size(x));
for c = 1:Nc
    for t = 1:Nt
        xdet = detrend(reshape(x(c,:,t),1,[]));
        xnorm(c,:,t) = xdet;
    end
end

xnorm = preprocess_temporalNormalization_alternative(xnorm);
xnorm = preprocess_ensembleNormalization_alternative(xnorm);

channel = 3;
S = zeros(376,751);
for t = 1:Nt
    t
    xc = reshape(xnorm(channel,:,t),1,[]);
    [sc,time_ST,freq_ST] = stransform(xc);
    S = S + abs(sc).^2;
end

spectn_ST = S/Nt;

%%

figure
I = (spectn_ST);
freqs = linspace(0,0.5,size(spectn_ST,1))*Fs;
times = ([0:(Ns-1)]-250)/Fs*1000;
imagesc(times,freqs(2:end),I(2:end,:))
hold on
plot([0 0],[0 Fs/2],'LineWidth',3.0,'LineStyle','--','Color','white')
set(gca,'YDir','normal')
set(gca,'FontWeight','bold','FontSize',12,'LineWidth',2.0)
xlabel('time (ms)','FontSize',14,'FontWeight','bold')
ylabel('frequency (Hz)','FontSize',14,'FontWeight','bold')
ylim([0 60])

%%

L = 75;
% define window locations
nbwindow = Ns-L;
window   = zeros(nbwindow,L+1);
for w = 1:nbwindow
    window(w,:) = L/2+[-L/2:L/2]+w;
end

pmax  = 10;
aicw  = [];
for w = randi(nbwindow,1,10)
    
    fprintf(['PAR in window ' num2str(w) '\n'])
    xwindow  = xnorm(:,window(w,:),:);
    
    xwindow  = preprocess_detrend(xwindow);
    xwindow  = preprocess_temporalNormalization_alternative(xwindow);
    xwindow  = preprocess_ensembleNormalization(xwindow);       
    
    [p, ap, efp, pfp, aic] = MVAR_estimate(xwindow,pmax,'ns','aic');
    
    aicw = cat(1,aicw,aic);
    
end

%% Plotting the AIC 

figure; hold on
for i = 1:size(aicw,1)

    aicplot = (aicw(i,:)-min(aicw(i,:)))/(max(aicw(i,:))-min(aicw(i,:)));
    plot(aicplot,'LineWidth',2.0)
    
end

%%

pest       = 6;
Nf         = 256;
spectn_SW  = zeros(Nf,nbwindow);
gpdcn_SW   = zeros(Nc,1,Nf,nbwindow);
channel    = 3;

for w = 1:nbwindow
    
    fprintf(['estimations in window ' num2str(w) '\n'])
    xwindow  = xnorm(:,window(w,:),:);
    
    fprintf('\t preprocessing...\n')
    xwindow  = preprocess_detrend(xwindow);
    xwindow  = preprocess_temporalNormalization_alternative(xwindow);
    xwindow  = preprocess_ensembleNormalization(xwindow);       
    
    fprintf('\t estimating MVAR model...\n')
    [ap, efp, pfp] = MVAR_estimate_NS(xwindow,pest);
    par = MVAR_spectrum(Nc,ap,pest,pfp,Nf);
    
    spectn_SW(:,w) = reshape(par(channel,channel,:),1,[]);
    
    fprintf('\t estimating GPDC...\n')
    gpdc = MVAR_gpdc(ap,pfp,Nf);
    for ci = 1:Nc
        gpdcn_SW(ci,channel,:,w) = gpdc(ci,channel,:);
    end
    
end

%%

save(['results'],'spectn_SW','gpdcn_SW','aicw','spectn_ST','xnorm')

%%

L = 75;
Fs = 500;
nbwindow = size(spectn_SW,2);
figure
I = abs(spectn_SW).^2;
freqs = linspace(0,0.5,size(spectn_SW,1))*Fs;
times = (L/2+[1:nbwindow]-250)/Fs*1000;
imagesc(times,freqs,I)
hold on
plot([0 0],[0 Fs/2],'LineWidth',3.0,'LineStyle','--','Color','white')
set(gca,'YDir','normal')
set(gca,'FontWeight','bold','FontSize',12,'LineWidth',2.0)
xlabel('time (ms)','FontSize',14,'FontWeight','bold')
ylabel('frequency (Hz)','FontSize',14,'FontWeight','bold')
ylim([0 60])

%%

Ns  = size(gpdcn_SW,4);
Nf  = size(gpdcn_SW,3);
I13 = reshape(gpdcn_SW(1,3,:,:),Nf,[]);
I43 = reshape(gpdcn_SW(1,3,:,:),Nf,[]);
I   = abs(I13).^2;
times = (50/2+[1:nbwindow]-250)/Fs*1000;
freqs = linspace(0,0.5,size(spectn_ST,1))*Fs;
imagesc(times,freqs,I)
hold on
plot([0 0],[0 Fs/2],'LineWidth',3.0,'LineStyle','--','Color','white')
set(gca,'YDir','normal')
set(gca,'FontWeight','bold','FontSize',12,'LineWidth',2.0)
xlabel('time (ms)','FontSize',14,'FontWeight','bold')
ylabel('frequency (Hz)','FontSize',14,'FontWeight','bold')
ylim([0 60])

%%

w = 













