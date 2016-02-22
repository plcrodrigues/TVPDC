function c = MVMA_pdc(bp,freqs)

    m  = size(bp,1);
    B0 = bp(1:m,1:m);
    
    nf = numel(freqs);
    B  = reshape(bp(:,(m+1):end),m,m,[]);
    o  = size(B,3);
    Bf = zeros(m,m,nf);
    for f = 1:nf
        for p = 1:o
             Bf(:,:,f) = Bf(:,:,f) + B(:,:,p)*exp(-1i*2*pi*freqs(f)*p);
        end
    end

    Bbar = repmat(B0,[1 1 nf])+Bf;
    for k = 1:nf
       Bbar(:,:,k) = Bbar(:,:,k)\eye(m); 
    end

    c = zeros(m,m,nf);
    for i = 1:m
        for j = 1:m
            for f = 1:nf
                c(i,j,f) = Bbar(i,j,f)/norm(Bbar(:,j,f),2);
            end
        end 
    end
    
end