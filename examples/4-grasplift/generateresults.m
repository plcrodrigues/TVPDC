clear all
clc

Fs = 500;
    
% load
filenameOpen = ['./data/subject.mat'];
load(filenameOpen)

% number of channels
Nc = size(x,1);
% number of samples per trials
Ns = size(x,2);
% number of trials
Nt = size(x,3);
% number of frequencies
Nf = 256;

% size of window to analyze
L = 500;
window = [1:L];
delta  = 30;
window_pos = nstimulus+delta+window; % window of data pre stimulus
window_pre = fliplr(nstimulus-delta-window); % window of data pos stimulus

% preprocessing
xpre = x(:,window_pre,:);
xpre = preprocess_temporalNormalization_alternative(xpre);
xpre = preprocess_ensembleNormalization_alternative(xpre);
xpos = x(:,window_pos,:);
xpos = preprocess_temporalNormalization_alternative(xpos);
xpos = preprocess_ensembleNormalization_alternative(xpos);

% calculate the periodogram for pre and pos stimulus
psdpre = zeros(Nc,size(xpre,2));
psdpos = zeros(Nc,size(xpos,2));
for t = 1:Nt
    for c = 1:Nc
        psdpre(c,:) = psdpre(c,:) + abs(fft(xpre(c,:,t))).^2/size(xpre,2)*1/Nt;
        psdpos(c,:) = psdpos(c,:) + abs(fft(xpos(c,:,t))).^2/size(xpos,2)*1/Nt;
    end
end

% select a frequency subband in which we will be interested from now on
windowfreq = [6:50]; % if Fs = 500, then whis window is the interval 6 Hz to 50 Hz   
xpre_new  = zeros(Nc,2*numel(windowfreq)+1,Nt);
xpos_new  = zeros(Nc,2*numel(windowfreq)+1,Nt);        
for channel = 1:Nc
    for t = 1:Nt
        Xpre = fft(xpre(channel,:,t));
        Xsub = [0 Xpre(windowfreq) conj(fliplr(Xpre(windowfreq)))];    
        xpre_new(channel,:,t) = ifft(Xsub);

        Xpos = fft(xpos(channel,:,t));
        Xsub = [0 Xpos(windowfreq) conj(fliplr(Xpos(windowfreq)))]; 
        xpos_new(channel,:,t) = ifft(Xsub);    
    end
end

% calculate the periodogram for pre and pos stimulus
psdpre_new = zeros(Nc,size(xpre_new,2));
psdpos_new = zeros(Nc,size(xpos_new,2));
for t = 1:Nt
    for c = 1:Nc
        psdpre_new(c,:) = psdpre_new(c,:) + abs(fft(xpre_new(c,:,t))).^2/size(xpre_new,2)*1/Nt;
        psdpos_new(c,:) = psdpos_new(c,:) + abs(fft(xpos_new(c,:,t))).^2/size(xpos_new,2)*1/Nt;
    end
end

% Estimate the AIC for PRE and POS
pmax = 16;
[~, ~, ~, ~, aic_pre] = MVAR_estimate(xpre_new,pmax,'ns','aic');
[~, ~, ~, ~, aic_pos] = MVAR_estimate(xpos_new,pmax,'ns','aic');

% Estimate the MVAR model for PRE and POS
pest = 8;
alpha = 0.01;

[ap, ~, pfp] = MVAR_estimate_NS(xpre_new,pest);
spectpre = MVAR_spectrum(Nc,ap,pest,pfp,Nf);
gpdcpre  = MVAR_gpdc(ap,pfp,Nf);
cpre = asymp_pdc_segments(xpre_new,ap,pfp,Nf,'diag',alpha,0,1:Nf,[1:Nc]);

[ap, ~, pfp] = MVAR_estimate_NS(xpos_new,pest);
spectpos = MVAR_spectrum(Nc,ap,pest,pfp,Nf);
gpdcpos  = MVAR_gpdc(ap,pfp,Nf);
cpos = asymp_pdc_segments(xpos_new,ap,pfp,Nf,'diag',alpha,0,1:Nf,[1:Nc]);

















