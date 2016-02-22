
clear all
clc

u  = sunmeladat([3 4]);
x  = u';
Nc = size(x,1);
Ns = size(x,2);

x(1,:) = detrend(x(1,:));
x(2,:) = detrend(x(2,:));

% figure
% subplot(2,1,1)
% plot(x(1,:),'Color','blue','LineWidth',2.0)
% subplot(2,1,2)
% plot(x(2,:),'Color','red','LineWidth',2.0)

pest = 3;
[ap, efp, pfp] = MVAR_estimate_NS(x,pest);
Nf   = 256;
pdc  = MVAR_pdc(ap,Nf);
gpdc = MVAR_gpdc(ap,pfp,Nf);

figure; n = 1;
freqs = linspace(0,0.5,Nf);
for ci = 1:Nc
    for cj = 1:Nc
   
        subplot(Nc,Nc,n)
        hold on
        
        pdcplot = reshape(pdc(ci,cj,:),1,[]);
        plot(freqs,abs(pdcplot).^2,'Color','blue','LineWidth',2.0);
        
        gpdcplot = reshape(gpdc(ci,cj,:),1,[]);
        plot(freqs,abs(gpdcplot).^2,'Color','red','LineWidth',2.0);
        
        ylim([0 1])
        xlim([0 0.5])
        
        n = n+1;
        
    end
end