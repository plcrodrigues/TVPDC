function [ap, pfp] = MVAR_estimate_LS(x,p)

         m = size(x,1);
    sz_seg = size(x,2);
    nb_seg = size(x,3);

    X = zeros(m*p,(sz_seg-p)*nb_seg);
    Y = zeros(m,(sz_seg-p)*nb_seg);
    for s = 1:nb_seg
        for j = (p+1):sz_seg
            Y(:,(s-1)*(sz_seg-p)+(j-p)) = x(:,j,s);
        end
    end

    for s = 1:nb_seg
        for i = 0:(p-1)
            for j = p:(sz_seg-1)
                X(i*m+[1:m],(s-1)*(sz_seg-p)+(j-p+1)) = x(:,j-i,s);
            end
        end
    end

    Xsty = kron(X',eye(m));
    Asty = Xsty\Y(:);
    Aest_LS = reshape(Asty,m,[]);  
        
    ap = [eye(m) Aest_LS];
    pfp = (Y-Aest_LS*X)*(Y-Aest_LS*X)'/size(X,2);    

end