
function generateEEG_SingleCorticalColumn(filename,Nt)

    % define time-sampling parameters
    Fs = 250;
    global Ts
    Ts = 1/Fs;

    % how many starting points to discard
    burnin = 2000; 

    % how many seconds to consider
    Nsec = 1.0+burnin/Fs; 
    time = 0:Ts:(Nsec-Ts);

    % define output signal array
    x  = zeros(1,numel(time)-burnin,Nt);

    % define the values for the main physiological parameters
    defineGlobalParams;

    % define the values for the population parameters
    w_area1 = 0.8; % population-weighting parameter (0 = gamma, 1 = alpha)
    w_area2 = 0.2;
    definePopulationParams

    % simulate each trial
    for trial = 1:Nt

        msg = ['trial = ' num2str(trial) '\n'];
        fprintf(msg)

        % define the nonlinear model to solve
        CI = zeros(12,1);
        h  = Ts;
        xs = ode4(@model_SingleCorticalColumn,time,CI,populationParameters)';

        % obtain the EEG values from the model internal states
        y = w_alpha_area1*(xs(4,:)-xs(5,:)) + w_gamma_area1*(xs(10,:)-xs(11,:));

        % discard the burnin period (corresponds to the transient state of the model)
        x(1,:,trial) = y(:,(burnin+1):end,:);

        clc

    end
    
    save(filename,'x','Fs')
    
end














