% This is plot file for 
% Author: VK
% Date  : 2020.04.19

% text width 7.2 in
clear all;  close all; clc;

% #Headers
KELVIN = 273.15;

SimulSettings = simulationSettings; % For path generation. 

results.case1 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_30_dynamic_dynamic_combined_2C_365_days.mat"));
results.case2 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_30_notOptimized_dynamic_combined_2C_365_days.mat"));

results.case3 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_30_dynamic_dynamic_bat_loss_2C_365_days"));
results.case4 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_30_notOptimized_dynamic_bat_loss_2C_365_days.mat"));
            
results.case5 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_30_notOptimized_notOptimized_combined_2C_365_days.mat"));
results.case6 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_30_notOptimized_notOptimized_bat_loss_2C_365_days.mat"));

% results.case42 = load(fullfile(SimulSettings.path.results.main, ...
%                 "act2020_04_21_notOptimized_bat_loss_2C_30_days.mat")); 


plt_folder = "figures_2020_08_04";

plt_save = 2; %0-> no plot, 1-> .eps/png only, 2-> both .eps/png and .fig

%% SOH comparison
% close all; clc;
% 
% plt_name = "SOH_comparison_w_PE";
% plt_SOH_comparison(results.case1, results.case2, fullfile(plt_folder, plt_name), plt_save);
% 
% plt_name = "SOH_comparison_wo_PE";
% plt_SOH_comparison(results.case3, results.case4, fullfile(plt_folder, plt_name), plt_save);

%%
FEC = [0; 0.5*cumsum(abs(diff(results.case2.nonsv.bat.SOC)))];
time = (0:length(FEC)-1)*results.case2.nonsv.dth/24/365;

dSOHcal = [0; results.case2.nonsv.bat.dSOHcal];
dSOHcyc = [0; results.case2.nonsv.bat.dSOHcyc];

SOH  = results.case2.nonsv.bat.SOH;

figure;
plot(time*12, FEC); xlabel('time /months'); ylabel('FEC'); grid on;


%% SOH comparison all
%close all; clc;

plt_additional.SOH_fitting = "one";  % "one" -> at+100,  "two" -> "at+b", "sep" -> seperated fit for SOHcal and SOHcyc
mycase = []
case_order = [1 2 5 3 4 6]; 

for i=1:6
    mycase.case(i) = "case"+num2str(i);
    j=1;
    
    ext = func_SOH_extrapolate(results.(mycase.case(i)), "one");
    mycase.t_EOL(i,j)  = ext.t_EOL_y; 
    mycase.conf(i,j)   = ext.SOH_gof.adjrsquare*100; 
    j = j+1;
    
    ext = func_SOH_extrapolate(results.(mycase.case(i)), "two");
    mycase.t_EOL(i,j)  = ext.t_EOL_y; 
    mycase.conf(i,j)   = ext.SOH_gof.adjrsquare*100;     
    j = j+1;
    
    ext = func_SOH_extrapolate(results.(mycase.case(i)), "sep1");
    mycase.t_EOL(i,j)      = ext.t_EOL_y; 
    mycase.conf(i,j)   = ext.dSOHcal_gof.adjrsquare*100; 
    mycase.conf(i,j+1)   = ext.dSOHcyc_gof.adjrsquare*100; 
    j = j+1;
    
    ext = func_SOH_extrapolate(results.(mycase.case(i)), "sep2");
    mycase.t_EOL(i,j)  = ext.t_EOL_y; 
    mycase.conf(i,j+1)   = ext.dSOHcal_gof.adjrsquare*100; 
    mycase.conf(i,j+2)   = ext.dSOHcyc_gof.adjrsquare*100;   
    
end




%%
mycase.t_EOL(case_order,:)
mycase.conf(case_order,:)


%% Weekly Price plot: 
close all;

%length(results.case1.c_kWh)/365/24
plt_name = "time_series_a_week";
plt_time_series_oneweek2(results.case1, results.case2, results.case5, fullfile(plt_folder, plt_name), plt_save, plt_additional);



