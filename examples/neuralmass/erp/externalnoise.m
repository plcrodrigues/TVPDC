function p = externalnoise(t,terp,avg,sigma2)

    if t > terp    
        n = 7;
        w = 1*10^-3;
        q = 0.05;
        p = avg + sqrt(sigma2)*randn + q*((t-terp)/w)^n*exp(-(t-terp)/w);
    else
        p = avg + sqrt(sigma2)*randn;
    end    
    
end