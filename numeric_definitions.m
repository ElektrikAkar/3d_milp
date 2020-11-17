% Numerical values for optimization problem defined here. 
% Author: VK
% Date  : ? 
arbj.dth             = data.price.dth;    % Time step in hours. 
arbj.Nh              = min(SimulSettings.noDays*24/arbj.dth, length(c_kWh))   ; %Horizon length, 24 pieces for 24 hours. % If Nh is given longer then restrict it to the number of data. 

arbj.Nh_all          = min(SimulSettings.noDays_all*24/arbj.dth, length(c_kWh));
arbj.Nh_control      = min(SimulSettings.noDays_control*24/arbj.dth, length(c_kWh));

bat_max_eff          = data.efficiency.eta_out(end); %max(eta_in(end), eta_out(end)); %determine max efficiency of charge or discharge 
%arbj.P_AC_max        = max(abs(P_AC_out_kW)); % maximum power in kW.
%arbj.P_bat_max       = (1/bat_max_eff)*arbj.P_AC_max; % maximum power of the battery

arbj.bat.SOCmax      = 0.95;
arbj.bat.SOCmin      = 0.05;
arbj.bat.SOC0        = arbj.bat.SOCmin; %10 percent initial SOC. 
arbj.bat.C_rate_ch   = SimulSettings.C_rate_ch; %max. C-rate for charge.
arbj.bat.C_rate_dsch = SimulSettings.C_rate_disch; %max. C-rate for discharge. 


arbj.bat.Tk_min      = KELVIN+18; % minimum temperature in Kelvin for bounds. 
arbj.bat.Tk_max      = KELVIN+55; % max temperature for bounds. 
arbj.bat.Tk_const    = SimulSettings.const.Tk; 
arbj.bat.SOC_const   = SimulSettings.const.SOC; 


arbj.bat.Umax        = 3.6; %V  Maximum voltage of a cell
arbj.bat.Umin        = 2;   %V  Minimum terminal voltage of a cell.


arbj.bat.Enom        = 24*8;  % kWh E_nominal
%arbj.bat.Ebatt0      = 0; % 0 kWh usable energy is stored in battery. From Holger's paper on diminishing SOC boundaries. 
arbj.bat.SOH0        = 1;

arbj.bat.C_nom       = param.cell.Cnom; % [Ah] nominal energy.
arbj.bat.Cbatt0      = arbj.bat.SOCmin*arbj.bat.C_nom; % 0 Ah usable energy is stored in battery. From Holger's paper on diminishing SOC boundaries.  

arbj.bat.Cost_kWh    = 250; %500; %500 EUR/kWh cost is for battery. 
arbj.bat.EOL         = 0.8; %End of life considered to be 0.8 SOH. 
%We need to find cost per aging value. Which is calculated via:
%[EUR]/[per unit aging] =  Enom* Cost_kWh/(initial SOH - SOH_at_EOL); 

arbj.bat.Cost_whole = arbj.bat.Enom*arbj.bat.Cost_kWh;

arbj.bat.Cost_pu      = arbj.bat.Cost_whole/(arbj.bat.SOH0-arbj.bat.EOL); %Cost per aging


arbj.waiting.th       = 0; %30 days.
arbj.waiting.SOC      = arbj.bat.SOCmin; % waiting at 10 percent SOC. 
arbj.waiting.Tk       = KELVIN+25;       % Waiting at 25 degrees celcius. 
arbj.waiting.dSOHcal0 = sqrt(arbj.waiting.th)*func.k_cal(arbj.waiting.SOC,arbj.waiting.Tk);

arbj.waiting.dSOH0    = arbj.waiting.dSOHcal0; % Maybe add some cycle degradation in future? 

arbj.bat.SOH0         = arbj.bat.SOH0 - arbj.waiting.dSOH0;
 


arbj.bat.Tk0 = KELVIN+25; % 18 Celcius temperature 0.
is_defined.DiminishingBoundaries = SimulSettings.DiminishingBoundaries;

numeric_definitions_agingApprox;



