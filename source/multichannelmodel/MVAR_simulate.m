% Simula processos MVAR a partir de
%   - order:   ordem do processo conhecida
%   - ap:      matriz em blocos [I A1 A2 ... AP]
%   - sigma:   matriz de covariancias do ruido de inovacao
%   - N:       numero de pontos a serem simulados em cada canal

function x = MVAR_simulate(ap,sigma,N) 

    m = size(ap,1);
    coeffs = ap(:,m+1:end);
    p = size(coeffs,2)/m;
    
    %escolho um valor para o burn in (escolho N para que l_max^N = 10^-6*l_max)
    if(p > 1)
        A = [coeffs; eye(m*(p-1)) zeros(m*(p-1),m)];
        l_max = max(abs(eig(A)));
        Lb = ceil(1-6/log10(l_max));
    else
        l_max = max(abs(eig(coeffs)));
        Lb = ceil(1-6/log10(l_max));
    end
    
    w = chol(sigma,'lower')*randn(m,N+Lb);
    
    x = zeros(m,N+Lb);
    x(:,1:p) = w(:,1:p);
    for n = (p+1):N+Lb
        for k = 1:p
            x(:,n) = x(:,n)+coeffs(:,(k-1)*m+1:(k-1)*m+m)*x(:,n-k);
        end
        x(:,n) = x(:,n)+w(:,n);
    end
    
    x = x(:,Lb+1:end);
    
end