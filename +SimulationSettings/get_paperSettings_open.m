function paperSettings = get_paperSettings_open()
% In this file, settings for different cases in our paper is given. 
% Author: VK
% Date  : 2020.04.30
% Update: 2020.07.04

dateStr = "2020_07_30";

i=1;

paperSettings(i).noDays         = 8/24;  % /6; %number of days
paperSettings(i).noDays_all     = 365*24/24;  % -> Whole simulation in days
paperSettings(i).noDays_control = 4/24; % -> Control horizon in days.


%paperSettings(i).C_rate         = 2;     % Max C-rate for both ways. 
paperSettings(i).C_rate_ch      = 1;     % Max C-rate for charge
paperSettings(i).C_rate_disch   = 2;     % Max C-rate for discharge 

paperSettings(i).studyName      = "paper_" + dateStr; % A distinct name of the study so that  %real_2020_04_07


paperSettings(i).TimeLimit      = 1500; % Per step
paperSettings(i).Threads        = 0; % Use 5 cores not to consume all resources.
paperSettings(i).MIPGap         = 1.8e-2; % i% MIPGap

paperSettings(i).dataName       = "random_data_similar_idc"; %diverging test data. Discussed on 2018.i2.07


paperSettings(i).effName        = "combined"; % Battery losses + power electronic losses
paperSettings(i).tempMode       = "dynamic";  % notOptimized = accounted but constant in optimization.
paperSettings(i).SOCmode        = "dynamic";  % notOptimized = accounted but constant in optimization.


paperSettings(i).const.Tk       = KELVIN + 25; % If temperature is taken constant in optimization, this parameter is used.
paperSettings(i).const.SOC      = 0.5;         % If temperature is taken constant in optimization, this parameter is used.
paperSettings(i).OptMode        = "Optimizer";

paperSettings(i).checkpointName  = "paper_check_case_" + num2str(i) + "_" + dateStr; % This is for checkpoints.

paperSettings(i).segm.P.n        = 16; 
paperSettings(i).segm.SOC.n      = 8; 
paperSettings(i).segm.T.n        = 8; 

paperSettings(i).segm.battery    = "optimal";

paperSettings(i).DiminishingBoundaries = false;


% ---------------------------------------------------

paperSettings = repmat(paperSettings,6,1); % Repeat these settings! 


%-------- Case 2: PE EFF INCLUDED BUT NO TEMPERATURE OPTIMIZATION ---------

i = 2;
paperSettings(i).TimeLimit       = 800; % Per step
paperSettings(i).effName         = "combined"; % Battery losses + power electronic losses
paperSettings(i).tempMode        = "notOptimized";
paperSettings(i).checkpointName  = "paper_check_case_" + num2str(i) +  "_" + dateStr; % This is for checkpoints.


%-------- Case 3: PE EFF NOT INCLUDED BUT YES TEMPERATURE OPTIMIZATION ---------

i = 3;
paperSettings(i).TimeLimit       = 1200; % Per step
paperSettings(i).effName         = "bat_loss"; % Battery losses +  no power electronic losses
paperSettings(i).tempMode        = "dynamic";
paperSettings(i).checkpointName  = "paper_check_case_" + num2str(i) +  "_" + dateStr; % This is for checkpoints.


%-------- Case 3: PE EFF NOT INCLUDED AND NO TEMPERATURE OPTIMIZATION ---------

i = 4;
paperSettings(i).TimeLimit       = 500; % Per step
paperSettings(i).effName         = "bat_loss"; % Battery losses + no power electronic losses
paperSettings(i).tempMode        = "notOptimized";
paperSettings(i).checkpointName  = "paper_check_case_" + num2str(i) +  "_" + dateStr; % This is for checkpoints.

%-------- Case 3: SOC ALSO CONSIDERED NOT OPTIMIZED ---------

i = 5;
paperSettings(i).TimeLimit       = 400; % Per step
paperSettings(i).effName         = "combined"; % Battery losses + no power electronic losses
paperSettings(i).tempMode        = "notOptimized";
paperSettings(i).SOCmode         = "notOptimized";
paperSettings(i).checkpointName  = "paper_check_case_" + num2str(i) +  "_" + dateStr; % This is for checkpoints.

%-------- Case 3: SOC ALSO CONSIDERED NOT OPTIMIZED ---------

i = 6;
paperSettings(i).TimeLimit       = 300; % Per step
paperSettings(i).effName         = "bat_loss"; % Battery losses + no power electronic losses
paperSettings(i).tempMode        = "notOptimized";
paperSettings(i).SOCmode         = "notOptimized";
paperSettings(i).checkpointName  = "paper_check_case_" + num2str(i) +  "_" + dateStr; % This is for checkpoints.

end