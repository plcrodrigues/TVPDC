function [apn, pfn] = MVAR_rls(x,p,c)

    ntrials = size(x,3);
    m = size(x,1);
    N = size(x,2);   

    theta = zeros(m,m*p,N);
    C = zeros(m*p,m*p,N,ntrials);
    C(:,:,p,ntrials) = eye(m*p);

    sigma = repmat(0.001*eye(m),[1 1 N]);

    for n = (p+1):N

        Yn = reshape(x(:,n,:),m,ntrials)';
        Wn = zeros(ntrials,m*p);
        for j = 1:p
            Yj = reshape(x(:,n-j,:),m,ntrials)';
            Wn(:,m*(j-1)+[1:m]) = Yj;
        end

        C0 = 1/(1-c)*C(:,:,n-1,ntrials);
        C(:,:,n,1) = C0*(eye(m*p,m*p)-(Wn(1,:)'*Wn(1,:)*C0)/(Wn(1,:)*C0*Wn(1,:)'+1));

        for s = 2:ntrials
            C(:,:,n,s) = C(:,:,n,s-1)*(eye(m*p,m*p)-(Wn(s,:)'*Wn(s,:)*C(:,:,n,s-1))/(Wn(s,:)*C(:,:,n,s-1)*Wn(s,:)'+1));
        end

        Gn = Wn*C(:,:,n,end);
        Zn = Yn - Wn*theta(:,:,n-1)';
        theta(:,:,n) = theta(:,:,n-1) + Zn'*Gn;

        sigma(:,:,n) = (1-c)*sigma(:,:,n-1) + c/ntrials*(Zn'*Zn);

    end   

    apn = theta;
    pfn = sigma;
    
end