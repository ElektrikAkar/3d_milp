% This is a nonlinear observer (or a pseudo simSES kind of function to use
% not approximated versions of the functions.
%
% Author: VK
% Date  : ?

nonsv.dth = 1/32; % 3 minutes time step for nonlinear observer execution.
nonsv.Nh  = SimulSettings.noDays_all*24/nonsv.dth;

nonsv.N_control   = SimulSettings.noDays_control*24/nonsv.dth;
nonsv.N           = arbj.dth/nonsv.dth;

% It should be a whole number otherwise mod(i,nonsv.N)==0 is not satisfied at all.
assert(floor(nonsv.N)==nonsv.N,'nonsv.N must be a whole number\n');

if(nonsv.initialized == 0)
    % If the function is not run then get initial values from defined
    % values in the .m files.
    nonsv.optResults = cell(SimulSettings.p_loop_len, 1);
    p_loop = 1;
    nonsv.i = 1;
    nonsv.bat.I_cell = zeros(nonsv.Nh, 1);
    nonsv.bat.Pnett  = zeros(nonsv.Nh, 1);
    nonsv.AC.Pnett   = zeros(nonsv.Nh, 1);
    nonsv.AC.P_loss  = zeros(nonsv.Nh, 1);
    nonsv.bat.dT     = zeros(nonsv.Nh, 1);
    nonsv.bat.P_cell = zeros(nonsv.Nh, 1);
    
    nonsv.bat.k_cyc_low_T_high_SOC = zeros(nonsv.Nh, 1);
    nonsv.bat.k_cyc_high_T = zeros(nonsv.Nh, 1);
    nonsv.bat.k_cyc_low_T  = zeros(nonsv.Nh, 1);
    nonsv.bat.k_cal        = zeros(nonsv.Nh, 1);
    nonsv.bat.dSOHcal      = zeros(nonsv.Nh, 1);
    nonsv.bat.dSOHcyc      = zeros(nonsv.Nh, 1);
    
    nonsv.bat.Tk     = zeros(nonsv.Nh+1, 1);
    nonsv.bat.Cbatt  = zeros(nonsv.Nh+1, 1);
    nonsv.bat.C_nom  = zeros(nonsv.Nh+1, 1);
    nonsv.bat.SOH    = zeros(nonsv.Nh+1, 1);
    nonsv.bat.SOC    = zeros(nonsv.Nh+1, 1);
    
    
    nonsv.bat.Tk(1)     = arbj.bat.Tk0;
    nonsv.bat.Cbatt(1)  = arbj.bat.Cbatt0; %arbj.bat.Cbatt0;
    nonsv.bat.C_nom(1)  = arbj.bat.C_nom;
    nonsv.bat.SOH(1)    = arbj.bat.SOH0;
    nonsv.bat.SOC(1)    = nonsv.bat.Cbatt(1)/nonsv.bat.C_nom(1);
    
    nonsv.bat.C_batt_for_optimizer = nonsv.bat.Cbatt(1) - nonsv.bat.C_nom(1)*arbj.bat.SOCmin;
    
    nonsv.initialized = 1;
    
    % For limiting purposes:
    nonsv.limits.is_exceeded = false(nonsv.Nh,1); % True if battery limits exceeded and trimmed.
    %     nonsv.limits.max.C_batt  = zeros(nonsv.Nh,1);
    %     nonsv.limits.max.I_cell  = zeros(nonsv.Nh,1);
    %     nonsv.limits.max.P_cell  = zeros(nonsv.Nh,1);
    
elseif(nonsv.initialized ==1)
    nonsv.j = 1;
    nonsv.sol{p_loop} = sol;
    for i=nonsv.i:(nonsv.i+nonsv.N_control-1)
        
        % Here must be some limiting, otherwise battery SOC surpasses 100%
        
        nonsvLimits;
        
        nonsv.AC.P_loss(i)  = func.nonsv.only_PE_loss(nonsv.AC.Pnett(i));
        nonsv.bat.Pnett(i)  = nonsv.AC.Pnett(i) - nonsv.AC.P_loss(i);
        nonsv.bat.P_cell(i) = func.PkW_to_Pt(nonsv.bat.Pnett(i));
        
        nonsv.bat.I_cell(i) = func.It(nonsv.bat.P_cell(i),...
            nonsv.bat.SOC(i),...
            nonsv.bat.Tk(i));
        
        nonsv.bat.dT(i)     = func.dTcell0_Pt(nonsv.bat.P_cell(i),...
            nonsv.bat.SOC(i),...
            nonsv.bat.Tk(i));
        
        
        
        % Current>0 condition is embedded in these functions.
        nonsv.bat.k_cyc_high_T(i)          = func.k_cyc_high_T(nonsv.bat.I_cell(i),nonsv.bat.Tk(i)) ;
        nonsv.bat.k_cyc_low_T(i)           = func.k_cyc_low_T(nonsv.bat.I_cell(i),nonsv.bat.Tk(i)) ;
        nonsv.bat.k_cyc_low_T_high_SOC(i)  = func.k_cyc_low_T_high_SOC(nonsv.bat.I_cell(i),nonsv.bat.SOC(i),nonsv.bat.Tk(i));
        
        nonsv.bat.k_cal(i)                 = func.k_cal(nonsv.bat.SOC(i),nonsv.bat.Tk(i));
        
        nonsv.bat.dSOHcal(i)               = norm(nonsv.bat.k_cal,2)*sqrt(nonsv.dth);
        nonsv.bat.dSOHcyc(i)               = norm(nonsv.bat.k_cyc_high_T.*sqrt(abs(nonsv.bat.I_cell)))*sqrt(nonsv.dth)+...
            norm(nonsv.bat.k_cyc_low_T.*sqrt(abs(nonsv.bat.I_cell)))*sqrt(nonsv.dth) +...
            norm(nonsv.bat.k_cyc_low_T_high_SOC.*nonsv.bat.I_cell,1)*nonsv.dth;
        
        
        
        nonsv.bat.SOH(i+1) =  nonsv.bat.SOH(1) - nonsv.bat.dSOHcal(i) - nonsv.bat.dSOHcyc(i);
        
        
        
        % Update next terms:
        nonsv.bat.Cbatt(i+1) = nonsv.bat.Cbatt(i) + nonsv.dth*nonsv.bat.I_cell(i);
        nonsv.bat.Tk(i+1)    = nonsv.bat.Tk(i)    + nonsv.dth*3600*nonsv.bat.dT(i);
        
        nonsv.bat.C_nom(i+1) = nonsv.bat.SOH(i+1)* nonsv.bat.C_nom(1);
        
        nonsv.bat.SOC(i+1)   = nonsv.bat.Cbatt(i+1)/nonsv.bat.C_nom(i+1);
        
        if(nonsv.bat.SOC(i+1)>1)
            nonsv.bat.SOC(i+1) = 1;
            nonsv.limits.is_exceeded(i) = true;
        end
        
        
        nonsv.bat.C_batt_for_optimizer = nonsv.bat.Cbatt(i+1) - nonsv.bat.C_nom(i+1)*arbj.bat.SOCmin;
        
        
        if(mod(i,nonsv.N)==0)
            nonsv.j = nonsv.j+1;
        end
        
    end
    nonsv.i = i+1;
elseif(nonsv.initialized==-1)
    % Read from checkpoint:
    temp = load(SimulSettings.path.checkpoints.current, "nonsv");
    nonsv = mergeStructs(nonsv, temp.nonsv, SimulSettings.isCheckpointsActive);
    load(SimulSettings.path.checkpoints.current, "p_loop");
    nonsv.initialized = 1;
else
    error('nonsv.initialized value is unknown.\n');
end






