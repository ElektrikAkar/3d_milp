% Checks current, voltage, power, SOC, temperature etc. limits
% This is not a function not to copy a large struct.
% Author: VK
% Date  : 2020.07.04

%#ok<*IJCL> -> To suppress some suggestions. 

%% Max Limits:

nonsv.limits.max.C_batt = nonsv.bat.C_nom(i) - nonsv.bat.Cbatt(i);  % SOC

% Voltage limits to be added here. and below. 
nonsv.limits.max.I_cell = min(nonsv.limits.max.C_batt/nonsv.dth, nonsv.bat.C_nom(i)*2);
nonsv.limits.max.P_cell = func.It_to_Pt(nonsv.limits.max.I_cell,...
    nonsv.bat.SOC(i),...
    nonsv.bat.Tk(i));


nonsv.limits.max.P_batt = func.Pt_to_PkW(nonsv.limits.max.P_cell);

if( nonsv.limits.max.P_batt >=(data.segm.P_AC_kW(end) - func.nonsv.only_PE_loss(data.segm.P_AC_kW(end))  ))
    nonsv.limits.max.P_AC = data.segm.P_AC_kW(end);
else
    nonsv.limits.max.P_AC = func_bat_to_PE(nonsv.limits.max.P_batt, func.nonsv.only_PE_loss,data.segm.P_AC_kW);
end




%% Minimum limits:

nonsv.limits.min.C_batt = 0 - nonsv.bat.Cbatt(i); % Remanining
nonsv.limits.min.I_cell = max(nonsv.limits.min.C_batt/nonsv.dth,-nonsv.bat.C_nom(i)*2);
nonsv.limits.min.P_cell = func.It_to_Pt(nonsv.limits.min.I_cell,...
    nonsv.bat.SOC(i),...
    nonsv.bat.Tk(i));


nonsv.limits.min.P_batt = func.Pt_to_PkW(nonsv.limits.min.P_cell);

if( nonsv.limits.min.P_batt <= (data.segm.P_AC_kW(1) - func.nonsv.only_PE_loss(data.segm.P_AC_kW(1))))
    nonsv.limits.min.P_AC = data.segm.P_AC_kW(1);
else
    nonsv.limits.min.P_AC = func_bat_to_PE(nonsv.limits.min.P_batt, func.nonsv.only_PE_loss,data.segm.P_AC_kW);
end


nonsv.AC.Pnett(i)   = sol.sdpv.AC.Pnett(nonsv.j);

if(nonsv.AC.Pnett(i)> nonsv.limits.max.P_AC)
    
    nonsv.AC.Pnett(i) = nonsv.limits.max.P_AC;
    nonsv.limits.is_exceeded(i) = true;
    
elseif(nonsv.AC.Pnett(i)< nonsv.limits.min.P_AC)
    nonsv.AC.Pnett(i) = nonsv.limits.min.P_AC;
    nonsv.limits.is_exceeded(i) = true;
    
end

%% Temperature limit

if(nonsv.bat.Tk(i)>(60+KELVIN)) 
    nonsv.AC.Pnett(i) = 0;
    nonsv.limits.is_exceeded(i) = true;
end
