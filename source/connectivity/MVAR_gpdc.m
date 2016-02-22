function c = MVAR_gpdc(ap,pf,nf,indexFreq)

    if nargin < 4

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
                    c(i,j,f) = (Abar(i,j,f)*1/sqrt(pf(i,i)))/sqrt(Abar(:,j,f)'*(diag(diag(pf))\eye(m))*Abar(:,j,f));
                end
            end 
        end
        
    else
        
        m  = size(ap,1);
        freqs = linspace(0,0.5,nf);
        A  = reshape(ap(:,m+1:end),m,m,[]);
        o  = size(A,3);
        Af = zeros(m,m,1);
        for p = 1:o
            Af(:,:,1) = Af(:,:,1) + A(:,:,p)*exp(-1i*2*pi*freqs(indexFreq)*p);
        end
        Abar = repmat(eye(m,m),[1 1 1])-Af;    

        c = zeros(m,m,1);
        for i = 1:m
            for j = 1:m
                c(i,j) = (Abar(i,j,1)*1/sqrt(pf(i,i)))/sqrt(Abar(:,j,1)'*(diag(diag(pf))\eye(m))*Abar(:,j,1));
            end 
        end        
    
    end
    
end
