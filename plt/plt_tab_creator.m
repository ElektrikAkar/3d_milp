function [tab] = plt_tab_creator(results, func, plt_path, plt_save)
%% Table Calculator:

for fld=fields(results)'
    thisCase    = [];
    thisResults = results.(fld{1});
    
    thisCase.mean_SOC = 100*mean(thisResults.nonsv.bat.SOC);  % [%]
    thisCase.mean_Tc  = mean(thisResults.nonsv.bat.Tk) - KELVIN; % Celsius
    thisCase.k  = round(thisResults.arbj.dth/thisResults.nonsv.dth);
    thisCase.c_kWh = thisResults.c_kWh(1:thisResults.arbj.Nh_all);
    thisCase.c_kWh_repl = repelem(thisCase.c_kWh, thisCase.k);
    
    thisCase.n = length(thisResults.nonsv.bat.I_cell);
    MovMean = spdiags(0.5*ones(thisCase.n+1, 2), 0:1, thisCase.n, thisCase.n+1);
    
    thisCase.MovMean.SOC = MovMean*thisResults.nonsv.bat.SOC;
    thisCase.MovMean.Tk  = MovMean*thisResults.nonsv.bat.Tk;
    
    thisCase.t_EOL_h = func_solve_quad_eq(thisResults.nonsv.bat.I_cell, thisCase.MovMean.SOC, thisCase.MovMean.Tk, func, false, true).t_EOL_h;
    
    thisCase.t_EOL_h_cal = func_solve_quad_eq(thisResults.nonsv.bat.I_cell, thisCase.MovMean.SOC, thisCase.MovMean.Tk, func, false, true, "cal").t_EOL_h;
    thisCase.t_EOL_h_cyc = func_solve_quad_eq(thisResults.nonsv.bat.I_cell, thisCase.MovMean.SOC, thisCase.MovMean.Tk, func, false, true, "cyc").t_EOL_h;
    
    thisCase.batteryApproxCost_cal = sum(thisResults.nonsv.dth*thisResults.arbj.bat.Cost_whole./thisCase.t_EOL_h_cal);
    thisCase.batteryApproxCost_cyc = sum(thisResults.nonsv.dth*thisResults.arbj.bat.Cost_whole./thisCase.t_EOL_h_cyc);
    
    thisCase.batteryApproxCost = sum(thisResults.nonsv.dth*thisResults.arbj.bat.Cost_whole./thisCase.t_EOL_h);
    thisCase.revenue = -sum(thisResults.nonsv.AC.Pnett.*thisCase.c_kWh_repl)*thisResults.nonsv.dth;
    
    thisCase.ChargeThroughput = norm(thisResults.nonsv.bat.I_cell,1)*thisResults.nonsv.dth; % Ah
    
    thisCase.FEC = 0.5*sum(abs(diff(thisResults.nonsv.bat.SOC))); % Calculating over C-rate version or this version
    % makes only a minor difference such as : 173.8597 vs 173.8574 
    
    thisCase.SOH     = 100*thisResults.nonsv.bat.SOH(end);
    thisCase.dSOHcal = 100*thisResults.nonsv.bat.dSOHcal(end); % % 
    thisCase.dSOHcyc = 100*thisResults.nonsv.bat.dSOHcyc(end); % %
    thisCase.dSOH    = 100*( 1- thisResults.nonsv.bat.SOH(end) ); % %
    
    thisCase.batteryCost = thisResults.arbj.bat.Cost_pu * thisCase.dSOH/100;
    
    thisCase.netProfit   =  thisCase.revenue - thisCase.batteryApproxCost;
    
    thisCase.cell_loss = thisResults.nonsv.bat.I_cell.*func.dU(thisResults.nonsv.bat.I_cell, thisCase.MovMean.SOC, thisCase.MovMean.Tk);
    thisCase.bat_loss  = thisCase.cell_loss *thisResults.param.n_cell/1e3; % / kW 
    
    thisCase.bat_money_loss = max(thisCase.c_kWh_repl,0).*thisCase.bat_loss*thisResults.nonsv.dth;
    thisCase.bat_money_loss_sum = sum(thisCase.bat_money_loss);
    
    thisCase.PE_money_loss = max(thisCase.c_kWh_repl,0).*thisResults.nonsv.AC.P_loss*thisResults.nonsv.dth;
    thisCase.PE_money_loss_sum = sum(thisCase.PE_money_loss);
    
    thisCase.revenue_gross = thisCase.PE_money_loss_sum + thisCase.bat_money_loss_sum + thisCase.revenue;
    
    thisCase.eff_ch_bin    = thisResults.nonsv.AC.Pnett > 0;
    thisCase.eff_disch_bin = thisResults.nonsv.AC.Pnett < 0;
    
    thisCase.ch_loss    = thisResults.nonsv.AC.P_loss(thisCase.eff_ch_bin) + thisCase.bat_loss(thisCase.eff_ch_bin);
    thisCase.disch_loss = thisResults.nonsv.AC.P_loss(thisCase.eff_disch_bin) + thisCase.bat_loss(thisCase.eff_disch_bin);
    
    thisCase.ch_out = sum(thisResults.nonsv.AC.Pnett(thisCase.eff_ch_bin) - thisCase.ch_loss);
    thisCase.ch_in  = sum(thisResults.nonsv.AC.Pnett(thisCase.eff_ch_bin));
    
    thisCase.disch_out = sum(thisResults.nonsv.AC.Pnett(thisCase.eff_disch_bin));
    thisCase.disch_in  = sum(thisResults.nonsv.AC.Pnett(thisCase.eff_disch_bin)- thisCase.disch_loss);
    
    thisCase.eff_ch    = 100*thisCase.ch_out/thisCase.ch_in;
    thisCase.eff_disch = 100*thisCase.disch_out/thisCase.disch_in;
    
    thisCase.eff_roundtrip = 100*(thisCase.ch_out + abs(thisCase.disch_out))/( thisCase.ch_in + abs(thisCase.disch_in));
    
    
    tab.(fld{1}) = thisCase;
end


end