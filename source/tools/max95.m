
function result = max95(x)
    
    if size(x,1) < size(x,2)
        x = x';
    end
    
    N = size(x,1);
    N95 = floor(0.95*N);
    xsorted = sort(x);
    
    result = xsorted(N95);

end