%%
% ext = func_SOH_extrapolate(results.case2, "sep1");
% disp(ext.t_EOL_y)
%%
plt_additional.SOH_fitting = "one"; 
plt_name = "SOH_comparison_w_PE3_1y_one";
plt_SOH_comparison3_1y(results.case1, results.case2, results.case5, fullfile(plt_folder, plt_name), plt_save, plt_additional);

plt_name = "SOH_comparison_wo_PE3_1y_one";
plt_SOH_comparison3_1y(results.case3, results.case4, results.case6, fullfile(plt_folder, plt_name), plt_save, plt_additional);




%% Profitability index.
plt_name = "";
plt_additional.rolling_PI = false; 
plt_additional.PI_resolution = 12; % 12/1 12 times of the year.
plt_additional.SOH_fitting = "one"; 
plt_calc_PI(results.case1, fullfile(plt_folder, plt_name), plt_save, plt_additional).PI
plt_calc_PI(results.case2, fullfile(plt_folder, plt_name), plt_save, plt_additional).PI
plt_calc_PI(results.case5, fullfile(plt_folder, plt_name), plt_save, plt_additional).PI


plt_calc_PI(results.case3, fullfile(plt_folder, plt_name), plt_save, plt_additional).PI
plt_calc_PI(results.case4, fullfile(plt_folder, plt_name), plt_save, plt_additional).PI
plt_calc_PI(results.case6, fullfile(plt_folder, plt_name), plt_save, plt_additional).PI

%% P_AC ECDF PLOT 

% close all; clc;
% 
% plt_name = "P_AC_comparison_w_PE_1y";
% plt_PAC_ecdf(results.case1, results.case2, fullfile(plt_folder, plt_name), plt_save);
% 
% plt_name = "P_AC_comparison_wo_PE_1y";
% plt_PAC_ecdf(results.case3, results.case4, fullfile(plt_folder, plt_name), plt_save);


%% %% P_AC ECDF PLOT all
close all; clc;

plt_name = "P_AC_comparison_w_PE3_1y";
plt_PAC_ecdf3(results.case1, results.case2, results.case5, fullfile(plt_folder, plt_name), plt_save);

plt_name = "P_AC_comparison_wo_PE3_1y";
plt_PAC_ecdf3(results.case3, results.case4, results.case6, fullfile(plt_folder, plt_name), plt_save);


%% Plot temperature distribution: 
close all; clc;

% plt_additional.color_temp_dist = 0 -> red color
% plt_additional.color_temp_dist = 1 -> green color


plt_name = "temp_prob_DY_w_PE_1y";  plt_additional.color_temp_dist = 1;
plt_temp_dist(results.case1, fullfile(plt_folder, plt_name), plt_save, plt_additional)

plt_name = "temp_prob_NO_w_PE_1y";  plt_additional.color_temp_dist = 3;
plt_temp_dist(results.case2, fullfile(plt_folder, plt_name), plt_save, plt_additional)

plt_name = "temp_prob_NO_w_PE_noSOC_1y"; plt_additional.color_temp_dist = 0;
plt_temp_dist(results.case5, fullfile(plt_folder, plt_name), plt_save, plt_additional)
%%
plt_name = "temp_prob_DY_wo_PE_1y"; plt_additional.color_temp_dist = 1;
plt_temp_dist(results.case3, fullfile(plt_folder, plt_name), plt_save, plt_additional)

plt_name = "temp_prob_NO_wo_PE_1y"; plt_additional.color_temp_dist = 3;
plt_temp_dist(results.case4, fullfile(plt_folder, plt_name), plt_save, plt_additional)

plt_name = "temp_prob_NO_wo_PE_noSOC_1y"; plt_additional.color_temp_dist = 0;
plt_temp_dist(results.case6, fullfile(plt_folder, plt_name), plt_save, plt_additional)



 %% Plot SOC distribution 

