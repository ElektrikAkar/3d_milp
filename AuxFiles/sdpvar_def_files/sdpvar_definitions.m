% This is where we define optimiziation problem using YALMIP.
% It can be downloaded via: https://www.mpt3.org/Main/Installation?action=download&upname=install_mpt3.m
%
% Author: VK
% Date  : ?

fprintf('SDPVAR definition is started.\n'); tic;
%Definitons.
%is_defined.CalAging = true;

sdpvar_definitions_settings;
sdpvar_initial_values;

sdpv.const = []; % Constraints.
sdpv.J     = 0;  % Total cost.

%All power values are in kW for numerical reasons.
%sdpv.bat.Pcharge      = sdpvar(arbj.Nh, 1);  %Charging    power of battery.
%sdpv.bat.Pdischarge   = sdpvar(arbj.Nh, 1);  %Discharging power of battery.
sdpv.bat.Pnett         = sdpvar(arbj.Nh, 1); %sdpv.bat.Pcharge - sdpv.bat.Pdischarge; % Net power going to the battery. So charging power is (+)
%sdpv.bat.Pgross       = sdpv.bat.Pcharge + sdpv.bat.Pdischarge; % Gross power (or absolute power going to the battery, we will need for C-rate)




sdpv.bat.Tk           = sdpvar(arbj.Nh+1, 1); % Temperature in Kelvin!
sdpv.bat.Tk_avg       = sdpvar(arbj.Nh, 1);   % Average Temperature in Kelvin!

%---------------------------

sdpv.AC.Pcharge       = sdpvar(arbj.Nh, 1);
sdpv.AC.Pdischarge    = sdpvar(arbj.Nh, 1);
sdpv.AC.Pnett         = sdpv.AC.Pcharge - sdpv.AC.Pdischarge;
sdpv.AC.P_loss        = sdpvar(arbj.Nh, 1);




%Holger new SOC with diminishing boundaries definition!
%sdpv.bat.Ebatt       = sdpvar(arbj.Nh+1, 1);   % Energy inside battery.
sdpv.bat.Cbatt        = sdpvar(arbj.Nh+1, 1);   % Energy inside battery in C terms.

sdpv.bat.SOC          = arbj.bat.SOCmin + sdpv.bat.Cbatt/arbj.bat.C_nom;
sdpv.bat.SOCavg       = (sdpv.bat.SOC(1:(arbj.Nh),1) +sdpv.bat.SOC(2:(arbj.Nh+1),1))/2;


%sdpvar_definitions_approx_common3;  % Definition of common variables for different approximations.  3 is working.
sdpvar_definitions_approx_common6_2019_11_24; % New definition with Union Jack. Generally, best.

sdpvar_definitions_lossApproximation_tempNEW;
%sdpvar_definitions_lossApproximation_tempNEW_unified; %-> Generally worse


sdpvar_definitions_I_Approx;            % I approximation.



sdpvar_definitions_deltaT_Approx;       % Temperature gradient approximation.
sdpvar_definitions_deltaQ_Approx;       % dQcell approximation.


%----- New definitions for the thermal paper.

%param.kW_to_cell
sdpv.const = [sdpv.const, ...
    sdpv.bat.Pcell_approx==(param.kW_to_cellW*sdpv.bat.Pnett)]; %(:,ijk)


%--------------------------------------------------------------------------
sdpvar_definitions_aging_CostBased;

%warning('Problem in aging function!');

if(is_defined.DiminishingBoundaries)
    %sdpv.bat.Eusable      = sdpv.bat.SOH*(arbj.bat.SOCmax - arbj.bat.SOCmin)*arbj.bat.Enom;
    sdpv.bat.Cusable      = sdpv.bat.SOH*(arbj.bat.SOCmax - arbj.bat.SOCmin)*arbj.bat.C_nom;  % do not use this one for a while.
