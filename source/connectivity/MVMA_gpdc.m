function c = MVMA_gpdc(bp,pf,freqs)

    m  = size(bp,1);
    B0 = bp(:,1:m);
    
    Nf = numel(freqs);
    B  = reshape(bp(:,(m+1):end),m,m,[]);
    o  = size(B,3);
    Bf = zeros(m,m,Nf);
    for f = 1:Nf
        for p = 1:o
             Bf(:,:,f) = Bf(:,:,f) + B(:,:,p)*exp(-1i*2*pi*freqs(f)*p);
        end
    end

    Bbar = repmat(B0,[1 1 Nf])+Bf;
    for k = 1:Nf
       Bbar(:,:,k) = Bbar(:,:,k)\eye(m); 
    end

    c = zeros(m,m,Nf);
    for i = 1:m
        for j = 1:m
            for f = 1:Nf           
                c(i,j,f) = (Bbar(i,j,f)/sqrt(pf(i,i)))/sqrt(Bbar(:,j,f)'*(pf\eye(m))*Bbar(:,j,f));               
            end
        end 
    end
    
end
