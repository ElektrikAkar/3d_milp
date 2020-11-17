% This file loads battery container parameters: 
% Author: VK
% Date  : ? 
% Source: Schimpe, M., Naumann, M., Truong, N., Hesse, H.C., Santhanagopalan, S., Saxon, A. and Jossen, A., 2018. 
% Energy efficiency evaluation of a stationary lithium-ion battery container storage system via electro-thermal modeling and detailed component analysis. 
% Applied energy, 210, pp.211-229.


% Cell param: 
param.cell.Cnom = 3; %[Ah]

param.n_cell_per_block      = 12; 
param.n_block_per_module    = 16;
param.n_module_per_rack     = 13;
param.n_rack                = 8;

param.n_cell = param.n_cell_per_block*param.n_block_per_module*param.n_module_per_rack*param.n_rack; %1.5; % remove 1.5 it is for calibration 36kW -24kW  
%warning('*param.n_rack is not added now!');

param.kW_to_cellW = 1000/param.n_cell; %From system level kW to cell level W;


param.T_ambient_0 = KELVIN + 18; % 18 C degrees constant ambient temp. 

param.m_cell     = 85e-3;  % (kg) mass of a cell. 
param.c_p_cell   = 838;    % (J/(kg K)) specific heat capacity of cell. 
param.A_cell     = 0.0064; % m^2 I think? From SimSES.


param.m_cu       = 0.02; % [kg] mass of copper connector. % May also be 0.3, not sure difference. 
param.c_p_cu     = 385;  % Copper specific heat (J/(kg K)  at 25C 

param.C_th_cell  = param.m_cell*param.c_p_cell; % (J/K) Cell heat capacity. 
param.C_th_block = param.n_cell_per_block*param.C_th_cell + param.m_cu*param.c_p_cu;   % Block heat capacity (J/K). 

param.rho_air    = 1.225; % (kg/m^3) 
param.c_p_air    = 1005;  % (J/(kg K)) %be careful ?f this is 1.005 then kJ 

% http://www2.ucdsb.on.ca/tiss/stretton/database/Specific_Heat_Capacity_Table.html
% https://webbook.nist.gov/cgi/cbook.cgi?ID=C7440508&Type=JANAFS&Table=on#JANAFS

param.R_contact_block = 0.1e-3; %0.1 m Ohm contact resistance.

% Container parameters! 

param.cont.width  = 2.44; % container width [m]
param.cont.height = 2.90; % container height [m]
param.cont.length = 6.06 - 0.5; % container length (minus PE section) [m]

param.cont.volume = param.cont.width*param.cont.height*param.cont.length; %[m^3]; %container volume. 

param.cont.airVolpercent  = 0.75;  % 75% of the volume is air. 

param.cont.airVolume  = param.cont.volume*param.cont.airVolpercent; %[m^3] volume of air.


param.cont.area.wall  = param.cont.height*2*(param.cont.width+param.cont.length); % wall area [m^2]
param.cont.area.roof  = param.cont.width*param.cont.length; % roof area [m^2]
param.cont.area.floor = param.cont.area.roof; % floor area [m^2] (probably same as roof?) 

% material resistance + inside air + outside air.
param.cont.heat.wall  = 3.23 + 0.13 + 0.04; % [K * m^2 /W] thermal resistance for wall. 
param.cont.heat.roof  = 3.23 + 0.10 + 0.04; % [K * m^2 /W] thermal resistance for roof.
param.cont.heat.floor = 2.22 + 0.17 + 0.04; % [K * m^2 /W] thermal resistance for floor.


% Thermal resistances: 

% U is like  Q_dot = U*deltaT; So  U is A/R  
param.U_th.AmbOutd_Sys = param.cont.area.wall/param.cont.heat.wall + ... 
                         param.cont.area.roof/param.cont.heat.roof + ... 
                         param.cont.area.floor/param.cont.heat.floor; %[W/K]
                     
                     
% SCHIMPE THERMAL PARAMS, cite his paper. 
param.cell.alpha.chamber = 5; % Single cell in climate chamber: W/(m^2 K) DON'T USE
param.cell.alpha.fan_25  = 2; % Cell installed in Battery module in battery rack, actively air-cooled (Fan @ 25%)
param.cell.alpha.fan_100 = 3; % Cell installed in Battery module in battery rack, actively air-cooled (Fan @ 100%)
                     
% Air flow param: 

% Power electronic section fan 101W of nominal power.
param.fan.PE.V_dot_nom = 370/3600; % 370 [m^3/h], nominal air flow 
% https://datasheet.octopart.com/RG160-28-14NTDH-EBM-Papst-datasheet-22126019.pdf

%using ratio interp1([20, 64, 101],[209 308 370],82)  = 338. 

param.fan.rack.V_dot_nom = 338/3600;
param.fan.rack.P_nom     = 82; % [W] nominal power of rack fan.

