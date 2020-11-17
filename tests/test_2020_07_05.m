% Tests for new results with optimized segmentation and -2C to 1C 
% due to the voltage problem we limit charging C-rate with 1C

KELVIN = 273.15;

SimulSettings = simulationSettings; % For path generation. 

results.case1 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_05_test_dynamic_dynamic_combined_2C_5_days.mat"));
results.case2 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_05_test_notOptimized_dynamic_combined_2C_5_days.mat"));

results.case3 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_05_test_dynamic_dynamic_bat_loss_2C_5_days.mat"));
results.case4 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_05_test_notOptimized_dynamic_bat_loss_2C_5_days.mat"));
            
results.case5 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_05_test_notOptimized_notOptimized_combined_2C_5_days.mat"));
results.case6 = load(fullfile(SimulSettings.path.results.main, ...
                "paper_2020_07_05_test_notOptimized_notOptimized_bat_loss_2C_5_days.mat"));
            
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
mycase = "case1";
testVolt.Uk = zeros(length(results.(mycase).nonsv.bat.I_cell),1);

for i=1:length(results.(mycase).nonsv.bat.I_cell)
   testVolt.I_cell = results.(mycase).nonsv.bat.I_cell(i);
   testVolt.SOC    = results.(mycase).nonsv.bat.SOC(i)/2 + results.(mycase).nonsv.bat.SOC(i+1)/2 ;
   testVolt.Tk     = results.(mycase).nonsv.bat.Tk(i)/2 + results.(mycase).nonsv.bat.Tk(i+1)/2 ;
   
   testVolt.Uk(i)  = func.U_OCV(testVolt.SOC) + func.dU(testVolt.I_cell, testVolt.SOC, testVolt.Tk);
end

figure;
plot(testVolt.Uk); title(mycase);



mycase = "case2";

testVolt.Uk = zeros(length(results.(mycase).nonsv.bat.I_cell),1);

for i=1:length(results.(mycase).nonsv.bat.I_cell)
   testVolt.I_cell = results.(mycase).nonsv.bat.I_cell(i);
   testVolt.SOC    = results.(mycase).nonsv.bat.SOC(i)/2 + results.(mycase).nonsv.bat.SOC(i+1)/2 ;
   testVolt.Tk     = results.(mycase).nonsv.bat.Tk(i)/2 + results.(mycase).nonsv.bat.Tk(i+1)/2 ;
   
   testVolt.Uk(i)  = func.U_OCV(testVolt.SOC) + func.dU(testVolt.I_cell, testVolt.SOC, testVolt.Tk);
end

figure;
plot(testVolt.Uk); title(mycase);

mycase = "case3";

testVolt.Uk = zeros(length(results.(mycase).nonsv.bat.I_cell),1);

for i=1:length(results.(mycase).nonsv.bat.I_cell)
   testVolt.I_cell = results.(mycase).nonsv.bat.I_cell(i);
   testVolt.SOC    = results.(mycase).nonsv.bat.SOC(i)/2 + results.(mycase).nonsv.bat.SOC(i+1)/2 ;
   testVolt.Tk     = results.(mycase).nonsv.bat.Tk(i)/2 + results.(mycase).nonsv.bat.Tk(i+1)/2 ;
   
   testVolt.Uk(i)  = func.U_OCV(testVolt.SOC) + func.dU(testVolt.I_cell, testVolt.SOC, testVolt.Tk);
end

figure;
plot(testVolt.Uk); title(mycase);

mycase = "case4";

testVolt.Uk = zeros(length(results.(mycase).nonsv.bat.I_cell),1);

for i=1:length(results.(mycase).nonsv.bat.I_cell)
   testVolt.I_cell = results.(mycase).nonsv.bat.I_cell(i);
   testVolt.SOC    = results.(mycase).nonsv.bat.SOC(i)/2 + results.(mycase).nonsv.bat.SOC(i+1)/2 ;
   testVolt.Tk     = results.(mycase).nonsv.bat.Tk(i)/2 + results.(mycase).nonsv.bat.Tk(i+1)/2 ;
   
   testVolt.Uk(i)  = func.U_OCV(testVolt.SOC) + func.dU(testVolt.I_cell, testVolt.SOC, testVolt.Tk);
end

figure;
plot(testVolt.Uk); title(mycase);

mycase = "case5";

testVolt.Uk = zeros(length(results.(mycase).nonsv.bat.I_cell),1);

for i=1:length(results.(mycase).nonsv.bat.I_cell)
   testVolt.I_cell = results.(mycase).nonsv.bat.I_cell(i);
   testVolt.SOC    = results.(mycase).nonsv.bat.SOC(i)/2 + results.(mycase).nonsv.bat.SOC(i+1)/2 ;
   testVolt.Tk     = results.(mycase).nonsv.bat.Tk(i)/2 + results.(mycase).nonsv.bat.Tk(i+1)/2 ;
   
   testVolt.Uk(i)  = func.U_OCV(testVolt.SOC) + func.dU(testVolt.I_cell, testVolt.SOC, testVolt.Tk);
end

figure;
plot(testVolt.Uk); title(mycase);

mycase = "case6";

testVolt.Uk = zeros(length(results.(mycase).nonsv.bat.I_cell),1);

for i=1:length(results.(mycase).nonsv.bat.I_cell)
   testVolt.I_cell = results.(mycase).nonsv.bat.I_cell(i);
   testVolt.SOC    = results.(mycase).nonsv.bat.SOC(i)/2 + results.(mycase).nonsv.bat.SOC(i+1)/2 ;
   testVolt.Tk     = results.(mycase).nonsv.bat.Tk(i)/2 + results.(mycase).nonsv.bat.Tk(i+1)/2 ;
   
   testVolt.Uk(i)  = func.U_OCV(testVolt.SOC) + func.dU(testVolt.I_cell, testVolt.SOC, testVolt.Tk);
end

figure;
plot(testVolt.Uk); title(mycase);

%%





