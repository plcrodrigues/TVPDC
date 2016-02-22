
function result = max97(x)
    
    if size(x,1) < size(x,2)
        x = x';
    end
    
    N = size(x,1);
    N97 = floor(0.97*N);
    xsorted = sort(x);
    
    result = xsorted(N97);

end