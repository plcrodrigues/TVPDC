function [pass,Qh] = MVAR_portmanteau(efp_est,p_est,portmanteau_lagmax,thr)

         m = size(efp_est,1);
        ns = size(efp_est,2);
    nb_seg = size(efp_est,3);

    C0 = zeros(m);
    for s = 1:nb_seg
        C0 = C0 + 1/ns*efp_est(:,:,s)*efp_est(:,:,s)';
    end
    C0 = C0/nb_seg;
    
    C = zeros(m,m,portmanteau_lagmax);

    for h = 1:portmanteau_lagmax
        Fh = diag(ones(ns-h,1),-h);        
        for s = 1:nb_seg
            C(:,:,h) = C(:,:,h) + 1/ns*efp_est(:,:,s)*Fh*efp_est(:,:,s)'; 
        end
    end
    C = C/nb_seg;

% Ljung-Box test
    Qh = 0;
    for h = 1:portmanteau_lagmax
       Qh = Qh + 1/(ns*nb_seg-h)*trace(C(:,:,h)'*(C0\eye(m))*C(:,:,h)*(C0\eye(m))); 
    end
    Qh = (ns*nb_seg)^2*Qh;
    pass = Qh < chi2inv(thr,(portmanteau_lagmax-p_est)*m^2);
    chi2inv(thr,(portmanteau_lagmax-p_est)*m^2)

% %Li-McLeod test
%     Qh = 0;
%     for h = 1:portmanteau_lagmax
%        Qh = Qh + trace(C(:,:,h)'*(C0\eye(m))*C(:,:,h)*(C0\eye(m))); 
%     end
%     Qh = (ns*nb_seg)*Qh + m^2*portmanteau_lagmax*(portmanteau_lagmax+1)/(2*(ns*nb_seg));
%     pass = Qh < chi2inv(thr,(portmanteau_lagmax-p_est)*m^2);

end


























