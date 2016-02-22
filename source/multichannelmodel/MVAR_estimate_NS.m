function [ap, efp, pfp] = MVAR_estimate_NS(x,p)
%   [ap, efp, pfp] = MVAR_estimate_NS(x,p)
%
%   Use the Nuttal-Strand algorithm for the MVAR estimation. The algorithm
%   is adapted for dealing with multiple segments of the signal.
%
%   Input:
%
%       (3D matrix) x  = signal to be considered
%                        dimensions = [number os channels, size of segment, number of segments]
%       (int)       p  = true order of the MVAR process
%
%   Output:
%
%       (block array) ap = block array with the matrices of the MVAR process 
%                          example: ap = [I A1 A2 A3] 
    
    [m,sz_seg,nb_seg] = size(x);
    
    % declara as matrizes de coeficientes do MVAR
    A = zeros(m,m,p); % predicao forward
    B = zeros(m,m,p); % precicao backward

    % declara as matrizes de correlacao cruzada
    Delta = zeros(m,m,p);

    % declara as matrizes de covariancia de erros
    Pf = zeros(m,m,p); % covariancia do erro forward
    Pb = zeros(m,m,p); % covariancia do erro backward

    % declara os sinais de erros (um para cada segmento)
    ef = zeros(m,sz_seg,p,nb_seg); % erro do tipo forward
    eb = zeros(m,sz_seg,p,nb_seg); % erro do tipo backward
    
    % inicializa a recursao calculando os coeficientes de ordem zero
    ef0 = x;
    eb0 = x;
    Pf0 = zeros(m,m);
    Pb0 = zeros(m,m);
    for s = 1:nb_seg
        Pf0 = Pf0 + ef0(:,:,s)*ef0(:,:,s)';
        Pb0 = Pb0 + eb0(:,:,s)*eb0(:,:,s)';
    end
    Pf0 = Pf0/nb_seg;
    Pb0 = Pb0/nb_seg;

    % estima as matrizes de covariancia dos erros
    [Pf0_est, Pb0_est, Pfb0_est] = estimateErrorCovarianceMatrix_segments(ef0,eb0,0);

    % estima a matriz Delta (usando a ideia de Nuttall-Strand)
    Delta(:,:,1) = estimateDeltaMatrix(Pf0_est, Pb0_est, Pfb0_est, Pf0, Pb0);

    % calcula as matrizes de coeficientes de reflexao forward e backward
    RCmf = Delta(:,:,1)*(Pb0\eye(m));
    RCmb = Delta(:,:,1)'*(Pf0\eye(m));

    % atualiza os coeficientes do modelo MVAR 
    [A,B] = updateMVARcoeffs(A,B,RCmf,RCmb,1);

    % atualiza as matrizes de covariancia dos erros
    Pf(:,:,1) = Pf0 - A(:,:,1)*B(:,:,1)*Pf0;
    Pb(:,:,1) = Pb0 - B(:,:,1)*A(:,:,1)*Pb0;

    % atualiza os sinais de erro
    for s = 1:nb_seg
        ef(:,2:sz_seg,1,s) = ef0(:,2:sz_seg,s)   - A(:,:,1)*eb0(:,1:sz_seg-1,s);
        eb(:,2:sz_seg,1,s) = eb0(:,1:sz_seg-1,s) - B(:,:,1)*ef0(:,2:sz_seg,s);
    end

    % faz a recursao para ordens maiores do que 1
    for k = 2:p  

        % estima as matrizes de covariancia dos erros
        [Pf_est, Pb_est, Pfb_est] = estimateErrorCovarianceMatrix_segments(ef(:,:,k-1,:),eb(:,:,k-1,:),k-1);

        % estima a matriz Delta (usando a ideia de Nuttall-Strand)
        Delta(:,:,k) = estimateDeltaMatrix(Pf_est, Pb_est, Pfb_est, Pf(:,:,k-1), Pb(:,:,k-1));

        % calcula as matrizes de coeficientes de reflexao forward e backward  
        RCmf = Delta(:,:,k)*(Pb(:,:,k-1)\eye(m));
        RCmb = Delta(:,:,k)'*(Pf(:,:,k-1)\eye(m));

        % atualiza os coeficientes do modelo MVAR 
        [A,B] = updateMVARcoeffs(A,B,RCmf,RCmb,k);

        % atualiza as matrizes de covariancia dos erros      
        [Pf, Pb] = updateErrorCovarianceMatrix(Pf, Pb, A, B, k);

        % atualiza os sinais de erro    
        [ef,eb] = updateErrorSignal_segments(ef,eb, A, B, k);

    end
    
    ap  = [eye(m) reshape(A,m,m*p)];
    
    efp = ef(:,(p+1):end,p,:);
    efp = efp(:,:,:);
    pfp = Pf(:,:,p)/sz_seg; % normalizacao do Pf

