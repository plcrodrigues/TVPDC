
% define time-sampling parameters
Fs = 1000;
global Ts
Ts = 1/Fs;

% how many starting points to discard
burnin = 2000; 

% how many seconds to consider
Nsec = 450/Fs+burnin/Fs; 
time = 0:Ts:(Nsec-Ts);

n = 7;
w = 1*10^-3;
q = 1.0*10^-3;

Nerp = 225;
terp = Nerp/Fs+burnin/Fs;

p = q*((time-terp)/w).^n.*exp(-(time-terp)/w).*[zeros(1,Nerp+burnin-1) ones(1,450+burnin-(Nerp+burnin-1))];

plot(p)
%xlim([terp Nsec])