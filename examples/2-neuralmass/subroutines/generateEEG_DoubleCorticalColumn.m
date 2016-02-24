function generateEEG_DoubleCorticalColumn(filename,Nt)

    % define time-sampling parameters
    Fs = 250;
    global Ts
    Ts = 1/Fs;

    % how many starting points to discard
    burnin = 1000; 

    % how many seconds to consider
    Nsec = 1.0+burnin/Fs; 
    time = 0:Ts:(Nsec-Ts);

    % define output signal array
    x  = zeros(2,numel(time)-burnin,Nt);

    % define the values for the main physiological parameters
    defineGlobalParams;

    % define the values for the population parameters
    w_area1 = 0.8; % population-weighting parameter (0 = gamma, 1 = alpha)
    w_area2 = 0.2;
    definePopulationParams

    % time delay between cortical areas dij: (j) -> (i)
    d21 = 10;
    d12 = 10;
    % degree of connectivity between cortical areas kij: (j) -> (i)
    k21 = 0.5;
    k12 = 0.0;
    connectionParameters = [d21 k21; d12 k12];

    % simulate each trial
    for trial = 1:Nt

        msg = ['trial = ' num2str(trial) '\n'];
        fprintf(msg)

        % define the nonlinear model to solve
        CI = zeros(24,1);
        h  = Ts;
        xs = ode4(@model_DoubleCorticalColumn,time,CI,populationParameters,connectionParameters)';

        % obtain the EEG values from the model internal states
        y_area1 = w_alpha_area1*(xs(4,:)-xs(5,:))   + w_gamma_area1*(xs(10,:)-xs(11,:));
        y_area2 = w_alpha_area2*(xs(16,:)-xs(17,:)) + w_gamma_area2*(xs(22,:)-xs(23,:));

        % discard the burnin period (corresponds to the transient state of the model)
        x(1,:,trial) = y_area1(:,(burnin+1):end,:);
        x(2,:,trial) = y_area2(:,(burnin+1):end,:);

        clc

    end
   
    save(filename,'x','Fs')
    
end    



















