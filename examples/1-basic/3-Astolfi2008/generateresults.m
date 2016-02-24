
clear all
clc

%% This is the toy model from the paper by Astolfi et al. in 2008. 
% My main goal was to reproduce their results and show that the
% sliding-window I'm proposing works just fine. 

Nc  = 3;
Ns  = 450; % number of samples
Nt  = 50;  % number of trials to be simulated

SNR = 5;
  C = 0.05;
  L = 40;
  
% load the simulated EEG signal from a neural mass model
% the signal had its temporal mean extracted in each trial
% Fs was 256 Hz
load('inputSignal')

% just take out the temporal mean, don't do any normalization regarding standard deviation
s = preprocess_temporalNormalization_alternative(s(1,:,1:Nt)); 

%% Generate simulated signals

nswitch = 225;
ptrue   = 2;

x = zeros(Nc,Ns,Nt);
for n = (ptrue+1):Ns        
    
    if n < nswitch 
    
        for t = 1:Nt

            [n2,n3] = calculateSNR(x,n,SNR);        
                       
            x(1,n,t) = 1.0*s(1,n,t);
            x(2,n,t) = 0.6*x(1,n-1,t)                  + n2;
            x(3,n,t) = 0.7*x(2,n-1,t) + 0.0*x(1,n-2,t) + n3;

        end
    
    else
        
        for t = 1:Nt

            [n2,n3] = calculateSNR(x,n,SNR);           
            
            x(1,n,t) = 1.0*s(1,n,t);
            x(2,n,t) = 0.6*x(1,n-1,t)                  + n2;
            x(3,n,t) = 0.7*x(2,n-1,t) + 0.9*x(1,n-2,t) + n3;

        end        
        
    end
    
end

%% Estimate the time-varying MVAR models using RLS and SW
%  From the models, estimate the PDC at each time instant

Nf = 256;
freqsInterest = [1:Nf];

pest = 3; % this is the model order used in Astolfi's article

[apRLS,pfRLS] = MVAR_rls(x,pest,C);

pdcRLS   = zeros(Nc,Nc,Nf,Ns);
spectRLS = zeros(Nc,Nc,Nf,Ns);

pdcSW    = zeros(Nc,Nc,Nf,Ns);
spectSW  = zeros(Nc,Nc,Nf,Ns);

for n = L+1:Ns
    
    n
    pdcRLS(:,:,:,n)   = MVAR_pdc([eye(Nc) apRLS(:,:,n)],Nf);
    spectRLS(:,:,:,n) = MVAR_spectrum(Nc,[eye(Nc) apRLS(:,:,n)],pest,pfRLS(:,:,n),Nf);  
    
    window    = fliplr([-1:-1:-L]+n);
    xwindow   = x(:,window,:);   
    [ap,~,pf] = MVAR_estimate_NS(xwindow,pest);
    
    pdcSW(:,:,:,n)   = MVAR_pdc(ap,Nf);
    spectSW(:,:,:,n) = MVAR_spectrum(Nc,ap,pest,pf,Nf); 
    
end

save('results','x','pdcRLS','pdcSW','spectRLS','spectSW','C','L','freqsInterest','pest','nswitch')















