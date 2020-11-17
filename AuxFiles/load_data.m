% This file loads various data. 
% Author: VK
% Date  : ? 

data.temperature.filename = "Battery_Parameter_Sony_LFPC_OCV_R_Entr_SelfDisch_RLinExtrap_BlockSegment_SimCell_ExpCell.mat";
data.temperature.path     = fullfile(SimulSettings.path.data.main, data.temperature.filename);
data.temperature.values   = load(data.temperature.path);

data.SOC   = 0:0.01:1;
data.T     = KELVIN + (0:1:100);
data.dS    = data.temperature.values.Battery_Parameter.Cell.S;

data.U_OCV.SOC = 0:0.005:1;
data.U_OCV.V   = data.temperature.values.Battery_Parameter.Cell.U_OCV;

data.U_hys = data.temperature.values.Battery_Parameter.Cell.U_Hysteresis;

data.SelfDisch.T  = KELVIN +  (0:10:100);
data.SelfDisch.pu = data.temperature.values.Battery_Parameter.Cell.SelfDisch*3600; % This is per hour since multipled by 3600! 

data.Ri_Ch        = data.temperature.values.Battery_Parameter.Cell.Rtot_Ch(:,1:101);     % inputs are (SOC,temp);
data.Ri_Disch     = data.temperature.values.Battery_Parameter.Cell.Rtot_Disch(:,1:101);  % inputs are (SOC,temp);

data.aging_cyc.filename = "aging_data_cyc_for_battery.csv";
data.aging_cyc.path     = fullfile(SimulSettings.path.data.CSV, data.aging_cyc.filename);


if(SimulSettings.isMatlabNew)
    temp = readmatrix(data.aging_cyc.path);
else
    temp = csvread(data.aging_cyc.path,1);
end

data.aging_per_dth = temp(8:end,[2,4]);

data.eff_data_only_PE.filename = "efficiency_data_only_PE_2.csv";
data.eff_data_only_PE.path     = fullfile(SimulSettings.path.data.CSV, data.eff_data_only_PE.filename);

if(SimulSettings.isMatlabNew)
    temp = readmatrix(data.eff_data_only_PE.path);
else
    temp = csvread(data.eff_data_only_PE.path,1);
end

data.only_PE_loss_new       = temp(1:end,[1:2,4:5]); %Input positive, output negative! 

data.only_PE_loss.P_AC_kW   = 8*[data.only_PE_loss_new(end:-1:1,1);data.only_PE_loss_new(2:end,3)]/1e3;
data.only_PE_loss.P_loss_kW = 8*[data.only_PE_loss_new(end:-1:1,2);data.only_PE_loss_new(2:end,4)]/1e3;