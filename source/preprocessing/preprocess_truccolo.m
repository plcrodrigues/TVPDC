function signalOut = preprocess_truccolo(signalIn)
% Normalizes the signal in order to deal with its variance along the
% records. It uses the method proposed by Truccolo et al. 
% "Trial-to-trial variability of cortical evoked responses: implications
% for the analysis of functional connectivity" (2002).
% It handles automatically the multiple records case.

            m = size(signalIn,1);
    sz_record = size(signalIn,2);
    nb_record = size(signalIn,3);

    AERP = zeros(m,size(signalIn,2));
    for c = 1:m
        AERP(c,:) = mean(signalIn(c,:,:),3);
    end

    tau   = zeros(m,nb_record);
    alpha = zeros(m,nb_record); 
    for c = 1:m
        for r = 1:nb_record
            crosscorr   = xcorr(signalIn(c,:,r),AERP(c,:));
            [aux,imax]    = max(crosscorr);   
                 tau(c,r) = imax - sz_record;
               alpha(c,r) = aux/norm(signalIn(c,:,r),2)^2;
        end
    end

    signal_aux = zeros(size(signalIn));
    for r = 1:nb_record
        for c = 1:m
            if(tau(c,r) > 0)
                signal_aux(c,:,r) = signalIn(c,:,r) - alpha(c,r)*[zeros(1,tau(c,r)) AERP(c,1:(end-tau(c,r)))];
            elseif(tau(c,r) == 0)
                signal_aux(c,:,r) = signalIn(c,:,r) - alpha(c,r)*AERP(c,1:end);
            elseif(tau(c,r) < 0)
                signal_aux(c,:,r) = [zeros(1,abs(tau(c,r))) signalIn(c,1:(end-abs(tau(c,r))),r)] - alpha(c,r)*AERP(c,1:end);
            end
        end
    end
    
    signalOut = signal_aux; 

end