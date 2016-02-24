function dsdt = model_DoubleCorticalColumn(t,s,populationParameters,connectionParameters)      

    global S3y_area1 S3y_area1_Avg S3y_area1_Var 
    global S3y_area2 S3y_area2_Avg S3y_area2_Var
    global Ts
    
    global p_var
    
    % which time frame are we in
    tIndex = 1+floor(t/Ts); 
    % how many time frames to discard before connecting the cortical areas
    burnin = 500;
    
    % time delay between cortical areas
    d21 = connectionParameters(1,1);
    d12 = connectionParameters(2,1);    
    % degree of connectivity between cortical areas
    k21 = connectionParameters(1,2);
    k12 = connectionParameters(2,2);           
      
    % compute the weighted input from are 2 into area 1 (check the article by David and Friston)
    if tIndex > burnin
       S3tilde = S3y_area2(tIndex-d12) - S3y_area2_Avg(tIndex-d12);
       k12star = sqrt(p_var)*sqrt(2*k12-k12^2)/S3y_area2_Var(tIndex-d12);
       inputArea1 = k12star*S3tilde;
    else
       inputArea1 = 0; 
    end
    [dsdt_area1,S3y_area1_n] = stateSpace_CorticalColumn(t,s(1:12),populationParameters(1:2,:),inputArea1,k12);
    
    % compute the weighted input from are 1 into area 2 (check the article by David and Friston)
    if tIndex > burnin
       S3tilde = S3y_area1(tIndex-d21) - S3y_area1_Avg(tIndex-d21);
       k21star = sqrt(p_var)*sqrt(2*k21-k21^2)/S3y_area1_Var(tIndex-d21);
       inputArea2 = k21star*S3tilde;
    else
       inputArea2 = 0;  
    end
    [dsdt_area2,S3y_area2_n] = stateSpace_CorticalColumn(t,s(13:24),populationParameters(3:4,:),inputArea2,k21);    
    
    % update the values of S3y from areas 1 and 2
    S3y_area1(tIndex) = S3y_area1_n;
    S3y_area2(tIndex) = S3y_area2_n;    
    L = 100; % size of sliding window inside which we calculate mean and variance
    if tIndex > L
        S3y_area1_Avg(tIndex) = mean(S3y_area1((tIndex-L):tIndex),2);    
        S3y_area1_Var(tIndex) = var(S3y_area1((tIndex-L):tIndex),[],2);     
        S3y_area2_Avg(tIndex) = mean(S3y_area2((tIndex-L):tIndex),2);    
        S3y_area2_Var(tIndex) = var(S3y_area2((tIndex-L):tIndex),[],2);    
    end
    
    % concatenation of results 
    dsdt = [dsdt_area1; dsdt_area2];
    
end

function [dsdt,S3y_areaj] = stateSpace_CorticalColumn(t,s,params,S3ext,kij)

    global c1_1 c1_2
    global c2_1 c2_2
    global c3_1 c3_2
    
    global terp
    
    global p_avg p_var

    % s(t) = [x1(t); v1(t); x2(t); v2(t)]
    % s(t) = [x1_1(t); x1_2(t); x1_3(t); v1_1(t); v1_2(t); v1_3(t); x2_1(t); x2_2(t); x2_3(t); v2_1(t); v2_2(t); v2_3(t)]
    
    % population 1 data
    x1_1 = s(1);
    x1_2 = s(2);
    x1_3 = s(3);
    v1_1 = s(4);
    v1_2 = s(5);
    v1_3 = s(6);

    % population 1 parameters
    He1 = params(1,1);
    te1 = params(1,2);
    Hi1 = params(1,3);
    ti1 = params(1,4);
     w1 = params(1,5);

    % population 2 data
    x2_1 = s(7);
    x2_2 = s(8);
    x2_3 = s(9);
    v2_1 = s(10);
    v2_2 = s(11);
    v2_3 = s(12);

    % population 2 parameters
    He2 = params(2,1);
    te2 = params(2,2);
    Hi2 = params(2,3);
    ti2 = params(2,4);
     w2 = params(2,5);

    % state-space equations 
    p = externalnoise(t,p_avg,(1-kij)^2*p_var); 

    % population 1 - x1,v1
    x1_1d = He1/te1*(p + Sk(w1*v1_2+w2*v2_2,[c1_1 c1_2])+S3ext) - 2/te1*x1_1 - 1/(te1^2)*v1_1;
    v1_1d = x1_1;
    
    % population 2 - x1,v1
    x2_1d = He2/te2*(p + Sk(w1*v1_2+w2*v2_2,[c1_1 c1_2])) - 2/te2*x2_1 - 1/(te2^2)*v2_1;
    v2_1d = x2_1;

    % population 1 - x2,v2
    x1_2d = Hi1/ti1*(0 + Sk(w1*v1_3+w2*v2_3,[c2_1 c2_2])) - 2/ti1*x1_2 - 1/(ti1^2)*v1_2;
    v1_2d = x1_2;
    
    % population 2 - x2,v2
    x2_2d = Hi2/ti2*(0 + Sk(w1*v1_3+w2*v2_3,[c2_1 c2_2])) - 2/ti2*x2_2 - 1/(ti2^2)*v2_2;
    v2_2d = x2_2;

    % population 1 - x3,v3
    x1_3d = He1/te1*(0 + Sk(w1*(v1_1-v1_2)+w2*(v2_1-v2_2),[c3_1 c3_2])) - 2/te1*x1_3 - 1/(te1^2)*v1_3;
    v1_3d = x1_3;
    
    % population 2 - x3,v3
    x2_3d = He2/te2*(0 + Sk(w1*(v1_1-v1_2)+w2*(v2_1-v2_2),[c3_1 c3_2])) - 2/te2*x2_3 - 1/(te2^2)*v2_3;
    v2_3d = x2_3;

    % dsdt(t) = [dx1dt(t); dv1dt(t); dx2dt(t); dv2dt(t)]
    dsdt  = [x1_1d; x1_2d; x1_3d; v1_1d; v1_2d; v1_3d; x2_1d; x2_2d; x2_3d; v2_1d; v2_2d; v2_3d];
        
    S3y_areaj = Sk(w1*(v1_1-v1_2)+w2*(v2_1-v2_2),[c3_1 c3_2]);

end










