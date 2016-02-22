
function result = min03(x)
    
    if size(x,1) < size(x,2)
        x = x';
    end
    
    N = size(x,1);
    N05 = ceil(0.03*N);
    xsorted = sort(x);
    
    result = xsorted(N05);

end