% Tests for new results with optimized segmentation and -2C to 1C 
% due to the voltage problem we limit charging C-rate with 1C

KELVIN = 273.15;

SimulSettings = simulationSettings; % For path generation. 

results.case1 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_05_dynamic_dynamic_combined_2C_30_days.mat"));
results.case2 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_05_notOptimized_dynamic_combined_2C_30_days.mat"));

results.case3 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_05_dynamic_dynamic_bat_loss_2C_30_days.mat"));
results.case4 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_05_notOptimized_dynamic_bat_loss_2C_30_days.mat"));
            
results.case5 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_05_notOptimized_notOptimized_combined_2C_30_days.mat"));
results.case6 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_05_notOptimized_notOptimized_bat_loss_2C_30_days.mat"));
            
% test.sce1 = results.case3;
% test.sce2 = results.case4;
%       
            
%% 

max(results.case4.nonsv.bat.Pnett) % -MAX VALUE IS LIMITED? WHYYYY
min(results.case4.nonsv.bat.Pnett) % MIN VALUE IS 345.6 


% figure;
% stairs(results.case1.nonsv.AC.Pnett);
% hold on;
% 
% figure;
% plot(results.case1.nonsv.bat.SOC);
% title('SOC Nonsv');
% hold on;
% plot(results.case1.nonsv.bat.I_cell/3);


%% Test if we ever exceed voltage limits! 
% - Use plt_Uk from now on!

%% Test what are cell voltages for worst case! 
figure;
testVolt.SOC   = 0.05;
testVolt.U_OCV = func.U_OCV(testVolt.SOC);
testVolt.dU    = func.dU(-6, testVolt.SOC, (18:1:60)+KELVIN);

testVolt.Uk    = testVolt.U_OCV + testVolt.dU;

plot((18:1:60), testVolt.Uk);
xlabel('Cell Temperature / ^oC');
ylabel('Cell Voltage / V');
grid on;

title('2C discharge, 5% SOC');
%%
figure;
testVolt.SOC   = 0.01:0.01:0.99;
testVolt.U_OCV = func.U_OCV(testVolt.SOC);
testVolt.dU    = func.dU(-6, testVolt.SOC, (18)+KELVIN);

testVolt.Uk    = testVolt.U_OCV + testVolt.dU;

plot(100*testVolt.SOC, testVolt.Uk);
xlabel('Cell SOC / %');
ylabel('Cell Voltage / V');
grid on;

title('2C discharge, 18^oC');






