function fig = pdctf_plot(pdc,spect,L,Fs,nswitch)

    Nc = size(pdc,1);
    Nf = size(pdc,3);
    Ns = size(pdc,4);
       
    time = [1:Ns];
    freqs = linspace(0,0.5,Nf)*Fs;
    
    fig = figure;
    n = 1;

    for ci = 1:Nc
        for cj = 1:Nc

            subplot(Nc,Nc,n)
            if ci == cj
                I = reshape(spect(ci,cj,:,:),Nf,[]);
                imagesc(time,freqs,10*log10(abs(I)))
                title(['10 log(|PAR' num2str(cj) num2str(ci) '|)'],'FontWeight','bold','FontSize',18)    
            else
                I = reshape(pdc(ci,cj,:,:),Nf,[]);
                imagesc(time,freqs,abs(I).^2,[0 1])
                title(['|PDC (' num2str(cj) ') -> (' num2str(ci) ')|^2'],'FontWeight','bold','FontSize',18)            
            end

            hold on
            plot([nswitch nswitch],[0 60],'LineWidth',3.0,'LineStyle','--','Color','white')
            set(gca,'YDir','normal')
            set(gca,'FontWeight','bold','FontSize',12,'LineWidth',2.0)
            xlabel('sample','FontSize',14,'FontWeight','bold')
            ylabel('frequency (Hz)','FontSize',14,'FontWeight','bold')
            ylim([0 60])
            xlim([L+1 Ns])
            n = n+1;

        end
    end

    set(gcf,'position',[172   121   918   579])
    
end

