function [ y ] = Sk(v,params)
%SK Summary of this function goes here
%   Detailed explanation goes here

    global e0 v0 r

    ck_1 = params(1);
    ck_2 = params(2);
    
    y = (ck_1*e0)/(1+exp(r*(v0-ck_2*v)));

end

