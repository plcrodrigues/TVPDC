
clear all
clc

u  = sunmeladat([4 3]);
x  = u';
Nc = size(x,1);
Ns = size(x,2);

x(1,:) = detrend(x(1,:));
x(2,:) = detrend(x(2,:));

y  = sunmeladat([1]);

figure

subplot(2,1,1)
plot(y,x(1,:),'Color','blue','LineWidth',4.0)
set(gca,'LineWidth',2.0,'FontWeight','bold','FontSize',14)
title('sunspot','FontSize',18,'FontWeight','bold')
grid on

subplot(2,1,2)
plot(y,x(2,:),'Color','red','LineWidth',4.0)
set(gca,'LineWidth',2.0,'FontWeight','bold','FontSize',14)
title('melanoma','FontSize',18,'FontWeight','bold')
grid on

set(gcf,'position',[183   157   969   574])

%% Fixing a model order using AIC
% Note that we have very few sample data, so we can't expect to fit a very
% good model, right? Also, we shouldn't even consider models with high
% order, because they would have too few samples available for estimating
% their coefficientes

pmax = 5;
[p, ap, efp, pfp, aic] = MVAR_estimate(x,pmax,'ns','aic');
plot(1:pmax,aic,'LineWidth',4.0,'Color','blue')
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',2.0,'GridAlpha',0.05)
xlabel('model order')
title('AIC criterion','FontSize',18','FontWeight','bold')
set(gcf,'Position',[355   165   564   448])
grid on

%% Estimating the MVAR model and the GPDC+PDC between channels

pest = 4; % from the AIC graph we see that p = 4 seems reasonable
[ap, efp, pfp] = MVAR_estimate_NS(x,pest);

Nf     = 256;
alpha  = 0.01;

pdc    = MVAR_pdc(ap,Nf);
c_pdc  = asymp_pdc_segments(x,ap,pfp,Nf,'euc',alpha,0,[1:Nf],[1:Nc]);
gpdc   = MVAR_gpdc(ap,pfp,Nf);
c_gpdc = asymp_pdc_segments(x,ap,pfp,Nf,'diag',alpha,0,[1:Nf],[1:Nc]);

spect = MVAR_spectrum(Nc,ap,pest,pfp,Nf);

%% First comparing the results with GPDC and PDC
%  Plotting the autospectrum in the diagonal

figure; n = 1;
freqs = linspace(0,0.5,Nf);
for ci = 1:Nc
    for cj = 1:Nc
   
        subplot(Nc,Nc,n)
        hold on
        
        if ci == cj            
            spectplot = reshape(spect(ci,cj,:),1,[]);
            plot(freqs,(abs(spectplot)),'Color','black','LineWidth',3.0) 
            title(['PAR ' num2str(ci) num2str(cj)],'FontWeight','bold','FontSize',18)
        else                       
            pdcplot  = reshape(pdc(ci,cj,:),1,[]);
            plot(freqs,abs(pdcplot).^2,'Color','blue','LineWidth',3.0);        
            gpdcplot = reshape(gpdc(ci,cj,:),1,[]);
            plot(freqs,abs(gpdcplot).^2,'Color','red','LineWidth',3.0);
            ylim([0 1])  
            title(['|(' num2str(cj) ') -> (' num2str(ci) ')|^2'],'FontWeight','bold','FontSize',18)
        end
        
        xlim([0 0.5])
        set(gca,'FontWeight','bold','FontSize',14,'LineWidth',2.0)
        xlabel('normalized frequency','FontSize',16,'FontWeight','bold')
        
        n = n+1;
        
    end
end

set(gcf,'Position',[285   119   724   587])

%% Let's plot the PDC and GPDC with their thresholds for significance

figure; n = 1;
freqs = linspace(0,0.5,Nf);

ci = 2; cj = 1;

subplot(2,2,1)
hold on
pdcplot  = reshape(pdc(ci,cj,:),1,[]);
plot(freqs,abs(pdcplot).^2,'Color','blue','LineWidth',3.0); 
thrplot  = reshape(c_pdc.th(ci,cj,:),1,[]);
plot(freqs,thrplot,'Color','blue','LineStyle','--','LineWidth',2.0)
title(['|(' num2str(cj) ') -> (' num2str(ci) ')|^2'],'FontWeight','bold','FontSize',18)
xlim([0 0.5])
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',2.0)
xlabel('normalized frequency','FontSize',16,'FontWeight','bold')

subplot(2,2,2)
hold on
gpdcplot = reshape(gpdc(ci,cj,:),1,[]);
plot(freqs,abs(gpdcplot).^2,'Color','red','LineWidth',3.0);
thrplot  = reshape(c_gpdc.th(ci,cj,:),1,[]);
plot(freqs,thrplot,'Color','red','LineStyle','--','LineWidth',2.0)
title(['|(' num2str(cj) ') -> (' num2str(ci) ')|^2'],'FontWeight','bold','FontSize',18)
xlim([0 0.5])
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',2.0)
xlabel('normalized frequency','FontSize',16,'FontWeight','bold')

ci = 1; cj = 2;

subplot(2,2,3)
hold on
pdcplot  = reshape(pdc(ci,cj,:),1,[]);
plot(freqs,abs(pdcplot).^2,'Color','blue','LineWidth',3.0); 
thrplot  = reshape(c_pdc.th(ci,cj,:),1,[]);
plot(freqs,thrplot,'Color','blue','LineStyle','--','LineWidth',2.0)
title(['|(' num2str(cj) ') -> (' num2str(ci) ')|^2'],'FontWeight','bold','FontSize',18)
xlim([0 0.5])
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',2.0)
xlabel('normalized frequency','FontSize',16,'FontWeight','bold')

subplot(2,2,4)
hold on
gpdcplot = reshape(gpdc(ci,cj,:),1,[]);
plot(freqs,abs(gpdcplot).^2,'Color','red','LineWidth',3.0);
thrplot  = reshape(c_gpdc.th(ci,cj,:),1,[]);
plot(freqs,thrplot,'Color','red','LineStyle','--','LineWidth',2.0)
title(['|(' num2str(cj) ') -> (' num2str(ci) ')|^2'],'FontWeight','bold','FontSize',18)
xlim([0 0.5])
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',2.0)
xlabel('normalized frequency','FontSize',16,'FontWeight','bold')

set(gcf,'Position',[285   119   724   587])











