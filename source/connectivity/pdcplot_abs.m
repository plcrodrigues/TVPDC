function pdcplot_abs(pdc)

    Nc = size(pdc,1);
    Nf = size(pdc,3);

    figure
    n = 1;
    for ci = 1:Nc
        for cj = 1:Nc

            subplot(Nc,Nc,n)

            freqs = linspace(0,0.5,Nf);
            pdcplot = reshape(pdc(ci,cj,:),1,[]);        
            plot(freqs,abs(pdcplot),'LineWidth',3.0)

            title(['|PDC (' num2str(cj) ') -> (' num2str(ci) ')|'],'FontWeight','bold','FontSize',18)
            grid on
            set(gca,'LineWidth',1.5,'FontWeight','bold','FontSize',12)
            ylim([0 1])
            xlim([0 0.5])

            if ci == Nc
               xlabel('normalized frequency','FontWeight','bold','FontSize',14) 
            end

            n = n+1;

        end
    end

end