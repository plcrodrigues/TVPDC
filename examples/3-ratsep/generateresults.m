
clear all
clc

side = 'G';
%load(['RN060616A/data_RN060616A_' side])
load(['IC070523/data_IC070523_' side])

Nc = size(x,1);
Ns = size(x,2);
Nt = size(x,3);
nstimulus = 120;

xnorm = zeros(size(x));
for c = 1:Nc
    for t = 1:Nt
        xdet = detrend(reshape(x(c,:,t),1,[]));
        xnorm(c,:,t) = xdet;
    end
end

xnorm = preprocess_temporalNormalization_alternative(xnorm);
xnorm = preprocess_ensembleNormalization_alternative(xnorm);

channel = 4;
S = [];
for t = 1:Nt
    xc = reshape(xnorm(channel,:,t),1,[]);
    [sc,time_ST,freq_ST] = stransform(xc);
    S = cat(3,S,abs(sc).^2);
end

spectn_ST = S;

L = 30;
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
    xwindow  = x(:,window(w,:),:);
    
    xwindow  = preprocess_detrend(xwindow);
    xwindow  = preprocess_temporalNormalization_alternative(xwindow);
    xwindow  = preprocess_ensembleNormalization(xwindow);       
    
    [p, ap, efp, pfp, aic] = MVAR_estimate(xwindow,pmax,'ns','aic');
    
    aicw = cat(1,aicw,aic);
    
end

pest       = 4;
Nf         = 256;
spectn_SW  = zeros(Nf,nbwindow);
gpdcn_SW   = zeros(Nc,1,Nf,nbwindow);
channel    = 4;

for w = 1:nbwindow
    
    fprintf(['estimations in window ' num2str(w) '\n'])
    xwindow  = x(:,window(w,:),:);
    
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

save('results_IC070523','spectn_SW','gpdcn_SW','aicw','side','spectn_ST','xnorm')



