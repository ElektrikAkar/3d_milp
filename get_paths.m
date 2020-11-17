function pathStruct = get_paths()
% This function keeps all important path variables. Other functions call
% this function to get paths. 
% Author : VK
% Date   : 2020.05.05

pathStruct = struct();

pathStruct.root = fileparts(mfilename('fullpath')); 
% This file must be on the root folder!!!!

pathStruct.data.main = fullfile(pathStruct.root, "data");
pathStruct.data.CSV  = fullfile(pathStruct.data.main, "CSVs");
pathStruct.data.fit  = fullfile(pathStruct.data.main, "curveFittings");

pathStruct.checkpoints.main = fullfile(pathStruct.root, "checkpoints");

% Results:

pathStruct.results.main = fullfile(pathStruct.root, "results");

% External Libraries:
pathStruct.ExtLib.main = fullfile(pathStruct.root, "ExternalLibraries");

pathStruct.ExtLib.cbrewer        = fullfile(pathStruct.ExtLib.main, "cbrewer", "cbrewer");
pathStruct.ExtLib.RainClouds     = fullfile(pathStruct.ExtLib.main, "RainCloudPlots-master", "tutorial_matlab");
pathStruct.ExtLib.RobustStatisticalToolbox = fullfile(pathStruct.ExtLib.main, "Robust_Statistical_Toolbox-master");
pathStruct.ExtLib.customcolormap = fullfile(pathStruct.ExtLib.main, "customcolormap");
pathStruct.ExtLib.dataspace      = fullfile(pathStruct.ExtLib.main, "michellehirsch-MATLAB-Dataspace-to-Figure-Units-01f905b");
pathStruct.ExtLib.tightSubplot   = fullfile(pathStruct.ExtLib.main, "tightSubplot");

end