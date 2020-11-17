% There is a limit on AC power in `no temperature` mode: 
clc;

max(results.case2.nonsv.AC.Pnett) % -MAX VALUE IS LIMITED? WHYYYY
min(results.case2.nonsv.AC.Pnett) % MIN VALUE IS 345.6 


max(results.case2.nonsv.bat.Pnett) % -MAX VALUE IS LIMITED? WHYYYY
min(results.case2.nonsv.bat.Pnett) % MIN VALUE IS 345.6 
%%
max(results.case4.nonsv.AC.Pnett) % -MAX VALUE IS LIMITED? WHYYYY
min(results.case4.nonsv.AC.Pnett) % MIN VALUE IS 345.6 
%%

% #Headers
KELVIN = 273.15;

SimulSettings = simulationSettings; % For path generation. 

results.case1 = load(fullfile(SimulSettings.path.results.main, ...
                "act2020_04_12_dynamic_combined_2C_30_days.mat"));
results.case2 = load(fullfile(SimulSettings.path.results.main, ...
                "act2020_04_12_notOptimized_combined_2C_30_days.mat"));

results.case3 = load(fullfile(SimulSettings.path.results.main, ...
                "act2020_04_12_dynamic_bat_loss_2C_30_days.mat"));
results.case4 = load(fullfile(SimulSettings.path.results.main, ...
                "act2020_04_12_notOptimized_bat_loss_2C_30_days.mat"));

% results.case42 = load(fullfile(SimulSettings.path.results.main, ...
%                 "act2020_04_21_notOptimized_bat_loss_2C_30_days.mat")); 
%%

max(results.case4.nonsv.bat.Pnett) % -MAX VALUE IS LIMITED? WHYYYY
min(results.case4.nonsv.bat.Pnett) % MIN VALUE IS 345.6 


%kron(eye(length(DYorNO.nonsv.AC.Pnett)/DYorNO.nonsv.N  ),ones(1,DYorNO.nonsv.N))*DYorNO.nonsv.AC.Pnett/DYorNO.nonsv.N

%%
clc;
[test.case2.max, test.case2.maxind] = max(results.case2.nonsv.AC.Pnett);


test.case2.max

test.loop_ratio = length(results.case2.nonsv.AC.Pnett)/length(results.case2.nonsv.optResults);

test.indis = floor((test.case2.maxind-1)/test.loop_ratio );

results.case2.nonsv.optResults{test.indis}{1}'

results.case2.nonsv.AC.Pnett(((test.indis-1)*(test.loop_ratio)+1) : ((test.indis-1)*(test.loop_ratio)+128) )'

