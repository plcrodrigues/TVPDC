function c = MVMA_dtf(bp,freqs)

    m  = size(bp,1);
    nf = numel(freqs);
    B0 = bp(:,1:m);
    B  = reshape(bp(:,m+1:end),m,m,[]);
    o  = size(B,3);
    Bf = zeros(m,m,nf);
    for f = 1:nf
        for p = 1:o
             Bf(:,:,f) = Bf(:,:,f) + B(:,:,p)*exp(-1i*2*pi*freqs(f)*p);
        end
    end
    H = repmat(B0,[1 1 nf])+Bf;    
    
    c = zeros(m,m,nf);
    for i = 1:m
        for j = 1:m
            for f = 1:nf
                c(i,j,f) = H(i,j,f)/norm(H(:,j,f),2);
            end
        end 
    end
    
end