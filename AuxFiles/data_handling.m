% This file loads various data. 
% Author: VK
% Date  : ? 
% Update: 2020.05.05


data.price = get_priceData(SimulSettings.dataName);

data.efficiency.filename = "efficiency_data_" + SimulSettings.effName + ".csv";
data.efficiency.path     = fullfile(SimulSettings.path.data.CSV, data.efficiency.filename);
data.efficiency.values   = csvread(data.efficiency.path, 1);

data.aging.filename = "aging_data_cyc.csv";
data.aging.path     = fullfile(SimulSettings.path.data.CSV, data.aging.filename);

data.aging.values = csvread(data.aging.path,1);
aging.P_AC_in_kW  = abs(data.aging.values(:,1))/1e3;
aging.P_AC_out_kW = abs(data.aging.values(:,5))/1e3;

aging.cap_loss_ch   =  abs(data.aging.values(:,3));
aging.cap_loss_dsch =  abs(data.aging.values(1,7)); %is a constant value. for C-rate * dth
% Approximation logic of aging given in "numeric_definitions.m" file. 

% Efficiency
data.efficiency.P_AC_in     = data.efficiency.values(:,1);
data.efficiency.P_Batt_in   = data.efficiency.values(:,2);
data.efficiency.P_loss_in   = data.efficiency.values(:,3);
data.efficiency.eta_in      = (data.efficiency.P_AC_in + data.efficiency.P_loss_in)./min(-1e-15, data.efficiency.P_AC_in);   % Efficiency

data.efficiency.P_AC_out    = data.efficiency.values(:,5);
data.efficiency.P_Batt_out  = data.efficiency.values(:,6);
data.efficiency.P_loss_out  = data.efficiency.values(:,7);
data.efficiency.eta_out     = (data.efficiency.P_AC_out - data.efficiency.P_loss_out)./max(data.efficiency.P_AC_out, 1e-15); % Efficiency

%----------------
%kW transformation for numerical stability: 

data.efficiency.P_AC_in_kW     = -data.efficiency.P_AC_in/1e3;
data.efficiency.P_Batt_in_kW   =  data.efficiency.P_Batt_in/1e3;
data.efficiency.P_loss_in_kW   = data.efficiency.P_loss_in/1e3;

%After 9th sample it becomes quadratic so: 

% weight_AC_in_last = ones(size(P_AC_in_kW));
% weight_AC_in_last(1:8) = 0;
% weight_AC_in_first = double(not(weight_AC_in_last));

data.efficiency.P_AC_out_kW    = data.efficiency.P_AC_out/1e3;
data.efficiency.P_Batt_out_kW  = data.efficiency.P_Batt_out/1e3;
data.efficiency.P_loss_out_kW  = data.efficiency.P_loss_out/1e3;

%Here we treat first 50 and others differently. 
% weight_AC_out_last = ones(size(P_AC_out_kW));
% weight_AC_out_last(1:49) = 0; 
% weight_AC_out_first = double(not(weight_AC_out_last));


%interp1 functions.

% Price
c_kWh = [data.price.values; data.price.values(1:200)]; % make it double, otherwise it does not work.

c_kWh_NaN = find(isnan(c_kWh)); 

c_kWh(c_kWh_NaN) = c_kWh(c_kWh_NaN - 24/data.price.dth);  % Replace NaN values with one day before. 

%warning('c_kWh is changed to accomodate negative prices. ');

%---------------------------------

load_data;

