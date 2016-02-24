function [n2,n3] = calculateSNR(x,n,SNR)

    aux2 = reshape(x(2,n-1,:),1,[]);
    energy2 = sum(aux2.^2,2)/numel(aux2);
    n2 = sqrt(energy2/SNR)*randn;
    
    aux3 = reshape(x(3,n-1,:),1,[]);
    energy3 = sum(aux3.^2,2)/numel(aux3);
    n3 = sqrt(energy3/SNR)*randn;

end

