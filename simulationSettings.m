function SimulSettings = simulationSettings(varargin)
%-------------------------------------------%
% Author: VK
% Date:   2020.04.06
% Description: This function defines base simulation settings to override
% base settings send the additional settings through this function. 
addpath(genpath("AuxFiles"));
addpath(genpath("plt"));
addpath(genpath("tests"));

%------- Configurable Parameters:-------
SimulSettings.noDays         = 8/24;  % /6; %number of days
%----Used only in loop-simulation: ----
SimulSettings.noDays_all     = 30*24/24;    % -> Whole simulation in days
SimulSettings.noDays_control = 4/24; % -> Control horizon in days.

SimulSettings.C_rate_ch    = 1;     % Max C-rate for charge
SimulSettings.C_rate_disch = 2;     % Max C-rate for discharge
SimulSettings.studyName    = "act_20_04_30"; % A distinct name of the study so that  %real_2020_04_07
% we can name it! My convention is "YYYY_MM_DD" but "test" for testing
% purposes

SimulSettings.TimeLimit = 2700; % Per step
SimulSettings.Threads   = 0; % Use 5 cores not to consume all resources.
SimulSettings.MIPGap    = 1.5e-2; % 1% MIPGap


% Select a data
%SimulSettings.dataName  = "first_oneday";
%SimulSettings.dataName  = "EPEX";
%SimulSettings.dataName  = "test_diverging"; %diverging test data. Discussed on 2018.12.07
%SimulSettings.dataName  = "dayaheadauktion";
%SimulSettings.dataName  = "square_wave_100"; % 0 eur 100 eur.
SimulSettings.dataName  = "idc_2018_last";
%SimulSettings.dataName  = "idc_2018_wap";

%dataName = SimulSettings.dataName;

%Select an efficiency approximation method:

%SimulSettings.effName  = "no_loss";  % No loss at all.
%SimulSettings.effName  = "bat_loss";  % Only battery losses are included.
%SimulSettings.effName  = "pe_loss";   % only power electronics loss is considered.
SimulSettings.effName   = "combined"; % Battery losses + power electronic losses


%Select a cycle aging model:

%SimulSettings.cycAgName = "cal";      % Only calendar aging included
%SimulSettings.cycAgName = "cyc";      % Only cycle aging is included.
%SimulSettings.cycAgName = "calcyc";   % Both cycle and calendar aging included.
SimulSettings.cycAgName = "no_aging"; % No aging is included.


%SimulSettings.tempMode  = "notOptimized";  % notOptimized = accounted but constant in optimization.
%SimulSettings.tempMode  = "const";  % if it is considered const then it is
%considered 25 C in optimization. DONT USE
SimulSettings.tempMode  = "dynamic"; %

SimulSettings.SOCmode   = "dynamic";
%SimulSettings.SOCmode   = "notOptimized";  % SOC is fixed for cost function & current only.


SimulSettings.const.Tk   = KELVIN+25; % If temperature is taken constant in optimization, this parameter is used.
SimulSettings.const.SOC  = 0.5;       % If SOC is taken constant in optimization, this parameter is used.

SimulSettings.OptMode  = "Optimizer";
%SimulSettings.OptMode = "Once"; %- Not working in this new setting, will
%be fixed.

SimulSettings.DiminishingBoundaries = false;

SimulSettings.Plot_Input_Data = false;
SimulSettings.checkpointName  = ""; % This is for saving

SimulSettings.optimizerOutputNames = ["sdpv.AC.Pnett", "sdpv.bat.Tk", "sdpv.bat.Cbatt", "sdpv.bat.I_cell", "sdpv.bat.Tk", ...
    "sdpv.bat.Pnett", "sdpv.bat.SOC", "sdpv.J", "sdpv.Jstep.AC_power", "sdpv.Jstep.Aging", "sdpv.bat.SOC", "sdpv.bat.Pcell_approx", ...
    "sdpv.bat.I_cell", "sdpv.bat.Pcell_ch_approx", "sdpv.bat.Pcell_disch_approx", "sdpv.bat.thermal_approx.dT", "sdpv.bat.thermal_approx.dQ", ...
    "sdpv.bat.SOCavg", "sdpv.bat.Tk_avg"];

SimulSettings.segm.battery = "optimal";  % "optimally spaced (not available for all segmentations. Use 16-8-8  -2C-1C
%SimulSettings.segm.battery = "equi";     % "equally spaced. 


%% Semi-configurable parameters
%
% These variables denote paths etc. Do not change if not sure.

SimulSettings.isCheckpointsActive = true; % True as default. But false when changed or filename is not given. 

