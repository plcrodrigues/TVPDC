
function results = gpdc_tf(x,sz_window,p,nf,ntrials,type)
%% results = gpdc_tf(x,sz_window,p,nf,ntrials,type)
%
%  INPUTS:
%
%  x = data to be analyzed
%  sz_window = size of window to be slided through x
%  p = order of the MVAR model to be estimated
%  nf = number of frequencies to be considered in the PDC calculation
%  ntrials = numero de trials a serem usados
%  type = tipo de algoritmo MVAR 'ns', 'vm', 'rls'
%
%  OUTPUT
%
%  results = struct gathering all the important stuff
%

    m = size(x,1);
    x = x(:,:,1:ntrials);
    
    % preprocessamento do sinal - detrend, temporal avg, ensemble avg
    x_detrend     = preprocess_detrend(x);
    x_normalized1 = preprocess_temporalNormalization_alternative(x_detrend);
    %x_normalized  = preprocess_ensembleNormalization_alternative(x_normalized1);
    x_normalized  = preprocess_ensembleNormalization(x_normalized1);
     
    results.signal = x;    
    freqs = linspace(0,0.5,nf);
    
    if (strcmp(type,'ns') || strcmp(type,'vm') || strcmp(type,'ls'))

        % configurando as janelas de dados a serem consideradas
        delta = 1; % o overlap sera maximo entre as janelas
            W = zeros(size(x,2)-sz_window+1,sz_window);
        for w = 1:size(W,1)
            W(w,:) = 1 + delta*(w-1) + ([0:(sz_window-1)]);
        end
        nb_window = size(W,1);
        results.nb_window = nb_window;
        results.sz_window = sz_window;        

        fprintf(['Processing the signal.\nUsing ' num2str(ntrials) ' records.\nEach of the ' num2str(nb_window) ' sliding windows has ' num2str(sz_window) ' points.\n\n'])        

        for w = 1:nb_window

            msg = ['Processing window ' num2str(w) '\n\n'];
            fprintf(msg)

            x_window_normalized  = x_normalized(:,W(w,:),:);
            if (strcmp(type,'ns'))
                [ap_est, ef, pf]  = MVAR_estimate_NS(x_window_normalized,p);
%                 [portmanteau,Qh] = MVAR_portmanteau(ef,p,sz_window-p,0.95);
%                 pass(w) = portmanteau;
            elseif (strcmp(type,'vm'))
                [ap_est, ef, pf]  = MVAR_estimate_VM(x_window_normalized,p);
            elseif (strcmp(type,'ls'))
                [ap_est,pf] = MVAR_estimate_LS(x_window_normalized,p);     
                ef = [];
            end
            
               gpdc  = MVAR_gpdc(ap_est,pf,nf);
               spect = MVAR_spectrum(m,ap_est,p,pf,nf);

            results.window(w).ap    = ap_est;
            results.window(w).pf    = pf;
            results.window(w).p     = p;
            results.window(w).ep    = ef;       
            results.window(w).gpdc  = gpdc; 
            results.window(w).spect = spect;
            results.window(w).xwindow = x_window_normalized;
            results.window(w).interval = W(w,:);

            for b = 1:(numel(msg)-2)
                fprintf('\b')
            end

        end 

%         results.pass = pass;
        fprintf('\n')
            
    elseif strcmp(type,'rls')    
        
                  c = 0.2;
         [apn, pfn] = MVAR_rls(x_normalized,p,c);
         
        nf = 256;
         N = size(apn,3);
        gpdc = zeros(m,m,nf,N);
        spect = zeros(m,m,nf,N);
        for n = 1:N
            fprintf(num2str(n))
            gpdc(:,:,:,n)  = MVAR_gpdc([eye(m) -1*apn(:,:,n)],pfn(:,:,n),nf);
            spect(:,:,:,n) = MVAR_spectrum(m,[eye(m) -1*apn(:,:,n)],p,pfn(:,:,n),nf);
            fprintf('\b\b\b')
        end         
         
          results.apn = apn;
          results.pfn = pfn;
          results.p   = p;
         results.gpdc = gpdc;
        results.spect = spect;        
          results.c   = c;
        
    end

end

















