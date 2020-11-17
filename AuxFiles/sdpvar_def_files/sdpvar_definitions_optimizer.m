% This file is definition for optimizer object. 

% sdpv.input  <- defined at tbe beginning. 
% sdpv.output <- defined here.

sdpv.output = eval( "{" + join(SimulSettings.optimizerOutputNames,", ") + "}");  % To dynamically 


%{sdpv.AC.Pnett, sdpv.bat.Tk, sdpv.bat.Cbatt, sdpv.bat.I_cell, sdpv.bat.Tk, sdpv.bat.Pnett, sdpv.bat.SOC, sdpv.J, sdpv.Jstep.AC_power, sdpv.Jstep.Aging, sdpv.bat.SOC}; %.Pnett

sdpv.optimizer = optimizer(sdpv.const, sdpv.J, sdpvarSettings, sdpv.input, sdpv.output);

