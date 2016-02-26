
clear all
clc

%% Results from figure 1

% first define the parameters for the simulation
Nc = 3;    % number of channels
Ns = 2048; % number of samples to be simulated

% define the coefficients of the model to be simulated and then estimated
A0 = eye(Nc);
A1 = [0.5 0.3 0.4; -0.5 0.3 1.0; 0.0 -0.3 -0.2];
ap = [A0 A1];
sigma = eye(Nc);

% simulate data
x = MVAR_simulate(ap,sigma,Ns);

% estimate MVAR model from samples
p_est  = 1; % let's consider that we already know which is the order of the correct model
[ap_est, ~, ~] = MVAR_estimate_NS(x,p_est); % estimating using the Nuttall-Strand algorithm

% let's estimate and plot the PDC
Nf  = 256;
pdc = MVAR_pdc(ap_est,Nf);
pdcplot_abs(pdc)
set(gcf,'position',[219 114 821 583])

%% Results from figure 2

% first define the parameters for the simulation
Nc = 5;    % number of channels
Ns = 2048; % number of samples to be simulated

% define the coefficients of the model to be simulated and then estimated
A0 = eye(Nc);

A1 = zeros(Nc);
A1(1,1) =  0.95*sqrt(2);
A1(4,4) =  0.25*sqrt(2);
A1(4,5) =  0.25*sqrt(2);
A1(5,4) = -0.25*sqrt(2);
A1(5,5) =  0.25*sqrt(2);

A2 = zeros(Nc);
A2(1,1) = -0.9025;
A2(2,1) =  0.5;
A2(4,1) = -0.5;

A3 = zeros(Nc);
A3(3,1) = -0.4;

ap = [A0 A1 A2 A3];
sigma = eye(Nc);

% simulate data
x = MVAR_simulate(ap,sigma,Ns);

% estimate MVAR model from samples
p_est  = 3; % let's consider that we already know which is the order of the correct model
[ap_est, ~, ~] = MVAR_estimate_NS(x,p_est); % estimating using the Nuttall-Strand algorithm

% let's estimate and plot the PDC
Nf  = 256;
pdc = MVAR_pdc(ap_est,Nf);
pdcplot_abs(pdc)
set(gcf,'position',[98 113 1045 571])

%% Results from figure 5

% first define the parameters for the simulation
Nc = 5;    % number of channels
Ns = 2048; % number of samples to be simulated

% define the coefficients of the model to be simulated and then estimated
A0 = eye(Nc);

A1 = zeros(Nc);
A1(1,1) =  0.95*sqrt(2);
A1(2,1) = -0.5;
A1(4,3) = -0.5;
A1(4,4) =  0.25*sqrt(2);
A1(4,5) =  0.25*sqrt(2);
A1(5,4) = -0.25*sqrt(2);
A1(5,5) =  0.25*sqrt(2);

A2 = zeros(Nc);
A2(1,1) = -0.9025;
A2(3,2) = -0.4;

A3 = zeros(Nc);

A4 = zeros(Nc);
A4(3,1) = 0.1; 

ap = [A0 A1 A2 A3 A4];
sigma = eye(Nc);

% simulate data
x = MVAR_simulate(ap,sigma,Ns);

% estimate MVAR model from samples
p_est  = 4; % let's consider that we already know which is the order of the correct model
[ap_est, ~, ~] = MVAR_estimate_NS(x,p_est); % estimating using the Nuttall-Strand algorithm

% let's estimate and plot the PDC
Nf  = 256;
pdc = MVAR_pdc(ap_est,Nf);
pdcplot_abs(pdc)
set(gcf,'position',[98 113 1045 571])