SimulSettings.nonsv.initialized = 0; %0: first eval, 1: next eval, -1 get data from matfile.

SimulSettings.isMatlabNew    = ~verLessThan('matlab','9.6'); % Less than 2019a

SimulSettings.path = get_paths(); % fullfile command is used to make code portable to Linux.

SimulSettings.added_ExtLib = ["cbrewer", "RainClouds", "RobustStatisticalToolbox", "customcolormap", "dataspace", "tightSubplot"];

for lib = SimulSettings.added_ExtLib
      addpath(genpath( SimulSettings.path.ExtLib.(lib) ));
end

% if MATLAB is old, use csvread instead of readmatrix.


SimulSettings.SavedVariables = ["SimulSettings", "nonsv", "p_loop"]; % These will be saved variables. Yet to be implemented.

%combineStructs = @(x,y) cell2struct([struct2cell(x),struct2cell(y)],[fields(x),fields(y)],length([fields(x),fields(y)]));

SimulSettings.segm.P.n   = 16;
SimulSettings.segm.SOC.n = 8;
SimulSettings.segm.T.n   = 8;

SimulSettings.segm.filename = "temp_paper_data_segm.mat";
SimulSettings.segm.path     = fullfile(SimulSettings.path.data.main, SimulSettings.segm.filename);


% data.segm.path     = fullfile(SimulSettings.path.data.main,data.segm.filename);


% ---- VARIABLE ARGUMENTS -----

i = 1;
while(i<=nargin)
    if isempty(varargin{i})
        i = i+1;
    elseif (ischar(varargin{i}) || isstring(varargin{i}))
        SimulSettings.(varargin{i}) = varargin{i+1};
        i = i+2;
    elseif (isstruct(varargin{i}))
        SimulSettings = mergeStructs(SimulSettings, varargin{i}, false);
        i = i+1;
    else
        fprintf('There are some additional arguments, I am not sure what to do!\n');
        fprintf('See argument %d.\n',i);
        i = nargin+1; % Not sure what to do
    end

end

SimulSettings.path.checkpoints.current = fullfile(SimulSettings.path.checkpoints.main, SimulSettings.checkpointName+".mat");
SimulSettings.isCheckpointsActive      = ~strcmpi(SimulSettings.checkpointName, "") & SimulSettings.isCheckpointsActive;
SimulSettings.isCheckpointfileExists   = exist(SimulSettings.path.checkpoints.current, 'file')==2;

if (SimulSettings.isCheckpointsActive)

    if(SimulSettings.isCheckpointfileExists)

    fprintf("Checkpoints are active. <strong>" + SimulSettings.checkpointName + ".mat </strong> file is loading!\n");
    temp = load(SimulSettings.path.checkpoints.current, "SimulSettings");
    
    temp_path = SimulSettings.path;
    SimulSettings = mergeStructs(SimulSettings, temp.SimulSettings, SimulSettings.isCheckpointsActive);
    SimulSettings.path = temp_path;
    SimulSettings.nonsv.initialized = -1; % For reading from matfile.
  %  temp = load(SimulSettings.checkpointPath,"noDays");
  %  SimulSettings.noDays = temp.noDays;
   % temp = load(SimulSettings.checkpointPath,"noDays_all");
   % SimulSettings.noDays_all = temp.noDays_all;
    %temp = load(SimulSettings.checkpointPath,"noDays_control");
    % SimulSettings.noDays_control = temp.noDays_control;
    else
    fprintf("Checkpoints are active. <strong>" + SimulSettings.checkpointName + ".mat </strong> file is NOT FOUND but will be CREATED at each step!\n");
    SimulSettings.nonsv.initialized = 0; % For reading from matfile.
    end
end


% ---- Dependent Variables -----
% These variables depend on previous variables. Therefore, they have been
% accumulated here just before varargin. If some of the variables change by
% varargin then these are also changed. Please try not to change these.

SimulSettings.p_loop_len     = SimulSettings.noDays_all/SimulSettings.noDays_control;

SimulSettings.SaveFileName   = SimulSettings.studyName + "_" + ...
                               SimulSettings.tempMode  + "_" + ...
                               SimulSettings.SOCmode   + "_" + ...
                               SimulSettings.effName   + "_" + ...
                               num2str(SimulSettings.C_rate_disch) + "C_" + ...
                               num2str(SimulSettings.noDays_all) + "_days.mat";

SimulSettings.SaveFilePath   = fullfile(SimulSettings.path.results.main, SimulSettings.SaveFileName);

SimulSettings.nonsv.effName  = SimulSettings.effName; %"bat_loss"; % For nonlinear simul.
%SimulSettings.nonsv.effName = "combined"; % For nonlinear simul.






end
