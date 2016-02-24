function p = externalnoise(t,avg,sigma2)

    p = avg + sqrt(sigma2)*randn;

end