function results = process_slidingwindow(signal,windows,parameters)
   
            m = size(signal,1);
     order_AR = parameters.order_AR;
     order_MA = parameters.order_MA;
        freqs = parameters.freqs;
         pmax = parameters.pmax;

    for w = 1:size(windows,1) 
           
        fprintf(['window = ' num2str(w) '\n'])                     

        % pega so o trecho da janela que nos interessa
            
            x_window = signal(:,windows(w,:),:);
            
        % faz as devidas normalizacoes
            
            % 1st preprocessing - normalization using the mean along the time
            x_window_normalized1 = preprocess_temporalNormalization_alternative(x_window);      

            % 2nd preprocessing - normalization using the mean along the trials
            x_window_normalized  = preprocess_ensembleNormalization_alternative(x_window_normalized1);            
        
        % calculations using the adapted NS algorithm
        
            [ap_NS, ef_NS, pf_NS] = MVAR_estimate_NS(x_window_normalized,order_AR);      
            results.window(w).algorithm(1).ap = ap_NS;
            results.window(w).algorithm(1).pf = pf_NS;
            results.window(w).algorithm(1).ef = ef_NS;

            bp_NS = MVMA_estimate_NS(x_window,order_MA,pmax);
            results.window(w).algorithm(1).bp = bp_NS;

        % calculations using the adapted VM algorithm
        
            [ap_VM, ef_VM, pf_VM] = MVAR_estimate_VM(x_window_normalized,order_AR);      
            results.window(w).algorithm(2).ap = ap_VM;
            results.window(w).algorithm(2).pf = pf_VM;
            results.window(w).algorithm(2).ef = ef_VM;
            
            bp_VM = MVMA_estimate_VM(x_window,order_MA,pmax);
            results.window(w).algorithm(2).bp = bp_VM;            

        % calculations using Ding's method (algorithm was taken directly from the BSmart toolbox)

            [ap_DG, ef_DG, pf_DG] = MVAR_estimate_DG(x_window_normalized,order_AR);      
            results.window(w).algorithm(3).ap = ap_DG;
            results.window(w).algorithm(3).pf = pf_DG; 
            results.window(w).algorithm(3).ef = ef_DG;
            
            bp_DG = MVMA_estimate_DG(x_window,order_MA,pmax);
            results.window(w).algorithm(3).bp = bp_DG;            
            
        % calculating the pdc                    

            gpdc_NS_AR = asymp_pdc_segments_MVAR(x_window,reshape(-1*ap_NS(:,(m+1):end),m,m,[]),pf_NS,size(freqs,2),'diag',0.05);
            results.window(w).algorithm(1).pdc_AR = gpdc_NS_AR.pdc;
            results.window(w).algorithm(1).thr_AR = gpdc_NS_AR.th;
            
            gpdc_VM_AR = asymp_pdc_segments_MVAR(x_window,reshape(-1*ap_VM(:,(m+1):end),m,m,[]),pf_VM,size(freqs,2),'diag',0.05);
            results.window(w).algorithm(2).pdc_AR = gpdc_VM_AR.pdc;
            results.window(w).algorithm(2).thr_AR = gpdc_VM_AR.th;
            
            gpdc_DG_AR = asymp_pdc_segments_MVAR(x_window,reshape(-1*ap_DG(:,(m+1):end),m,m,[]),pf_DG,size(freqs,2),'diag',0.05);
            results.window(w).algorithm(3).pdc_AR = gpdc_DG_AR.pdc;
            results.window(w).algorithm(3).thr_AR = gpdc_DG_AR.th;     
            
            gpdc_NS_MA = asymp_pdc_segments_MVMA(x_window,reshape(bp_NS,m,m,[]),pf_NS,256,'diag',0.05);
            results.window(w).algorithm(1).pdc_MA = gpdc_NS_MA.pdc;
            results.window(w).algorithm(1).thr_MA = gpdc_NS_MA.th;
            
            gpdc_VM_MA = asymp_pdc_segments_MVMA(x_window,reshape(bp_VM,m,m,[]),pf_VM,256,'diag',0.05);
            results.window(w).algorithm(2).pdc_MA = gpdc_VM_MA.pdc;
            results.window(w).algorithm(2).thr_MA = gpdc_VM_MA.th;
            
            gpdc_DG_MA = asymp_pdc_segments_MVMA(x_window,reshape(bp_DG,m,m,[]),pf_DG,256,'diag',0.05);
            results.window(w).algorithm(3).pdc_MA = gpdc_DG_MA.pdc;
            results.window(w).algorithm(3).thr_MA = gpdc_DG_MA.th;                                  

        % gathering the results
            
            results.window(w).algorithm(1).name = 'Nuttall Strand';
            results.window(w).algorithm(2).name = 'Vieira Morf';
            results.window(w).algorithm(3).name = 'Ding AMVAR';              
            
            results.window(w).xwindow  = x_window;
            results.window(w).xwindow_normalized = x_window_normalized;
            results.window(w).interval = windows(w,:);                        

    end   

end

