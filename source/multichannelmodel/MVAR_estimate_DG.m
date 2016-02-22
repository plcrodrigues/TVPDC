function [ap, efp, pfp] = MVAR_estimate_DG(x,p)
%   [ap, efp, pfp] = MVAR_estimate_DG(x,p)
%
%   Use the Ding AMVAR algorithm for the MVAR estimation. 
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
   
            m = size(x,1);
           Nx = size(x,2);
    nb_record = size(x,3);
    
           Nw = Nx-p;
    
    [ap, pfp] = armorf(reshape(x,m,[]),nb_record,Nx,p);
    ap  = [eye(size(x,1)) ap];        

    % calculando o sinal de residuo
    efp = zeros(m,Nw,nb_record);
    for n = p+1:Nx
        for r = 1:nb_record
            for i = 0:p
                efp(:,n-p,r) = efp(:,n-p,r) + ap(:,i*m+[1:m])*x(:,n,r);
            end
        end
    end
    
end
