% These are initial values definitions. To select between one-time or
% optimizer optimization.
%
% Author: VK
% Date  : ?

if(SimulSettings.OptMode=="Once")
    init.c_kWh     = c_kWh(1:arbj.Nh); %To have a nice vector.
    init.bat.C_nom = arbj.bat.C_nom;
    init.bat.Tk0   = arbj.bat.Tk0;
    init.bat.Cbatt0= arbj.bat.Cbatt0;
    
elseif(SimulSettings.OptMode =="Optimizer")
    init.c_kWh      = sdpvar(arbj.Nh,1,'full');
    init.bat.C_nom  = sdpvar(1,1,'full');
    init.bat.Tk0    = sdpvar(1,1,'full');
    init.bat.Cbatt0 = sdpvar(1,1,'full');
    
    sdpv.input = {init.c_kWh, init.bat.C_nom, init.bat.Tk0, init.bat.Cbatt0};
else
    error('Simulation mode should be "Once" or "Optimizer"');
end
