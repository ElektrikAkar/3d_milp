% Function definitions! 
% Author : VK
% Date   : ?
% Update : 2020.07.05

func.eff.P_AC_in_kW  = @(x) interp1(data.efficiency.P_AC_in_kW,  data.efficiency.P_loss_in_kW, x, 'linear', 'extrap');
func.eff.P_AC_out_kW = @(x) interp1(data.efficiency.P_AC_out_kW, data.efficiency.P_loss_out_kW,x, 'linear', 'extrap');

%%

func.sum3     = @(x) sum(sum(sum(x))); % Since YALMIP does not work with sum(X,'all')

%func.Vdot.rack_fan = @(W) param.fan.rack.V_dot_nom*(W/param.fan.rack.P_nom).^3; % [m^3/s]

%func.Qconv.rack_fan = @(W,Tc) func.Vdot.rack_fan(W).*param.c_p_air*param.rho_air*(Tc+KELVIN);  % Eq. 22  [(m^3/s)*(J/(kg K))*(kg/m^3)*K] = [(1/s)*J] = [W]

func.U_hys      = @(SOC_pu)    interp1(data.SOC,data.U_hys, SOC_pu);          % U_hys at T = 25C 
func.U_OCV      = @(SOC_pu)    interp1(data.U_OCV.SOC,data.U_OCV.V, SOC_pu);  % U_OCV at T = 25C 

func.dS         = @(SOC_pu)    interp1(data.SOC,data.dS,SOC_pu);     % dS at T = 25C 
 
func.Ri_Ch      = @(SOC_pu,Tk) interp22(data.SOC,data.T,data.Ri_Ch, SOC_pu,  Tk);
func.Ri_Disch   = @(SOC_pu,Tk) interp22(data.SOC,data.T,data.Ri_Disch, SOC_pu,  Tk);


func.dU_Ch      = @(I,SOC_pu,Tk) I.*func.Ri_Ch(SOC_pu,Tk)       + sign(I).*func.U_hys(SOC_pu);
func.dU_Disch   = @(I,SOC_pu,Tk) I.*func.Ri_Disch(SOC_pu,Tk)    + sign(I).*func.U_hys(SOC_pu);
    
func.dU         = @(I,SOC_pu,Tk)  ((I>0).*func.dU_Ch(I,SOC_pu,Tk) + (I<0).*func.dU_Disch(I,SOC_pu,Tk));

func.dU2_Uk     = @(U,SOC_pu)  U - func.U_OCV(SOC_pu);      % dU2 for known Uk; 

func.dQcell     = @(I,SOC_pu,Tk) I.*(func.dU(I,SOC_pu,Tk)+ Tk.*func.dS(SOC_pu));


func.dTcell     = @(I,SOC_pu,Tk,Tk_ambient) (1/(param.m_cell*param.c_p_cell))*...
                  ( (Tk_ambient-Tk)*param.cell.alpha.fan_100*param.A_cell + func.dQcell(I,SOC_pu,Tk) );

func.dTcell0    = @(I,SOC_pu,Tk) func.dTcell(I,SOC_pu,Tk, param.T_ambient_0);                            

func.It         = @(P_t,SOC_pu,Tk) VK_solver(P_t,SOC_pu,Tk,func.U_OCV,func.dU);

func.It_to_Pt   = @(I_t,SOC_pu,Tk) I_t.*(func.U_OCV(SOC_pu)+func.dU(I_t,SOC_pu,Tk));
      

func.dQcell_Pt  = @(P_t,SOC_pu,Tk) func.dQcell(func.It(P_t,SOC_pu,Tk),SOC_pu,Tk);
func.dTcell0_Pt = @(P_t,SOC_pu,Tk) func.dTcell0(func.It(P_t,SOC_pu,Tk),SOC_pu,Tk);

% (T_ambient - T_cell)  alpha*A  + P_loss*k_cell  =(m*c_p)  d T_cell / dt  
% (T_ambient - T_cell)  alpha*A  + dQcell         =(m*c_p)  d T_cell / dt 

% d T_cell / dt  = (1/(m*c_p)) (T_ambient - T_cell)  alpha*A  + dQcell 

func.PkW_to_Pt = @(P_all) P_all*1e3/(param.n_cell_per_block*param.n_block_per_module*param.n_module_per_rack*param.n_rack); % kW power to cell power in W
func.Pt_to_PkW = @(P_t) P_t*(param.n_cell_per_block*param.n_block_per_module*param.n_module_per_rack*param.n_rack)/1e3; % kW power to cell power in W

func.cyc_aging_ch = @(P_t,SOC_pu,Tk) interp1(data.aging_per_dth(:,1),data.aging_per_dth(:,2),max(func.It(P_t,SOC_pu,Tk),0)/3); % 3 Ah is the nominal, max to eliminate negative
                                  
% func.Ut_It = @(P_t,SOC_pu,Tk) fsolve((@(UI) [10*(UI(1)*UI(2) - P_t); 1000*(func.U_OCV(SOC_pu) + func.dU(UI(2),SOC_pu,Tk) - UI(1))]),...

func.only_PE_loss = @(PE_in_kW)      interp1(data.only_PE_loss.P_AC_kW,data.only_PE_loss.P_loss_kW,PE_in_kW);


%% Some special functions for nonsv: 

if(SimulSettings.nonsv.effName=="pe_loss" || SimulSettings.nonsv.effName=="combined")
    func.nonsv.only_PE_loss = @(PE_in_kW) func.only_PE_loss(PE_in_kW);
else
    func.nonsv.only_PE_loss = @(PE_in_kW) 0;
end

%%
%Schimpe ECS paper cycle aging: 
func.k_cyc_high_T = @(I,Tk) ones(size(I)).*(param.cyc.k_cyc_high_T_ref * exp( -(param.cyc.Ea_cyc_high_T/param.cal.R_g)*(1./Tk - 1/param.cal.T_ref))); % I is unused.

func.k_cyc_low_T = @(I,Tk) (I>=0).*(param.cyc.k_cyc_low_T_ref*...   % I>0 here because it is only valid for I_ch
                                    exp( (param.cyc.Ea_cyc_low_T/param.cal.R_g)*(1./Tk - 1/param.cal.T_ref)).*...
                                    exp(param.cyc.beta_low_T* (I - param.cyc.I_ch_ref )/param.cyc.C0)    );
                                
                                
func.k_cyc_low_T_high_SOC = @(I,SOC_pu,Tk) (SOC_pu>=param.cyc.SOCref).*(I>=0).*(param.cyc.k_cyc_low_T_high_SOC_ref.*...   % I>0 here because it is only valid for I_ch
                                            exp(  (param.cyc.Ea_cyc_low_T_high_SOC/param.cal.R_g)*(1./Tk - 1/param.cal.T_ref) +...\
                                            param.cyc.beta_low_T_high_SOC*(I - param.cyc.I_ch_ref)/param.cyc.C0             ));
                                        

                                        
%% Create segmentation data:
data.segm = func_create_segmentation(SimulSettings, func, param, false);

