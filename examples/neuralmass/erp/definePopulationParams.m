
%% AREA 1

% population parameters (alpha)
te_alpha_area1 = 10/1000;  % [s]
He_alpha_area1 = 3.25;     % [mV]
ti_alpha_area1 = 20/1000;  % [s]
Hi_alpha_area1 = 22;       % [mV]
 w_alpha_area1 = w_area1;
populationParameters_alpha_area1 = [He_alpha_area1 te_alpha_area1 Hi_alpha_area1 ti_alpha_area1 w_alpha_area1];

% population parameters (gamma)
te_gamma_area1 = 2.5/1000; % [s]
He_gamma_area1 = 13.0;     % [mV]
ti_gamma_area1 = 5.0/1000; % [s]
Hi_gamma_area1 = 88.0;     % [mV]
 w_gamma_area1 = 1.0-w_area1;
populationParameters_gamma_area1 = [He_gamma_area1 te_gamma_area1 Hi_gamma_area1 ti_gamma_area1 w_gamma_area1];

% gather the parameters of each subpopulation
populationParameters_area1 = [populationParameters_alpha_area1; populationParameters_gamma_area1];

%% AREA 2

% population parameters (alpha)
te_alpha_area2 = 10/1000;  % [s]
He_alpha_area2 = 3.25;     % [mV]
ti_alpha_area2 = 20/1000;  % [s]
Hi_alpha_area2 = 22;       % [mV]
 w_alpha_area2 = w_area2;
populationParameters_alpha_area2 = [He_alpha_area2 te_alpha_area2 Hi_alpha_area2 ti_alpha_area2 w_alpha_area2];

% population parameters (gamma)
te_gamma_area2 = 2.5/1000; % [s]
He_gamma_area2 = 13.0;     % [mV]
ti_gamma_area2 = 5.0/1000; % [s]
Hi_gamma_area2 = 88.0;     % [mV]
 w_gamma_area2 = 1.0-w_area2;
populationParameters_gamma_area2 = [He_gamma_area2 te_gamma_area2 Hi_gamma_area2 ti_gamma_area2 w_gamma_area2];

% gather the parameters of each subpopulation
populationParameters_area2 = [populationParameters_alpha_area2; populationParameters_gamma_area2];

%%

populationParameters = [populationParameters_area1; populationParameters_area2];








