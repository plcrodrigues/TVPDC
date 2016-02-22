function stable = MVAR_checkstability(ap) 
% ap = [I A1 A2 ... AP]

    m = size(ap,1);
    coeffs = ap(:,m+1:end);    
    p = size(coeffs,2)/m;
    
    A = [coeffs; eye(m*(p-1)) zeros(m*(p-1),m)];
    l_max = max(abs(eig(A)))
    abs(eig(A))
    
    stable = (l_max < 1);
    
end