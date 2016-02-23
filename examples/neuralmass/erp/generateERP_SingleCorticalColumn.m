
clear all
clc

% define time-sampling parameters
Fs = 1000;
global Ts
Ts = 1/Fs;

% how many starting points to discard
burnin = 2000; 

% how many seconds to consider
Nsec = 450/Fs+burnin/Fs; 
time = 0:Ts:(Nsec-Ts);

% how many trials to simulate
Nt = 100;

% define output signal array
x  = zeros(1,numel(time)-burnin,Nt);

% define the values for the main physiological parameters
defineGlobalParams;

% define the values for the population parameters
w_area1 = 0.8; % population-weighting parameter (0 = gamma, 1 = alpha)
w_area2 = 0.2;
definePopulationParams

global terp 
Nerp = 225;
terp = Nerp/Fs+burnin/Fs;

%%

% simulate each trial
for trial = 1:Nt
    
    msg = ['trial = ' num2str(trial) '\n'];
    fprintf(msg)
    
    % define the nonlinear model to solve
    CI = zeros(12,1);
    h  = Ts;
    xs = ode4(@model_SingleCorticalColumn,time,CI,populationParameters)';
    
    % obtain the EEG values from the model internal states
    y = w_alpha_area1*(xs(4,:)-xs(5,:)) + w_gamma_area1*(xs(10,:)-xs(11,:));
    
    % discard the burnin period (corresponds to the transient state of the model)
    x(1,:,trial) = y(:,(burnin+1):end,:);
       
    clc
    
end

%%

s = x;
save('inputSignal','s','Fs')

%%

Ns  = size(x,2);
psd = zeros(1,Ns);

for trial = 1:Nt
  
    datatrial = (x(1,:,trial)-mean(x(1,:,trial),2));
    psd = psd + 1/Nt*1/Ns*abs(fft(datatrial)).^2;     
    
end

figure; hold on
freqs = [0:(Ns-1)]/Ns*Fs;
plot(freqs,10*log10(psd),'Color','blue','LineWidth',2.0)
grid on
xlim([freqs(2) 100])














