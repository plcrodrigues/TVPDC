function signalOut = preprocess_ensembleNormalization(signalIn)
% Normalizes the signal on its records dimension.
% It handles automatically the multiple records case.

    m = size(signalIn,1);

    signalOut = zeros(size(signalIn));
    for c = 1:m
        for i = 1:size(signalIn,2)

            avg  = mean(signalIn(c,i,:));
            sig2 = sqrt(var(signalIn(c,i,:)));
            
            if sig2 > 0
                signalOut(c,i,:) = (signalIn(c,i,:) - avg)/sig2; 
            else
                signalOut(c,i,:) = avg;
            end
        end
    end  

end