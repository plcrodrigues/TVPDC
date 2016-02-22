function [p, ap, efp, pfp, aic] = MVAR_estimate(x,pmax,algorithm,criterion)

m = size(x,1);
if size(x,3) > 1
    N = size(x,2)*(size(x,3)/4);
    else
    N = size(x,2);
end
p = pmax;

aux_old = inf;
ap_old  = [];
efp_old = [];
pfp_old = [];

if nargin == 2
       
    [ap,efp,pfp] = MVAR_estimate_NS(x,pmax);

elseif nargin == 3
    
    switch algorithm        
        case 'ns'          
            [ap,efp,pfp] = MVAR_estimate_NS(x,pmax);
        case 'vm'
            [ap,efp,pfp] = MVAR_estimate_VM(x,pmax);
        case 'ls'
            [ap,pfp] = MVAR_estimate_LS(x,pmax);
            efp = [];
    end

elseif nargin == 4
    
    aic = zeros(1,pmax);

        switch algorithm        
            case 'ns'          
                [ap,efp,pfp] = MVAR_estimate_NS(x,1);
            case 'vm'
                [ap,efp,pfp] = MVAR_estimate_VM(x,1);
        end
                
        switch criterion
            case 'aic'
                aic(1) = 2*log(det(pfp))+2*m^2*1/N;
            case 'fpe'   
                aic(1) = ((N+m*1+1)/(N-m*1-1))^m*det(pfp);             
        end    
    
    for pindex = 2:pmax
        
        pindex

        switch algorithm        
            case 'ns'                      
                [ap,efp,pfp] = MVAR_estimate_NS(x,pindex);
            case 'vm'
                [ap,efp,pfp] = MVAR_estimate_VM(x,pindex);
        end
                
        switch criterion
            case 'aic'
                aic(pindex) = 2*log(det(pfp))+2*m^2*pindex/N;
            case 'fpe'   
                aic(pindex) = ((N+m*pindex+1)/(N-m*pindex-1))^m*det(pfp);             
        end

%         if (strcmp(criterion,'fpe')) && (aic(pindex) < aic(pindex-1))
%             ap_old  = ap;
%             efp_old = efp;
%             pfp_old = pfp;
%         elseif (strcmp(criterion,'aic')) && (aic(pindex) < aic(pindex-1))
%             ap_old  = ap;
%             efp_old = efp;
%             pfp_old = pfp;
%         else
%             p = pindex - 1;
%             ap  = ap_old;
%             efp = efp_old;
%             pfp = pfp_old;
%             break
%         end
        
    end
    
end    
    
end