end

function Delta = estimateDeltaMatrix(Pf_est, Pb_est, Pfb_est, Q1, Q2)

    m = size(Pf_est,1);
    A_lyap = Pf_est*(Q1\eye(m));
    B_lyap = Q2\Pb_est;
    C_lyap = -2*Pfb_est;
    Delta = lyap(A_lyap,B_lyap,C_lyap); % resolve a equacao de lyapunov
    
end

function [Pf_est, Pb_est, Pfb_est] = estimateErrorCovarianceMatrix_segments(ef,eb,k)

    [m,sz_seg,nb_seg] = size(ef);
    
    Pf_est  = zeros(m,m);
    Pb_est  = zeros(m,m);
    Pfb_est = zeros(m,m);
    for s = 1:nb_seg
        Pf_est  = Pf_est  + ef(:,k+2:sz_seg,s)*ef(:,k+2:sz_seg,s)';
        Pb_est  = Pb_est  + eb(:,k+1:sz_seg-1,s)*eb(:,k+1:sz_seg-1,s)';
        Pfb_est = Pfb_est + ef(:,k+2:sz_seg,s)*eb(:,k+1:sz_seg-1,s)';
    end
    Pf_est  = Pf_est/nb_seg;
    Pb_est  = Pb_est/nb_seg;
    Pfb_est = Pfb_est/nb_seg;
    
end

function [Pf_new, Pb_new] = updateErrorCovarianceMatrix(Pf_old, Pb_old, A, B, k)

    Pf_new = Pf_old;
    Pb_new = Pb_old;

    % atualiza as matrizes de covariancia dos erros    
    Pf_new(:,:,k) = Pf_old(:,:,k-1) - A(:,:,k)*B(:,:,k)*Pf_old(:,:,k-1);
    Pb_new(:,:,k) = Pb_old(:,:,k-1) - B(:,:,k)*A(:,:,k)*Pb_old(:,:,k-1);

end

function [ef_new, eb_new] = updateErrorSignal_segments(ef_old, eb_old, A, B, k)
    
    [~,sz_seg,~,nb_seg] = size(ef_old);
    
    ef_new = ef_old;
    eb_new = eb_old;

    % atualiza os sinais de erro
    for s = 1:nb_seg
        for n = (k+1):sz_seg
            ef_new(:,n,k,s) = ef_old(:,n,k-1,s)   - A(:,:,k)*eb_old(:,n-1,k-1,s);
            eb_new(:,n,k,s) = eb_old(:,n-1,k-1,s) - B(:,:,k)*ef_old(:,n,k-1,s);            
        end
    end       
end

function [Ak_new,Bk_new] = updateMVARcoeffs(Ak_old,Bk_old,RCmf,RCmb,k)
    
    Ak_new = zeros(size(Ak_old));
    Bk_new = zeros(size(Bk_old));
    
    Ak_new(:,:,k) = RCmf;
    Bk_new(:,:,k) = RCmb;  

    % atualiza os coeficientes de ordem inferior a k
    for i = 1:(k-1)
        Ak_new(:,:,i) = Ak_old(:,:,i) - RCmf*Bk_old(:,:,k-i);
        Bk_new(:,:,i) = Bk_old(:,:,i) - RCmb*Ak_old(:,:,k-i);
    end    
end
