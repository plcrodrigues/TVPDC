clear all
clc

%% first we wave to generate the EEG simulations

% for a single cortical column
Nt = 50; % how many trials to consider
filename = ['data_single'];
generateEEG_SingleCorticalColumn(filename,Nt)

% for two connected cortical columns
Nt = 50; % how many trials to consider
filename = ['data_double'];
generateEEG_DoubleCorticalColumn(filename,Nt)

%% now let's make some analysis on the SINGLE column
clear all; clc
load('data_single')

Nc = size(x,1);
Ns = size(x,2);
Nt = size(x,3);

% let's take out the temporal mean without normalizing it by the standard deviation
x = preprocess_temporalNormalization_alternative(x);

pmax = 16;
[~, ~, ~, ~, aic] = MVAR_estimate(x,pmax,'ns','aic');

pest = 6;
[ap,~,pfp] = MVAR_estimate_NS(x,pest);
Nf  = 256;
Par = MVAR_spectrum(Nc,ap,pest,pfp,Nf);

filename = ['results_single'];
save(filename,'aic','Par')

%% time for analysis on the DOUBLE connected columns
clear all; clc
load('data_double')

Nc = size(x,1);
Ns = size(x,2);
Nt = size(x,3);

% let's take out the temporal mean without normalizing it by the standard deviation
x = preprocess_temporalNormalization_alternative(x);

pmax = 16;
[~, ~, ~, ~, aic] = MVAR_estimate(x,pmax,'ns','aic');

pest = 12;
[ap,efp,pfp] = MVAR_estimate_NS(x,pest);
Nf    = 256;
Par   = MVAR_spectrum(Nc,ap,pest,pfp,Nf);
gpdc  = MVAR_gpdc(ap,pfp,Nf);
alpha = 0.01;
c001  = asymp_pdc_segments(x,ap,pfp,Nf,'diag',alpha,0,[1:Nf],[1:Nc]);

filename = ['results_double'];
save(filename,'aic','Par','gpdc','c001')




















