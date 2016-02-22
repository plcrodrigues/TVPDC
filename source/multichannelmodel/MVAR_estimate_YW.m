function ap = MVAR_estimate_YW(x,p)
%   ap = MVAR_estimate_YW(x,p)
%
%   Use the Yule-Walker method for the MVAR estimation. The algorithm
%   is adapted for dealing with multiple segments of the signal, averaging 
%   the covariance matrices along the multiple trials.
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
    R = estimateCovarianceMatrix_average(x,p);

    Rblock_matrix = zeros(p*m,p*m);
    for i = 0:p-1
        for j = 0:p-1
            if i-j < 0
                Rblock_matrix(j*m+1:j*m+m,i*m+1:i*m+m) = R(:,:,abs(i-j)+1)';
            elseif i-j >= 0     
                Rblock_matrix(j*m+1:j*m+m,i*m+1:i*m+m) = R(:,:,(i-j)+1);
            end
        end
    end

    Rblock_array = zeros(m,m*p);
    for j = 1:p
        Rblock_array(:,(j-1)*m+1:(j-1)*m+m) = -1*R(:,:,j+1)';
    end

    ap = [eye(m) (Rblock_matrix'\Rblock_array')'];    
    
end

function R = estimateCovarianceMatrix_average(x,p)

    [m,sz_seg,nb_seg] = size(x); 
    R = zeros(m,m,p+1);
    for n = 0:p
        Raux = zeros(m,m,nb_seg);
        for s = 1:nb_seg
            for i = 1:sz_seg-n
                Raux(:,:,s) = Raux(:,:,s) + x(:,i,s)*x(:,i+n,s)';
            end
            Raux(:,:,s) = Raux(:,:,s)/(sz_seg-n);
        end
        R(:,:,n+1) = mean(Raux,3); % os indices na 3a dimensao sao todos somados de um
    end    

end
