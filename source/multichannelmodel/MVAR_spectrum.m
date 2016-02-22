function Par = MVAR_spectrum(m,ap,p,Pw,nf)

% m  = dimension of the multichannel
% a  = block array with the A matrices [I A1 ... Ap]
% p  = order of the AR
% Pw = covariance matrix of the noise

    aux = reshape(ap,m,m,[]);
    aux(:,:,2:end) = -1*aux(:,:,2:end);
    ap = reshape(aux,m,[]);

    f   = linspace(0.0,0.5,nf);
    Par = zeros(m,m,nf);
    for k = 1:nf
        ep = eye(m);
        for o = 1:p
            ep = [ep exp(1j*2*pi*f(k)*o)*eye(m)];
        end
        Par(:,:,k) = (ap*ep')\(Pw*((ep*ap')\eye(m)));
    end

end