for i=1:length(results.case2.nonsv.optResults)
    if(max(results.case2.nonsv.optResults{i}{1}')>250)
   fprintf("%4.4f\n",max(results.case2.nonsv.optResults{i}{1}'))
    end
    
end


%%

clc;
[test.case1.max, test.case1.maxind] = max(results.case1.nonsv.AC.Pnett);




test.loop_ratio = length(results.case1.nonsv.AC.Pnett)/length(results.case1.nonsv.optResults);

test.indis = floor((test.case1.maxind-1)/test.loop_ratio );

results.case1.nonsv.optResults{test.indis}{1}'

results.case1.nonsv.AC.Pnett( ((test.indis-1)*(test.loop_ratio)+1) : ((test.indis-1)*(test.loop_ratio)+128) )'


%% 
load('test2_notOptimized_bat_loss_2C_0.41667_days.mat'); % -> new constraints scheme, faster. 
xp = load('results/test_notOptimized_bat_loss_2C_0.41667_days.mat');

%%


figure; 

plot(nonsv.AC.Pnett)
hold on;
plot(xp.nonsv.AC.Pnett)

legend('new','old');


%% Test new one! 

close all; clc;

plt_SOH_comparison(results.case4, results.case42, fullfile(plt_folder, plt_name), 0);

plt_PAC_ecdf(results.case4, results.case42, fullfile(plt_folder, plt_name), 0);
%%
plt_additional.color_temp_dist = 1;
plt_temp_dist(results.case4, fullfile(plt_folder, plt_name), 0, plt_additional)

plt_additional.color_temp_dist = 0;
plt_temp_dist(results.case42, fullfile(plt_folder, plt_name), 0, plt_additional)

%% PROBLEM STILL NO CHARGE AT HIGH C RATE WHEN TEMPERATURE EFFECT IS NOT CONSIDERED? 

% LET US SEE correlation temperature?? 



test.selector.pos = results.case3.nonsv.AC.Pnett>=0;

temp2 = results.case3.nonsv.AC.Pnett(test.selector.pos);
temp = movmean(results.case3.nonsv.bat.Tk,2)-KELVIN;
temp = temp(2:end);
temp = temp(test.selector.pos);

[test.rho, test.pval] =  corr(temp,temp2);

figure;

scatter(temp,temp2);

%%
figure;
hist3([temp2, temp],'CdataMode','auto')
xlabel('Charging AC Power [kW]')
ylabel('Temperature [^oC]')
colorbar
view(2);

set(gca,'ColorScale','log')


%%

test.selector3 = abs(results.case1.nonsv.AC.Pnett)>=1e-3;

temp23 = results.case1.nonsv.AC.Pnett(test.selector3);

temp3 = movmean(results.case1.nonsv.bat.Tk,2)-KELVIN;
temp3 = temp3(2:end);
temp3 = temp3(test.selector3);
figure;
hist3([temp23, temp3],[15 15],'CdataMode','auto')
xlabel('Charging AC Power [kW]')
ylabel('Temperature [^oC]')
colorbar
view(2);

%set(gca,'ColorScale','log')


%% 

test.selector3 = abs(results.case2.nonsv.AC.Pnett)>=1e-3;

temp23 = results.case2.nonsv.AC.Pnett(test.selector3);

temp3 = movmean(results.case2.nonsv.bat.Tk,2)-KELVIN;
temp3 = temp3(2:end);
temp3 = temp3(test.selector3);
figure;
hist3([temp23, temp3],[15 15],'CdataMode','auto')
xlabel('Charging AC Power [kW]')
ylabel('Temperature [^oC]')
colorbar
view(2);

%set(gca,'ColorScale','log')

%% Let's see the cost! 


figure;
hold on;
testlegends = {}
testi = 1;
Pw = [-18:0.1:18];
for testTc =[25:10:55]
    
    test_asd =  func_solve_quad_eq(Pw,0.5,KELVIN+testTc,func,1);
    
    
    semilogy(Pw,1./test_asd.t_EOL_h);
    testlegends{testi} = num2str(testTc);
    testi = testi+1;
end

legend(testlegends{:});

%% Let's see the cost! 


figure;

testlegends = {}
testi = 1;
Pw = [-18:0.5:18];
for testTc =[25:10:55]
    
    test_asd =  func_solve_quad_eq(Pw,0.5,KELVIN+testTc,func,1);
    temp = 1./test_asd.t_EOL_h;
    
    cost_kat = [ temp(Pw>=0)./temp(Pw<=0)];
    
    semilogy(abs(Pw(Pw>=0))/3.2,cost_kat);
    hold on;
    testlegends{testi} = num2str(testTc);
    testi = testi+1;
end
grid on;
xlabel('Amper');
ylabel(' Kat farki');

legend(testlegends{:});

%% Test with cost elements. 

test.sce1 = load('results/test_20_04_26_dynamic_bat_loss_2C_0.41667_days.mat');
test.sce2 = load('results/test_20_04_26_notOptimized_bat_loss_2C_0.41667_days.mat');
%%
close all;
figure; 



subplot(2,1,1); 
plot(test.sce1.sol.sdpv.AC.Pnett); grid on; hold on;
plot(test.sce2.sol.sdpv.AC.Pnett,'--'); 
legend('dynamic','NO','location','northwest');

subplot(2,1,2);
plot(test.sce1.sol.sdpv.Jstep.Aging ); grid on; hold on;
plot(test.sce2.sol.sdpv.Jstep.Aging ,'--');
legend('dynamic','NO','location','northwest');


%% 
close all;
figure;

subplot(2,1,1);
plot(linspace(0,1,length(test.sce1.sol.sdpv.bat.SOC)), test.sce1.sol.sdpv.bat.SOC);
hold on;
plot(linspace(0,1,length(test.sce1.nonsv.bat.SOC)), test.sce1.nonsv.bat.SOC, '--');
legend('opt','act','location','northwest');

grid on;


subplot(2,1,2);
plot(linspace(0,1,length(test.sce2.sol.sdpv.bat.SOC)), test.sce2.sol.sdpv.bat.SOC);
hold on;
plot(linspace(0,1,length(test.sce2.nonsv.bat.SOC)), test.sce2.nonsv.bat.SOC, '--');
legend('opt','act','location','northwest');

grid on;

%% 
close all;
figure;



subplot(2,1,1);
stairs(kron(test.sce1.sol.sdpv.bat.I_cell,ones(length(test.sce1.nonsv.bat.I_cell)/length(test.sce1.sol.sdpv.bat.I_cell),1)));
hold on;
stairs(test.sce1.nonsv.bat.I_cell, '--');
legend('opt','act','location','northwest');

grid on;


subplot(2,1,2);
stairs(kron(test.sce2.sol.sdpv.bat.I_cell,ones(length(test.sce2.nonsv.bat.I_cell)/length(test.sce2.sol.sdpv.bat.I_cell),1)));
hold on;
stairs(test.sce2.nonsv.bat.I_cell, '--');
legend('opt','act','location','northwest');

grid on;


%% 
close all;
figure;



subplot(2,1,1);
stairs(kron(test.sce1.sol.sdpv.bat.Pcell_approx, ones(length(test.sce1.nonsv.bat.I_cell)/length(test.sce1.sol.sdpv.bat.I_cell),1)));
hold on;
stairs(test.sce1.nonsv.bat.P_cell, '--');

grid on;


subplot(2,1,2);
stairs(kron(test.sce2.sol.sdpv.bat.Pcell_approx, ones(length(test.sce2.nonsv.bat.I_cell)/length(test.sce2.sol.sdpv.bat.I_cell),1)));
hold on;
stairs(test.sce2.nonsv.bat.P_cell, '--');

grid on;

%%
close all
test.temp1 = func_solve_quad_eq(test.sce1.sol.sdpv.bat.Pcell_approx,...
                                conv(test.sce1.sol.sdpv.bat.SOC,[1/2,1/2],'valid'),...
                                conv(test.sce1.sol.sdpv.bat.Tk,[1/2,1/2],'valid'),   func,1);
                            
                            
test.temp1_cost = arbj.bat.Cost_whole./test.temp1.t_EOL_h;

test.temp2 = func_solve_quad_eq(test.sce2.sol.sdpv.bat.Pcell_approx,...
                                conv(test.sce2.sol.sdpv.bat.SOC,[1/2,1/2],'valid'),...
                                conv(test.sce2.sol.sdpv.bat.Tk,[1/2,1/2],'valid'),   func,1);
                            
                            
test.temp2_cost = arbj.bat.Cost_whole./test.temp2.t_EOL_h;

figure;
subplot(2,1,1);
plot(test.sce1.sol.sdpv.Jstep.Aging); hold on; 
plot(test.temp1_cost*arbj.dth, '--'); grid on;
legend('optim','act','location','northwest');



subplot(2,1,2);
plot(test.sce2.sol.sdpv.Jstep.Aging); hold on; 
plot(test.temp2_cost*arbj.dth, '--'); grid on;


%% Thermal dependance does it really differ THAT MUCH? 
close all
test.temp1 = func_solve_quad_eq(test.sce1.sol.sdpv.bat.Pcell_approx,...
                                conv(test.sce1.sol.sdpv.bat.SOC,[1/2,1/2],'valid'),...
                                conv(test.sce1.sol.sdpv.bat.Tk,[1/2,1/2],'valid'),   func,1);
                            
                            
test.temp1_cost = arbj.bat.Cost_whole./test.temp1.t_EOL_h;


figure('Position', [600 100 1200 1200]);
subplot(4,1,1);
plot(test.sce1.sol.sdpv.Jstep.Aging); hold on; 
plot(test.temp1_cost*arbj.dth, '--'); grid on;



subplot(4,1,2);
stairs(test.sce1.sol.sdpv.bat.Pcell_approx); grid on;



subplot(4,1,3);
plot( conv(test.sce1.sol.sdpv.bat.Tk,[1/2,1/2],'valid')-KELVIN); grid on;

yyaxis right

plot( conv(test.sce1.sol.sdpv.bat.SOC,[1/2,1/2],'valid')); grid on;


test.thermal_Tc  =  (18:0.5:55);
test.thermal_dep =  func_solve_quad_eq(-13.26,...
                                0.68, ...
                                KELVIN+test.thermal_Tc,   func,1);                            
                            
                            
test.thermal_dep_cost = arbj.bat.Cost_whole./test.thermal_dep.t_EOL_h;
subplot(4,1,4); 
plot(test.thermal_Tc, test.thermal_dep_cost*arbj.dth); grid on;

% Why is different? Does this points make? Let's use interp

%test.thermal_X = [test.sce1.sol.sdpv.bat.Pcell_approx'; conv(test.sce1.sol.sdpv.bat.SOC,[1/2,1/2],'valid')'; ...
%                  conv(test.sce1.sol.sdpv.bat.Tk,[1/2,1/2],'valid')'];
              
%test.thermal_Y =  myNeuralNetworkFunction(test.thermal_X );            
 
%test.thermal_F = griddedInterpolant(data.segm.P.X,data.segm.SOC.X,data.segm.T.X, arbj.bat.Cost_whole./quad_eq.t_EOL_h);


%%
%[aaaa,bbbb,cccc] = ndgrid(1:3,3:5,5:7)
test.sce1 = load('results/test_20_04_26_dynamic_bat_loss_2C_0.41667_days.mat');
test.sce2 = load('results/test_20_04_26_notOptimized_bat_loss_2C_0.41667_days.mat');
%%
lw = {'LineWidth',2};
close all;
test_neuralX = [data.segm.P.X(:), data.segm.SOC.X(:), data.segm.T.X(:)];
test_neuralY = arbj.bat.Cost_whole./quad_eq.t_EOL_h(:);

F = scatteredInterpolant(test_neuralX, test_neuralY);

test.thermal_Fx = [test.sce1.sol.sdpv.bat.Pcell_approx,...
                                conv(test.sce1.sol.sdpv.bat.SOC,[1/2,1/2],'valid'),...
                                conv(test.sce1.sol.sdpv.bat.Tk,[1/2,1/2],'valid')];
                            
test.thermal_Fy = F(  test.thermal_Fx);                       
                            

test.temp1 = func_solve_quad_eq(test.sce1.sol.sdpv.bat.Pcell_approx,...
                                conv(test.sce1.sol.sdpv.bat.SOC,[1/2,1/2],'valid'),...
                                conv(test.sce1.sol.sdpv.bat.Tk,[1/2,1/2],'valid'),   func,1);
                            
                            
test.temp1_cost = arbj.bat.Cost_whole./test.temp1.t_EOL_h;


figure('Position', [600 100 1400 1000]);
%subplot(4,1,1);
plot(test.sce1.sol.sdpv.Jstep.Aging, lw{:}); hold on; 
plot(test.temp1_cost*arbj.dth, '--', lw{:}); grid on;
plot(test.thermal_Fy*arbj.dth,'k*--', lw{:});


set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
%%

test.sens.P   = linspace(-18,18,66);
test.sens.SOC = linspace(0.05,0.95,30); %[0.048,  0.10, 0.15 0.25, 0.32  0.41, 0.65, 0.82 0.952];
test.sens.Tk  = linspace(18,60,30) + KELVIN;

[test.sens.PX, test.sens.SOCX, test.sens.TkX] = ndgrid(test.sens.P, test.sens.SOC, test.sens.Tk);


test.sens.P_minX  = func.It_to_Pt(-6,test.sens.SOCX(1,:,:),test.sens.TkX(1,:,:));
test.sens.P_maxX  = func.It_to_Pt(6, test.sens.SOCX(end,:,:),test.sens.TkX(end,:,:));

test.sens.PX2 = test.sens.PX;

test.sens.PX2(1,:,:)   = test.sens.P_minX;
test.sens.PX2(end,:,:) = test.sens.P_maxX;



%data.segm.P.X(:), data.segm.SOC.X(:), data.segm.T.X(:)




test.sens.quad = func_solve_quad_eq(test.sens.PX, test.sens.SOCX, test.sens.TkX, func, 0);

test.sens.cost = arbj.bat.Cost_whole./test.sens.quad.t_EOL_h;

test.sens.bigmat = [test.sens.PX(:), test.sens.SOCX(:), test.sens.TkX(:), test.sens.cost(:)];

test.sens.bigmat_mean = mean(test.sens.bigmat);

test.sens.bigmat_c = test.sens.bigmat - test.sens.bigmat_mean;

test.sens.bigmat_c = test.sens.bigmat_c./std(test.sens.bigmat_c);

[UU,SS,VV] = svd(test.sens.bigmat_c,'econ');


[wcoeff,~,latent,~,explained] = pca(test.sens.bigmat_c);

%mesh(test.sens.SOCX, test.sens.TkX-KELVIN, test.sens.cost)
%%


test.meshF = scatteredInterpolant(test.sens.PX(:), test.sens.SOCX(:), test.sens.TkX(:), test.sens.cost(:)  );

test.meshF_Fx = [test.sce1.sol.sdpv.bat.Pcell_approx,...
                                conv(test.sce1.sol.sdpv.bat.SOC,[1/2,1/2],'valid'),...
                                conv(test.sce1.sol.sdpv.bat.Tk,[1/2,1/2],'valid')];
                            
test.meshF_Fy = test.meshF(test.meshF_Fx);

plot(arbj.dth*test.meshF_Fy,'b:', lw{:});
legend('opt','act','scattered','test_interp');

% Neural network does not work try delaunay triangulation! It works same as
% MATLAB ::O 

% func_solve_quad_eq(-13.26, 0.68, 48.26+KELVIN,func,0)
%%
clc;
test.xvec = [-13.26, 0.68, 48.26+KELVIN];

test.vecnorm = vecnorm((test_neuralX - test.xvec)');

[test.min, test.min_ind] = min(test.vecnorm);

display(test.xvec);
display(test_neuralX( test.min_ind,:));

display(test_neuralY(test.min_ind))

test_eval = func_solve_quad_eq(test_neuralX( test.min_ind,1), test_neuralX( test.min_ind,2), test_neuralX( test.min_ind,3),func,0);

arbj.bat.Cost_whole./test_eval.t_EOL_h*arbj.dth

test_eval = func_solve_quad_eq(test.xvec(1),test.xvec(2), test.xvec(3),func,0);

arbj.bat.Cost_whole./test_eval.t_EOL_h*arbj.dth
% 
% test_eval = func_solve_quad_eq(test.xvec(1),test.xvec(2)*1.02, test.xvec(3),func,0);
% 
% arbj.bat.Cost_whole./test_eval.t_EOL_h*arbj.dth
% 
% test_eval = func_solve_quad_eq(test.xvec(1),test.xvec(2)*0.97, test.xvec(3),func,0);
% 
% arbj.bat.Cost_whole./test_eval.t_EOL_h*arbj.dth
% 
% test_eval = func_solve_quad_eq(test.xvec(1),test.xvec(2), test.xvec(3)*1.008,func,0);
% 
% arbj.bat.Cost_whole./test_eval.t_EOL_h*arbj.dth
% 
% test_eval = func_solve_quad_eq(test.xvec(1),test.xvec(2), test.xvec(3)*0.992,func,0);
% 
% arbj.bat.Cost_whole./test_eval.t_EOL_h*arbj.dth
% 
% 
% fprintf('Power:\n');
% 
% test_eval = func_solve_quad_eq(test.xvec(1)*1.05,test.xvec(2), test.xvec(3),func,0);
% 
% arbj.bat.Cost_whole./test_eval.t_EOL_h*arbj.dth
% 
% test_eval = func_solve_quad_eq(test.xvec(1)*0.95,test.xvec(2), test.xvec(3),func,0);
% 
% arbj.bat.Cost_whole./test_eval.t_EOL_h*arbj.dth

%% Test of sensitivity around P = -13.26 W 
close all;

%%
test.meshF(test.xvec(1), test.xvec(2), test.xvec(3))

%% 



figure; semilogy(-18:0.5:18,arbj.bat.Cost_whole./func_solve_quad_eq(-18:0.5:18,0.5,25+KELVIN,func,0).t_EOL_h)
grid on
xlabel('Pcell')
xlabel('Pcell [W]')
xlabel('Battery cost [EUR/h]')
xlabel('Pcell [W]')
ylabel('Battery cost [EUR/h]')
hold on
semilogy(-18:0.5:18,arbj.bat.Cost_whole./func_solve_quad_eq(-18:0.5:18,0.5,35+KELVIN,func,0).t_EOL_h)
semilogy(-18:0.5:18,arbj.bat.Cost_whole./func_solve_quad_eq(-18:0.5:18,0.5,45+KELVIN,func,0).t_EOL_h)
semilogy(-18:0.5:18,arbj.bat.Cost_whole./func_solve_quad_eq(-18:0.5:18,0.5,55+KELVIN,func,0).t_EOL_h)

legend('25^oC','35^oC', '45^oC', '55^oC','location','northwest')

%%
figure; semilogy((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(3, (0.05:0.01:0.95)', 25+KELVIN,func,0).t_EOL_h)
grid on
xlabel('Pcell')
xlabel('Pcell [W]')
xlabel('Battery cost [EUR/h]')
xlabel('Pcell [W]')
ylabel('Battery cost [EUR/h]')
hold on
semilogy((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(3, (0.05:0.01:0.95)', 35+KELVIN,func,0, true).t_EOL_h)
semilogy((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(3, (0.05:0.01:0.95)', 45+KELVIN,func,0,true).t_EOL_h)
semilogy((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(3, (0.05:0.01:0.95)', 55+KELVIN,func,0,true).t_EOL_h)

legend('25^oC','35^oC', '45^oC', '55^oC','location','northwest')

%%
figure; plot(-18:0.5:10,arbj.bat.Cost_whole./func_solve_quad_eq(-18:0.5:10,0.5,25+KELVIN,func,0).t_EOL_h)
grid on
xlabel('Pcell')
xlabel('Pcell [W]')
xlabel('Battery cost [EUR/h]')
xlabel('Pcell [W]')
ylabel('Battery cost [EUR/h]')
hold on
plot(-18:0.5:10,arbj.bat.Cost_whole./func_solve_quad_eq(-18:0.5:10,0.5,35+KELVIN,func,0).t_EOL_h)
plot(-18:0.5:10,arbj.bat.Cost_whole./func_solve_quad_eq(-18:0.5:10,0.5,45+KELVIN,func,0).t_EOL_h)
plot(-18:0.5:10,arbj.bat.Cost_whole./func_solve_quad_eq(-18:0.5:10,0.5,55+KELVIN,func,0).t_EOL_h)

legend('25^oC','35^oC', '45^oC', '55^oC','location','northwest')

%%
figure; plot(-18:0.5:10,arbj.bat.Cost_whole./func_solve_quad_eq(-18:0.5:10,0.85,25+KELVIN,func,0).t_EOL_h)
grid on
xlabel('Pcell')
xlabel('Pcell [W]')
xlabel('Battery cost [EUR/h]')
xlabel('Pcell [W]')
ylabel('Battery cost [EUR/h]')
hold on
plot(-18:0.5:10,arbj.bat.Cost_whole./func_solve_quad_eq(-18:0.5:10,0.85,35+KELVIN,func,0).t_EOL_h)
plot(-18:0.5:10,arbj.bat.Cost_whole./func_solve_quad_eq(-18:0.5:10,0.85,45+KELVIN,func,0).t_EOL_h)
plot(-18:0.5:10,arbj.bat.Cost_whole./func_solve_quad_eq(-18:0.5:10,0.85,55+KELVIN,func,0).t_EOL_h)

legend('25^oC','35^oC', '45^oC', '55^oC','location','northwest')

%%
figure; plot((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(-2, (0.05:0.01:0.95)', 25+KELVIN,func,0, true).t_EOL_h)
grid on
xlabel('SOC')
ylabel('Battery cost [EUR/h]')
hold on
plot((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(-2, (0.05:0.01:0.95)', 35+KELVIN,func,0, true).t_EOL_h)
plot((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(-2, (0.05:0.01:0.95)', 45+KELVIN,func,0,true).t_EOL_h)
plot((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(-2, (0.05:0.01:0.95)', 55+KELVIN,func,0,true).t_EOL_h)

legend('25^oC','35^oC', '45^oC', '55^oC','location','northwest')

%%
%close all;
testforhighC.P = (-18:0.5:23)';
testforhighC.quad_eq = func_solve_quad_eq(testforhighC.P, 0.9, 25+KELVIN, func, 1);

figure;

semilogy(testforhighC.P, testforhighC.quad_eq.t_EOL_h);

figure; 

semilogy(testforhighC.P, testforhighC.quad_eq.func.k_cal); hold on;
semilogy(testforhighC.P, testforhighC.quad_eq.func.k_cyc_high_T);
semilogy(testforhighC.P, testforhighC.quad_eq.func.k_cyc_low_T);
semilogy(testforhighC.P, testforhighC.quad_eq.func.k_cyc_low_T_high_SOC);

legend('kcal', 'k cyc highT','k cyc low T', 'k cyc low T high SOC');




%%  Stress factor. 
clear testforstress;
testforstress.Tk(1,1,:) =  KELVIN+ (0:1:50);
testforstress.quad_eq = func_solve_quad_eq(3, 0.9, testforstress.Tk, func, 1, true);

figure;
hold on;
plot(1000./testforstress.Tk(:), 1e3*testforstress.quad_eq.func.k_cyc_high_T(:));
plot(1000./testforstress.Tk(:), 1e3*testforstress.quad_eq.func.k_cyc_low_T(:));


legend('low T', 'high T');
%%

testpaperplots.Tk(1,1,:)  = KELVIN+ (0:1:60);
testpaperplots.I_t(:,1,1) = 0:0.1:3;

testpaperplots.quad_eq = func_solve_quad_eq(testpaperplots.I_t(:,1,1), 0.9, testpaperplots.Tk(1,1,:), func, 1, true);


testpaperplots_2c.Tk(1,1,:)  = KELVIN+ (0:1:60);
testpaperplots_2c.I_t(:,1,1) = 0:0.1:6;

testpaperplots_2c.quad_eq = func_solve_quad_eq(testpaperplots_2c.I_t(:,1,1), 0.9, testpaperplots_2c.Tk(1,1,:), func, 1, true);

%%
close all;
figure('Position',[100,100,1000,500]);
subplot(1,2,1);
mesh(squeeze(testpaperplots.quad_eq.X)/3, squeeze(testpaperplots.quad_eq.Z), squeeze(testpaperplots.quad_eq.func.k_cyc_low_T)); view(-145,20);
xlabel('C-rate'); ylabel('Temp ^oC'); zlabel('k cyc low T');
subplot(1,2,2);
mesh(squeeze(testpaperplots_2c.quad_eq.X)/3, squeeze(testpaperplots_2c.quad_eq.Z), squeeze(testpaperplots_2c.quad_eq.func.k_cyc_low_T));
view(-145,20);
xlabel('C-rate'); ylabel('Temp ^oC'); zlabel('k cyc low T');


%%
close all;
figure('Position',[100,100,1000,500]);
subplot(1,2,1);
mesh(squeeze(testpaperplots.quad_eq.X)/3, squeeze(testpaperplots.quad_eq.Z), squeeze(testpaperplots.quad_eq.func.k_cyc_low_T_high_SOC)); view(-145,20);
xlabel('C-rate'); ylabel('Temp ^oC'); zlabel('k cyc low T high SOC');
subplot(1,2,2);
mesh(squeeze(testpaperplots_2c.quad_eq.X)/3, squeeze(testpaperplots_2c.quad_eq.Z), squeeze(testpaperplots_2c.quad_eq.func.k_cyc_low_T_high_SOC));
view(-145,20);
xlabel('C-rate'); ylabel('Temp ^oC'); zlabel('k cyc low T high SOC');

%% Specific values. 
clc;

test_specific(2*3, 0.82, KELVIN+18, func);
test_specific(2*3, 0.8199, KELVIN+18, func);
test_specific(2*3, 0.65, KELVIN+18, func);
test_specific(2*3, 0.952, KELVIN+18, func);
test_specific(2*3, 0.82, KELVIN+25, func);
test_specific(2*3, 0.81, KELVIN+25, func);




%% Tests suggested by Schimpe: 
clc;
% Cell resistance and terminal voltage at 82% SOC. 
% func.U_OCV(0.82)
% 
% func.Ri_Ch(0.82, KELVIN+18)
% 
% func.dU(6,0.82,KELVIN+18)

test_specific(3, 0.98, KELVIN+50, func)
test_specific(4.25, 0.82, KELVIN+18, func)
test_specific(6, 0.82, KELVIN+18, func)

test_specific(-3, 0.98, KELVIN+50, func)
test_specific(-4.25, 0.82, KELVIN+18, func)
test_specific(-6, 0.02, KELVIN+18, func)

function [] = test_specific(I_t, SOC, Tk, func)
test_specific.Uk = func.U_OCV(SOC) + func.dU(I_t,SOC,Tk);

test_specific.I_t = I_t; % 2C
test_specific.SOC = SOC; % SOC 
test_specific.Tk  = Tk;
test_specific.quad_eq = func_solve_quad_eq(test_specific.I_t(:,1,1), test_specific.SOC, test_specific.Tk(1,1,:), func, 1, true);

fprintf('At It = %4.1f C,  SOC = %4.3f,  T = %4.2f C   values are: \n\n',test_specific.I_t/3, test_specific.SOC, test_specific.Tk - KELVIN);

fprintf('Terminal Voltage \t\t: %4.4f Volts \n',test_specific.Uk);
fprintf('Battery life \t\t\t: %0.4e hours \n',test_specific.quad_eq.t_EOL_h);
fprintf('kcal \t\t\t\t\t: %0.4e \n',test_specific.quad_eq.func.k_cal);
fprintf('k cyc high T \t\t\t: %0.4e \n',test_specific.quad_eq.func.k_cyc_high_T);
fprintf('k cyc low T \t\t\t: %0.4e \n',test_specific.quad_eq.func.k_cyc_low_T);
fprintf('k cyc low T high SOC\t: %0.4e \n\n',test_specific.quad_eq.func.k_cyc_low_T_high_SOC);
end


