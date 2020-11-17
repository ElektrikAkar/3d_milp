% Tests to understand paper by schimpe 
% Comprehensive Modeling of Temperature-Dependent Degradation Mechanisms
% in Lithium Iron Phosphate Batteries

clear all; close all; clc;
% #Headers
KELVIN = 273.15;

param.AnodeLi_C.x_0     = 8.5e-3; %Stoichiometry x(SOC =0%) for Anode Li-C
param.AnodeLi_C.x_100   = 7.8e-1; %Stoichiometry x(SOC =0%) for Anode Li-C

param.Cathode_LFP.x_0     = 9.16e-1; %Stoichiometry x(SOC =0%) for Cathode LFP
param.Cathode_LFP.x_100   = 4.5e-2; %Stoichiometry x(SOC =0%) for Cathode LFP

%---------Anode---------
func.Ua = @(x_a) 0.6379 + 0.5416*exp(-305.5309*x_a) + 0.044*tanh(-(x_a - 0.1958)/0.1088) + ...
                 -0.1978*tanh((x_a - 1.0571)/0.0854) -0.6875*tanh( (x_a + 0.0117)/0.0529) + ...
                 -0.0175*tanh( (x_a -0.5692)/0.0875); 
             
func.x_a = @(SOC) param.AnodeLi_C.x_0 + SOC*(param.AnodeLi_C.x_100 - param.AnodeLi_C.x_0);

func.Ua_SOC = @(SOC) func.Ua(func.x_a(SOC));

%--------Cathode--------
func.Uc = @(x_c) 3.4323 -0.8428*exp(-80.2493*(1-x_c).^1.3198) +...
                 -3.2474e-6*exp(20.2645*(1-x_c).^3.8003) +...
                 +3.2482e-6*exp(20.2646*(1-x_c).^3.7995);
             
func.x_c = @(SOC) param.Cathode_LFP.x_0 + SOC*(param.Cathode_LFP.x_100 - param.Cathode_LFP.x_0);

func.Uc_SOC = @(SOC) func.Uc(func.x_c(SOC));

func.Uca_SOC = @(SOC) func.Uc(func.x_c(SOC)) - func.Uc(func.x_a(SOC)); %Verified Fig A1.(a).


numer.SOC = (0:12.5:100)/100;%0:0.01:1;

numer.Ua = func.Ua_SOC(numer.SOC);
numer.Uc = func.Uc_SOC(numer.SOC);


param.cal.k_cal_ref = 3.694e-4    ; %h^(-0.5) 
param.cal_U_a_ref   = 0.123; %Volt, at 50% of SOC
param.cal.T_ref     = 298.15; %K 
param.cal.F         = 96485; %C/mol faraday constant. 
param.cal.alpha     = 0.384; 
param.cal.k_0       = 0.142;
param.cal.R_g       = 8.314; %J/(mol K)
param.cal.E_a_cal   = 20592; %J/mol



func.k_cal_T = @(T) param.cal.k_cal_ref*exp(-(param.cal.E_a_cal/param.cal.R_g).* (1./T - 1/param.cal.T_ref    )     );

%exp( -(param.cal.E_a_cal/param.cal.R_g).*(1./T - 1/param.cal.T_ref));

func.k_cal = @(T,SOC) param.cal.k_cal_ref*...
                      exp( -(param.cal.E_a_cal/param.cal.R_g).*(1./T - 1/param.cal.T_ref)).*...
                      (exp( (param.cal.alpha*param.cal.F/param.cal.R_g).*((param.cal_U_a_ref-func.Ua_SOC(SOC))/param.cal.T_ref)) + param.cal.k_0);

func.k_cal_Ua = @(T,Ua) param.cal.k_cal_ref*...
                      exp( -(param.cal.E_a_cal/param.cal.R_g).*(1./T - 1/param.cal.T_ref)).*...
                      (exp( (param.cal.alpha*param.cal.F/param.cal.R_g).*((param.cal_U_a_ref-Ua)/param.cal.T_ref)) + param.cal.k_0); %Verified to Figure 4b
                  
numer.T = 25 + 273.15;

numer.T1 = (55:-1:10) + 273.15; 

numer.k_cal   = func.k_cal(numer.T,numer.SOC);
numer.k_cal_T = func.k_cal_T(numer.T1);

numer.U_a_potential = 0.06:0.01:0.7;

numer.k_cal_forUa  = func.k_cal_Ua(numer.T,numer.U_a_potential);
%%
figure;
plot(1000./(numer.T1),log(numer.k_cal_T)); grid on;
ylim([-9,-6])
%%
figure;
plot(1000./(numer.T1),log(func.k_cal(numer.T1,1))); grid on;
ylim([-9,-6])

%%
figure;
hold on;
xyz = [10,15,25,35,45,55];
xyz = xyz(end:-1:1);

for myT = xyz
    myTK = myT + 273.15; 
    
    plot(100*numer.SOC,1000*func.k_cal(myTK,numer.SOC),'s-','LineWidth',2); grid on;
    
end
ylabel('Stress factor k');
xlabel('SOC/%');
legend('55 ^oC','45 ^oC','35 ^oC','25 ^oC','15 ^oC','10 ^oC');
%%
figure;
plot(numer.U_a_potential,1000*numer.k_cal_forUa,'r--','LineWidth',2); grid on;

%%
figure;
plot(numer.SOC,numer.Ua,'r--','LineWidth',2); grid on;


%%
figure;

numer.SOC2 = 0:0.005:1;
plot(numer.SOC2,(func.Uc_SOC(numer.SOC2)-func.Ua_SOC(numer.SOC2)),'r--','LineWidth',2); grid on; hold on;

load_data;

plot(data.U_OCV.SOC,data.U_OCV.V);