% close all; clc;
% 
% % plt_additional.color_SOC_dist = 0 -> red color
% % plt_additional.color_SOC_dist = 1 -> green color
% 
% plt_name = "SOC_prob_DY_w_PE_1y";  plt_additional.color_SOC_dist = 1;
% plt_SOC_dist(results.case1, fullfile(plt_folder, plt_name), plt_save, plt_additional)
% 
% plt_name = "SOC_prob_NO_w_PE_1y";  plt_additional.color_SOC_dist = 0;
% plt_SOC_dist(results.case2, fullfile(plt_folder, plt_name), plt_save, plt_additional)
% 
% plt_name = "SOC_prob_DY_wo_PE_1y"; plt_additional.color_SOC_dist = 1;
% plt_SOC_dist(results.case3, fullfile(plt_folder, plt_name), plt_save, plt_additional)
% 
% plt_name = "SOC_prob_NO_wo_PE_1y"; plt_additional.color_SOC_dist = 0;
% plt_SOC_dist(results.case4, fullfile(plt_folder, plt_name), plt_save, plt_additional)


%% Plot SOC distribution with Histogram. 
close all;

% plt_additional.color_SOC_dist = 0 -> red color
% plt_additional.color_SOC_dist = 1 -> green color

plt_name = "SOC_probhist_DY_w_PE_1y";  plt_additional.color_SOC_dist = 1;
plt_SOC_dist_hist(results.case1, fullfile(plt_folder, plt_name), plt_save, plt_additional)

plt_name = "SOC_probhist_NO_w_PE_1y";  plt_additional.color_SOC_dist = 3;
plt_SOC_dist_hist(results.case2, fullfile(plt_folder, plt_name), plt_save, plt_additional)

plt_name = "SOC_probhist_NO_w_PE_noSOC_1y"; plt_additional.color_SOC_dist = 0;
plt_SOC_dist_hist(results.case5, fullfile(plt_folder, plt_name), plt_save, plt_additional)
%%
plt_name = "SOC_probhist_DY_wo_PE_1y"; plt_additional.color_SOC_dist = 1;
plt_SOC_dist_hist(results.case3, fullfile(plt_folder, plt_name), plt_save, plt_additional)

plt_name = "SOC_probhist_NO_wo_PE_1y"; plt_additional.color_SOC_dist = 3;
plt_SOC_dist_hist(results.case4, fullfile(plt_folder, plt_name), plt_save, plt_additional)

plt_name = "SOC_probhist_NO_wo_PE_noSOC_1y"; plt_additional.color_SOC_dist = 0;
plt_SOC_dist_hist(results.case6, fullfile(plt_folder, plt_name), plt_save, plt_additional)

%% %% SOC ECDF PLOT all
close all; clc;

plt_name = "SOC_comparison_w_PE3_1y";
plt_SOC_ecdf3(results.case1, results.case2, results.case5, fullfile(plt_folder, plt_name), plt_save);

plt_name = "SOC_comparison_wo_PE3_1y";
plt_SOC_ecdf3(results.case3, results.case4, results.case6, fullfile(plt_folder, plt_name), plt_save);


%% Plot price distribution. 
close all;
plt_name = "price_box_plot_1y";
plt_price_box(results.case3.c_kWh, fullfile(plt_folder, plt_name), plt_save);

%% P_AC_vs_P_loss
close all;

plt_additional.gray_code_ON = true;

plt_name = "P_AC_vs_P_loss_small_1y_gray";
plt_P_AC_vs_P_loss(results.case1, fullfile(plt_folder, plt_name), plt_save, plt_additional);




%% Plot t_EOL
close all;
data_handling;
load_param;
load_param_calender;

def_functions;
%%
close all;
plt_name = "t_EOL_plot2_1y_limited";
plt_t_EOL(func, fullfile(plt_folder, plt_name), plt_save);


%% Plot time series
close all;
plt_name = "temp_time_series_DY_w_PE_1y"; 
plt_time_series(results.case1, fullfile(plt_folder, plt_name), plt_save)

