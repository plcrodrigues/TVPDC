function signalOut = preprocess_ensembleNormalization_alternative(signalIn)
% Normalizes the signal on its records dimension.
% It handles automatically the multiple records case.

    m = size(signalIn,1);

    signalOut = zeros(size(signalIn));
    for c = 1:m
        for i = 1:size(signalIn,2)
            signalOut(c,i,:) = (signalIn(c,i,:) - mean(signalIn(c,i,:))); 
        end
    end  

end