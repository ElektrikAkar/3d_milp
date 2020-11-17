% This file is created by Volkan Kumtepeli.
% it is the batch simulator for different cases.
% Date   : 2018.12.17
% Update : 2020.05.01

clear all; close all; clc; %#ok<CLALL>

batchSettings = SimulationSettings.get_paperSettings_open; % Change this function for different batch simulations.
addSettings = [];
% Additional settings for test purposes: 
addSettings.Threads = 0;
addSettings.noDays     = 4/24;
addSettings.studyName  = "paper_2020_07_05_test";
%addSettings.MIPGap     = 5/100;

%-----------------------------

for i_batch = 1:length(batchSettings)
    
    SimulSettings = simulationSettings(batchSettings(i_batch), addSettings);
    
    % Data loading:
    data_handling;
    load_param;
    load_param_calender;
    
    def_functions;
    
    numeric_definitions;
    
    sdpvar_definitions;
    
    run_optimization;
    
    
    tempAllvariables = who;
    tempAllvariables_str = string(tempAllvariables);
    tempAllvariables(tempAllvariables_str=="i_batch"|tempAllvariables_str=="batchSettings" | tempAllvariables_str=="addSettings") = [];
    
    clear(tempAllvariables{:});
    yalmip('clear');
    
end