else
    %sdpv.bat.Eusable      = (arbj.bat.SOCmax - arbj.bat.SOCmin)*arbj.bat.Enom;
    sdpv.bat.Cusable      = (arbj.bat.SOCmax - arbj.bat.SOCmin)*init.bat.C_nom;
end


sdpv.const = [sdpv.const, ...
    sdpv.bat.Pnett == (sdpv.AC.Pnett - sdpv.AC.P_loss)];


sdpv.const = [sdpv.const, ...
    sdpv.bat.Pnett <= sdpv.AC.Pnett];  % Additional constraint which increases speed for some reason. 

% Temperature update:

if(SimulSettings.tempMode=="dynamic")
    
    sdpv.const = [sdpv.const, ...
        sdpv.bat.Tk(2:(arbj.Nh+1)) == (sdpv.bat.Tk(1:arbj.Nh)+sdpv.bat.thermal_approx.dT*arbj.dth*3600) ];
    
    sdpv.const = [sdpv.const, ...
        sdpv.bat.Tk(1) == init.bat.Tk0];
    
    sdpv.const = [sdpv.const, ...
        (sdpv.bat.Tk_avg == 0.5*(sdpv.bat.Tk(1:arbj.Nh) + sdpv.bat.Tk(2:(arbj.Nh+1)))  )];
    
    sdpv.const = [sdpv.const, ...
        arbj.bat.Tk_min <= sdpv.bat.Tk(2:(arbj.Nh+1)) <= arbj.bat.Tk_max  ];
    
    
else
    
    sdpv.const = [sdpv.const, ...
        sdpv.bat.Tk(1:(arbj.Nh+1)) == arbj.bat.Tk_const ];
    
    sdpv.const = [sdpv.const, ...
        (sdpv.bat.Tk_avg == arbj.bat.Tk_const )];
    
end

% SOC Constraints:

%---Holger new SOC with diminishing boundaries definition!-------------
% sdpv.const = [sdpv.const, ...
%      	 sdpv.bat.Ebatt(1) == arbj.bat.Ebatt0];  %initial energy stored in bat.
% %Update Equation.
% sdpv.const = [sdpv.const, ...
%      	 sdpv.bat.Ebatt(2:(arbj.Nh+1)) == (sdpv.bat.Ebatt(1:arbj.Nh) + arbj.dth*sdpv.bat.Pnett)];
%
% sdpv.const = [sdpv.const, ...
% 	 0 <= 2*sdpv.bat.Ebatt(2:(arbj.Nh+1))<= 2*sdpv.bat.Eusable];  %two for numerical stability!

%-- For C version:
sdpv.const = [sdpv.const, ...
    sdpv.bat.Cbatt(1) == init.bat.Cbatt0];  %initial energy stored in bat.
%Update Equation.
sdpv.const = [sdpv.const, ...
    sdpv.bat.Cbatt(2:(arbj.Nh+1)) == (sdpv.bat.Cbatt(1:arbj.Nh) + arbj.dth*sdpv.bat.I_cell)];


sdpv.const = [sdpv.const, ...
    0 <= 2*sdpv.bat.Cbatt(2:(arbj.Nh+1))<= 2*sdpv.bat.Cusable];  %two for numerical stability!


%---------------------------------------------
% the Cost
%---------------------------------------------
sdpv.Jstep.AC_power  = ( (init.c_kWh).*sdpv.AC.Pnett)*arbj.dth;
sdpv.Jstep.Aging     = sdpv.bat.aging_approx.COSTall*arbj.dth;


%arbj.bat.Cost_pu*(sdpv.bat.totaldeltaSOH_cal+sdpv.bat.totaldeltaSOH_cyc - arbj.waiting.dSOH0);
sdpv.Jstep.all       = sdpv.Jstep.AC_power + sdpv.Jstep.Aging;
sdpv.J = sdpv.J + sum(sdpv.Jstep.all);

%--------------------------

if(SimulSettings.OptMode == "Optimizer")
    sdpvar_definitions_optimizer;
end

clear temp;
fprintf('SDPVAR definition is ended.\n'); toc

