% This file is created by Volkan Kumtepeli (VK).
% it is the initial optimization code.
% This file is recreated for the temperature paper using MDPI paper results.
% Date: 2018.11.16
% Re-creation date: 2019.07.01
% Update :   2020.03.30
% Update-2 : 2020.04.08

clear all; close all; clc; %#ok<CLALL>

mySettings    = SimulationSettings.get_paperSettings_open;

addSettings = [];
addSettings.noDays_all = 8/24;
%addSettings.noDays     = 24/24;
%addSettings.noDays_control = 6/24;
addSettings.studyName  = "paper_2020_07_30_test";
%addSettings.MIPGap     = 1.5/100;
%addSettings.isCheckpointsActive = false;

SimulSettings = simulationSettings(mySettings(1), addSettings);

% Data loading:
data_handling;
load_param;
load_param_calender;

def_functions;

% Data plotting (if needed)
plot_input_data;

% Optimization problem definition:
numeric_definitions;
sdpvar_definitions;

%% Optimize it!

run_optimization;