plt_name = "temp_time_series_NO_w_PE_1y"; 
plt_time_series(results.case2, fullfile(plt_folder, plt_name), plt_save)

plt_name = "temp_time_series_NO_w_PE_noSOC_1y"; 
plt_time_series(results.case5, fullfile(plt_folder, plt_name), plt_save)

plt_name = "temp_time_series_DY_wo_PE_1y"; 
plt_time_series(results.case3, fullfile(plt_folder, plt_name), plt_save)

plt_name = "temp_time_series_NO_wo_PE_1y"; 
plt_time_series(results.case4, fullfile(plt_folder, plt_name), plt_save)

plt_name = "temp_time_series_NO_wo_PE_noSOC_1y"; 
plt_time_series(results.case6, fullfile(plt_folder, plt_name), plt_save)

%% 

close all;

plt_name = "temperature_series_DY_w_PE_1y"; 
plt_temp_time_series(results.case1, fullfile(plt_folder, plt_name), plt_save)

plt_name = "temperature_series_NO_w_PE_1y"; 
plt_temp_time_series(results.case2, fullfile(plt_folder, plt_name), plt_save)

plt_name = "temperature_series_NO_w_PE_noSOC_1y"; 
plt_temp_time_series(results.case5, fullfile(plt_folder, plt_name), plt_save)

plt_name = "temperature_series_DY_wo_PE_1y"; 
plt_temp_time_series(results.case3, fullfile(plt_folder, plt_name), plt_save)

plt_name = "temperature_series_NO_wo_PE_1y"; 
plt_temp_time_series(results.case4, fullfile(plt_folder, plt_name), plt_save)

plt_name = "temperature_series_NO_wo_PE_noSOC_1y"; 
plt_temp_time_series(results.case6, fullfile(plt_folder, plt_name), plt_save)


%% Plot cell terminal voltages: 
close all;

plt_names_add = ["_DY_w_PE", "_NO_w_PE", "_DY_wo_PE", "_NO_wo_PE", "_NO_w_PE_noSOC", "_NO_wo_PE_noSOC"];

plt_name_prefix = "cell_Uk";

for i =1:length(plt_names_add)
    plt_name = plt_name_prefix + plt_names_add(i);
    plt_Uk(results.("case"+num2str(i)), func, fullfile(plt_folder, plt_name), plt_save)
end


%%

close all;  
plt_name = "table";
tab = plt_tab_creator(results, func, fullfile(plt_folder, plt_name), plt_save);


%%
clc;
case_order = [1 2 5 3 4 6]; 
myVars = ["ChargeThroughput", "FEC", "mean_Tc", "mean_SOC", "eff_ch", "eff_disch", "eff_roundtrip",  "revenue_gross", "PE_money_loss_sum", ...
    "bat_money_loss_sum", "revenue", "batteryApproxCost", "netProfit", "SOH", "dSOHcal", "dSOHcyc", "dSOH"];
myShape = '%4.4f';
for myVar = myVars
for j = 1:length(case_order)
    i = case_order(j);
    thisVar = tab.("case"+num2str(i)).(myVar);
    fprintf([myShape,'\t'],thisVar);
    if(j==3)
        fprintf('\t');
    end
    
end
fprintf('\b\n');
end

%% Future table 


future_table(1) = plt_calc_PI(results.case1, fullfile(plt_folder, plt_name), plt_save, plt_additional);
future_table(2) = plt_calc_PI(results.case2, fullfile(plt_folder, plt_name), plt_save, plt_additional);
future_table(3) = plt_calc_PI(results.case5, fullfile(plt_folder, plt_name), plt_save, plt_additional);

%%
clc;
func_printArray([future_table.t_EOL_y],'%4.4f')
func_printArray([future_table.total_profit_PV],'%4.4f')
func_printArray([future_table.PI],'%4.4f')
func_printArray([future_table.fitness]*100,'%4.4f')
func_printArray(-[future_table.a],'%4.4f')
