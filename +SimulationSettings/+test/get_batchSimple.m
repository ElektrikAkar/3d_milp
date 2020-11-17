function paperSettings = get_batchSimple()
% In this file, settings for different cases in our paper is given. 
% Author: VK
% Date  : 2020.04.30

i=1;

caseBaseName = "test_batch";

paperSettings(i).noDays         = 2/24;  % /6; %number of days
paperSettings(i).noDays_all     = 8/24;  % -> Whole simulation in days
paperSettings(i).noDays_control = 1/24;  % -> Control horizon in days.


paperSettings(i).C_rate_ch      = 1;     % Max C-rate for charge
paperSettings(i).C_rate_disch   = 2;     % Max C-rate for discharge

paperSettings(i).studyName      = caseBaseName; % A distinct name of the study so that  %real_2020_04_07


paperSettings(i).TimeLimit      = 200; % Per step
paperSettings(i).Threads        = 0; % Use 5 cores not to consume all resources.
paperSettings(i).MIPGap         = 1.5e-2; % i% MIPGap

paperSettings(i).dataName       = "test_diverging"; %diverging test data. Discussed on 20i8.i2.07


paperSettings(i).effName        = "combined"; % Battery losses + power electronic losses
paperSettings(i).tempMode       = "dynamic";  % notOptimized = accounted but constant in optimization.


paperSettings(i).Tk_const       = KELVIN+25; % If temperature is taken constant in optimization, this parameter is used.
paperSettings(i).OptMode        = "Optimizer";

paperSettings(i).DiminishingBoundaries = false;

paperSettings(i).checkpointName  = caseBaseName + "_check_" + num2str(i) + "_2020_07_03"; % This is for checkpoints.

paperSettings(i).segm.P.n   = 16; 
paperSettings(i).segm.SOC.n = 8; 
paperSettings(i).segm.T.n   = 8; 

% ---------------------------------------------------

paperSettings = repmat(paperSettings,4,1); % Repeat these settings! 


%-------- Case 2: PE EFF INCLUDED BUT NO TEMPERATURE OPTIMIZATION ---------

i = 2;
paperSettings(i).TimeLimit       = 1000; % Per step
paperSettings(i).effName         = "combined"; % Battery losses + power electronic losses
paperSettings(i).tempMode        = "notOptimized";
paperSettings(i).checkpointName  = caseBaseName + "_check_" + num2str(i) + "_2020_05_01"; % This is for checkpoints.


%-------- Case 3: PE EFF NOT INCLUDED BUT YES TEMPERATURE OPTIMIZATION ---------

i = 3;
paperSettings(i).TimeLimit       = 2000; % Per step
paperSettings(i).effName         = "bat_loss"; % Battery losses + power electronic losses
paperSettings(i).tempMode        = "dynamic";
paperSettings(i).checkpointName  = caseBaseName + "_check_" + num2str(i) + "_2020_05_01"; % This is for checkpoints.


%-------- Case 3: PE EFF NOT INCLUDED AND NO TEMPERATURE OPTIMIZATION ---------

i = 4;
paperSettings(i).TimeLimit       = 600; % Per step
paperSettings(i).effName         = "bat_loss"; % Battery losses + power electronic losses
paperSettings(i).tempMode        = "notOptimized";
paperSettings(i).checkpointName  = caseBaseName + "_check_" + num2str(i) + "_2020_05_01"; % This is for checkpoints.


end