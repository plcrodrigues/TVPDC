

clear all
clc

%% Results from figure 1

% first define the parameters for the simulation
Nc = 2;    % number of channels
Ns = 128; % number of samples to be simulated

% define the coefficients of the model to be simulated and then estimated
A0  = eye(Nc);
a11 = 0.5; a12 = 0.5; a22 = 0.5;
A1  = [a11 a12; 0 a22];
ap  = [A0 A1];
sigma = eye(Nc);
sigma(1,1) = 1;
sigma(2,2) = 10;

Nrzt  = 100;
Nf    = 256;
pdc   = zeros(Nc,Nc,Nf,Nrzt);
gpdc  = zeros(Nc,Nc,Nf,Nrzt);

for rzt = 1:Nrzt
     
    % simulate data
    x = MVAR_simulate(ap,sigma,Ns);

    % estimate MVAR model from samples
    p_est  = 1; % let's consider that we already know which is the order of the correct model
    [ap_est, ~, pfp_est] = MVAR_estimate_NS(x,p_est); % estimating using the Nuttall-Strand algorithm

    % let's estimate and plot the PDC
    pdc(:,:,:,rzt)  = MVAR_pdc(ap_est,Nf);
    gpdc(:,:,:,rzt) = MVAR_gpdc(ap_est,pfp_est,Nf);

end

%% plot results

figure
for rzt = 1:Nrzt
   
    freqs = linspace(0,0.5,Nf);
    
    subplot(1,2,1)
    title(['|PDC (2) -> (1)|'],'FontSize',18,'FontWeight','bold')
    pdcplot = reshape(pdc(2,1,:,rzt),1,[]);
    plot(freqs,abs(pdcplot),'LineWidth',1.0,'color','blue')
    grid on
    set(gca,'LineWidth',1.5,'FontWeight','bold','FontSize',12)    
    hold on
    ylim([0 1]) 
    xlabel('normalized frequency','FontWeight','bold','FontSize',14) 
    
    subplot(1,2,2)
    title(['|GPDC (2) -> (1)|'],'FontSize',18,'FontWeight','bold')
    gpdcplot = reshape(gpdc(2,1,:,rzt),1,[]);
    plot(freqs,abs(gpdcplot),'LineWidth',1.0,'color','red')
    grid on
    set(gca,'LineWidth',1.5,'FontWeight','bold','FontSize',12)    
    hold on
    ylim([0 1])     
    xlabel('normalized frequency','FontWeight','bold','FontSize',14) 
    
end
set(gcf,'Position',[1 1 1051 410])

%% Calculate the significance thresholds with the asymptotic theory

% simulate data
x = MVAR_simulate(ap,sigma,Ns);

% estimate MVAR model from samples
p_est  = 1; % let's consider that we already know which is the order of the correct model
[ap_est, ~, pfp_est] = MVAR_estimate_NS(x,p_est); % estimating using the Nuttall-Strand algorithm

% let's estimate and plot the PDC
pdc(:,:,:,rzt)  = MVAR_pdc(ap_est,Nf);
gpdc(:,:,:,rzt) = MVAR_gpdc(ap_est,pfp_est,Nf);

alpha      = 0.01;
c_pdc_001  = asymp_pdc_segments(x,ap,pfp_est,Nf,'euc',alpha,0,[1:Nf],[1:Nc]);
c_gpdc_001 = asymp_pdc_segments(x,ap,pfp_est,Nf,'diag',alpha,0,[1:Nf],[1:Nc]);

%% plot results

freqs = linspace(0,0.5,Nf);

for rzt = 1:Nrzt

    subplot(1,2,1)
    hold on
    title(['|PDC (2) -> (1)|^2 (alpha = 0.01)'],'FontSize',18,'FontWeight','bold')
    pdcplot = reshape(pdc(2,1,:,rzt),1,[]);
    plot(freqs,abs(pdcplot).^2,'LineWidth',0.5,'color','blue')
    thrplot = reshape(c_pdc_001.th(2,1,:),1,[]);
    plot(freqs,thrplot,'LineWidth',4.0,'LineStyle','--','color','black')
    grid on
    set(gca,'LineWidth',1.5,'FontWeight','bold','FontSize',12)    
    hold on
    ylim([0 0.5]) 
    xlim([0 0.5])
    xlabel('normalized frequency','FontWeight','bold','FontSize',14) 

    subplot(1,2,2)
    hold on
    title(['|GPDC (2) -> (1)|^2 (alpha = 0.01)'],'FontSize',18,'FontWeight','bold')
    gpdcplot = reshape(gpdc(2,1,:,rzt),1,[]);
    plot(freqs,abs(gpdcplot).^2,'LineWidth',0.5,'color','red')
    thrplot = reshape(c_gpdc_001.th(2,1,:),1,[]);
    plot(freqs,thrplot,'LineWidth',4.0,'LineStyle','--','color','black')
    grid on
    set(gca,'LineWidth',1.5,'FontWeight','bold','FontSize',12)    
    hold on
    ylim([0 0.1]) 
    xlim([0 0.5])
    xlabel('normalized frequency','FontWeight','bold','FontSize',14) 
    
end
set(gcf,'Position',[1 1 1051 410])











