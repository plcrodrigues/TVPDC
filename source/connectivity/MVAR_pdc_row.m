function c = MVAR_pdc_row(ap,nf)

    m  = size(ap,1);
    freqs = linspace(0,0.5,nf);
    A  = reshape(ap(:,m+1:end),m,m,[]);
    o  = size(A,3);
    Af = zeros(m,m,nf);
    for f = 1:nf
        for p = 1:o
             Af(:,:,f) = Af(:,:,f) + A(:,:,p)*exp(-1i*2*pi*freqs(f)*p);
        end
    end
    Abar = repmat(eye(m,m),[1 1 nf])-Af;    
    
    c = zeros(m,m,nf);
    for i = 1:m
        for j = 1:m
            for f = 1:nf
                c(i,j,f) = Abar(i,j,f)/norm(Abar(i,:,f),2);
            end
        end 
    end
    
end