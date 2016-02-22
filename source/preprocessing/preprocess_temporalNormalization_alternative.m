function signalOut = preprocess_temporalNormalization_alternative(signalIn)
% Normalizes the signal on its time dimension.
% It handles automatically the multiple records case.

    m = size(signalIn,1);

    signalOut = zeros(size(signalIn));            
    for record = 1:size(signalIn,3)
        for c = 1:m
            signalOut(c,:,record) = (signalIn(c,:,record) - mean(signalIn(c,:,record)));
        end
    end  

end