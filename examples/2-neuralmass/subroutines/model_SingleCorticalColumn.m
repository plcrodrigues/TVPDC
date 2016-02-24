function dsdt = model_SingleCorticalColumn(t,s,params)
   
    global c1_1 c1_2
    global c2_1 c2_2
    global c3_1 c3_2
    
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
    p = externalnoise(t,p_avg,p_var); 

    % population 1 - x1,v1
    x1_1d = He1/te1*(p + Sk(w1*v1_2+w2*v2_2,[c1_1 c1_2])) - 2/te1*x1_1 - 1/(te1^2)*v1_1;
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
    
end









