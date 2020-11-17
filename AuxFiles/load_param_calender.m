% Parameters from Michael Schimpe's ECS paper. 
% Schimpe, M., von Kuepach, M. E., Naumann, M., Hesse, H. C., Smith, K., & Jossen, A. (2018). 
% Comprehensive modeling of temperature-dependent degradation mechanisms in lithium iron phosphate batteries. 
% Journal of The Electrochemical Society, 165(2), A181-A193.
% Author: VK
% Date  : ? 


param.cal.k_cal_ref     = 3.694e-4; % h^(-0.5) 
param.cal_U_a_ref       = 0.123;    % Volt, at 50% of SOC
param.cal.T_ref         = 298.15;   % K 
param.cal.F             = 96485;    % C/mol faraday constant. 
param.cal.alpha         = 0.384; 
param.cal.k_0           = 0.142;
param.cal.R_g           = 8.314;    % J/(mol K)
param.cal.E_a_cal       = 20592;    % J/mol


param.AnodeLi_C.x_0     = 8.5e-3;   % Stoichiometry x(SOC =0%) for Anode Li-C
param.AnodeLi_C.x_100   = 7.8e-1;   % Stoichiometry x(SOC =0%) for Anode Li-C

param.Cathode_LFP.x_0   = 9.16e-1;  % Stoichiometry x(SOC =0%) for Cathode LFP
param.Cathode_LFP.x_100 = 4.5e-2;   % Stoichiometry x(SOC =0%) for Cathode LFP

%---------Anode---------
func.Ua = @(x_a) 0.6379 + 0.5416*exp(-305.5309*x_a) + 0.044*tanh(-(x_a - 0.1958)/0.1088) + ...
                 -0.1978*tanh((x_a - 1.0571)/0.0854) -0.6875*tanh( (x_a + 0.0117)/0.0529) + ...
                 -0.0175*tanh( (x_a -0.5692)/0.0875); 
             
func.x_a = @(SOC_pu) param.AnodeLi_C.x_0 + SOC_pu*(param.AnodeLi_C.x_100 - param.AnodeLi_C.x_0);

func.Ua_SOC = @(SOC_pu) func.Ua(func.x_a(SOC_pu));

%--------Cathode--------
func.Uc = @(x_c) 3.4323 -0.8428*exp(-80.2493*(1-x_c).^1.3198) +...
                 -3.2474e-6*exp(20.2645*(1-x_c).^3.8003) +...
                 +3.2482e-6*exp(20.2646*(1-x_c).^3.7995);
             
func.x_c = @(SOC_pu) param.Cathode_LFP.x_0 + SOC_pu*(param.Cathode_LFP.x_100 - param.Cathode_LFP.x_0);

func.Uc_SOC = @(SOC_pu) func.Uc(func.x_c(SOC_pu));

func.Uca_SOC = @(SOC_pu) func.Uc(func.x_c(SOC_pu)) - func.Uc(func.x_a(SOC_pu)); %Verified Fig A1.(a).

func.k_cal = @(SOC_pu,Tk) param.cal.k_cal_ref*...
                      exp( -(param.cal.E_a_cal/param.cal.R_g).*(1./Tk - 1/param.cal.T_ref)).*...
                      (exp( (param.cal.alpha*param.cal.F/param.cal.R_g).*((param.cal_U_a_ref-func.Ua_SOC(SOC_pu))/param.cal.T_ref)) + param.cal.k_0);
                  
                  
                  
%------------------------------

param.cyc.k_cyc_high_T_ref          = 1.456e-4; % [Ah^(-0.5)]  T = 25C, I = 1C
param.cyc.k_cyc_low_T_ref           = 4.009e-4; % [Ah^(-0.5)]  T = 25C, ICh = 1C
param.cyc.k_cyc_low_T_high_SOC_ref  = 2.031e-6; % [Ah^(-0.5)]  T = 25C, ICh = 1C

param.cyc.Ea_cyc_high_T             = 32699;   % [J/mol] I = 1C
param.cyc.Ea_cyc_low_T              = 55546;   % [J/mol] I_ch = 1C
param.cyc.Ea_cyc_low_T_high_SOC     = 2.33e5;  % [J/mol] I_ch = 1C

param.cyc.I_ch_ref                  = 3;       % [A] 
param.cyc.beta_low_T                = 2.64;    % [h]
param.cyc.beta_low_T_high_SOC       = 7.84;    % [h]

param.cyc.C0                        = 3;       % [Ah] nominal cell capacity.
param.cyc.SOCref                    = 0.82;    % [-] ref SOC fo high T high SOC.

                                   