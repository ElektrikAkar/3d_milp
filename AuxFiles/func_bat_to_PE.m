function P_AC = func_bat_to_PE(P_batt,PE_loss_fun,data_segm_P_AC_kW)
% This function finds AC-side power from battery power. 

% Pbat is always less than P_AC

if(P_batt<0)
    upper_bound = 0;
else
    upper_bound = data_segm_P_AC_kW(end);
end
    lower_bound = P_batt;
    
    P_AC_guess = P_batt + PE_loss_fun(P_batt);
    P_loss = PE_loss_fun(P_AC_guess);
    
    P_batt_guess = P_AC_guess - P_loss;
    
    while (abs(P_batt_guess-P_batt)>1e-5)
        
    if(P_batt_guess>=P_batt)
        upper_bound  = P_AC_guess;
    else
        lower_bound  = P_AC_guess;
    end
    
    
    P_AC_guess  =  (lower_bound + upper_bound)/2;
    P_loss       = PE_loss_fun(P_AC_guess);
    P_batt_guess = P_AC_guess - P_loss;
    end
    
    P_AC = P_AC_guess;
end