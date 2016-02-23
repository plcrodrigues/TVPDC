
% These are the main physiological parameters for simulating each cortical column.

% physiological parameters (adimensional)
global c1_1 c1_2
global c2_1 c2_2
global c3_1 c3_2

c1_1 = 135;
c1_2 = 108;

c2_1 = 33.75;
c2_2 = 33.75;

c3_1 = 1.0;
c3_2 = 1.0;

% sigmoid parameters
global v0 e0 r 
v0 = 6.0;  % [mV]
e0 = 5.0;  % [1/s]
r  = 0.56; % [1/mV]

% stochastic input parameters (gaussian)
global p_avg p_var
p_avg = 220;
p_var = 484;

global S3y_area1 S3y_area1_Avg S3y_area1_Var
S3y_area1     = zeros(1,numel(time));
S3y_area1_Avg = zeros(1,numel(time));
S3y_area1_Var = zeros(1,numel(time));

global S3y_area2 S3y_area2_Avg S3y_area2_Var
S3y_area2     = zeros(1,numel(time));
S3y_area2_Avg = zeros(1,numel(time));
S3y_area2_Var = zeros(1,numel(time));