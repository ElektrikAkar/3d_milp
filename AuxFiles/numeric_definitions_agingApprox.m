% We know that it is for half-cycle and C-rate * dth == 1. So we still need
% to multiply by C-rate * dth to get real aging. Here I assume that the dth
% is constant and taken outside. So we will calculate aging per dth. Do not
% forget to multiply by dth in the aging equations. 
%
% Author: VK
% Date  : ? 

aging.P_bat_in_kW   = aging.P_AC_in_kW  -  func.eff.P_AC_in_kW(aging.P_AC_in_kW);
aging.P_bat_out_kW  = aging.P_AC_out_kW +  func.eff.P_AC_out_kW(aging.P_AC_out_kW);

aging.C_AC_in       =  aging.P_bat_in_kW/arbj.bat.Enom;
aging.C_AC_out      =  aging.P_bat_out_kW/arbj.bat.Enom;

aging.realLoss_in   = aging.C_AC_in.*aging.cap_loss_ch;


aging.CalAging.nominal_aging = func.k_cal(0.5,KELVIN+30);

aging.CalAging.nominal_time  = ((1-arbj.bat.EOL)/aging.CalAging.nominal_aging)^2; % 20 years of hours. 

aging.CalAging.nominal_time_multiplier = arbj.dth*sqrt(aging.CalAging.nominal_time)/aging.CalAging.nominal_time;



