
function result = max99(x)
    
    if size(x,1) < size(x,2)
        x = x';
    end
    
    N = size(x,1);
    N99 = floor(0.99*N);
    xsorted = sort(x);
    
    result = xsorted(N99);

end