% This file runs the optimization procedure. 
% Author: VK
% Date  : ? 

if(SimulSettings.OptMode=="Once")
    optimize(sdpv.const,sdpv.J,sdpvarSettings); %This takes time.
    
    sol.sdpv            = sdpvar_to_sol(sdpv);
    sol.binv            = sdpvar_to_sol(binv);
    sol.Jstep           = value(Jstep);
    sol.Jstep           = value(Jstep);
    sol.Jstep.all       = value(Jstep.all);
    sol.Jstep.AC_power  = value(Jstep.AC_power);
    sol.Jstep.Aging     = value(Jstep.Aging);
    
elseif(SimulSettings.OptMode =="Optimizer")
    %---------------------------------
    nonsvSettings;
    % nonsv.initialized=0;
    run_observer; % For initialization.
    printSettings(SimulSettings)
    while(p_loop <= SimulSettings.p_loop_len)
        
        c_kWh_now = c_kWh((p_loop-1)*arbj.Nh_control+(1:arbj.Nh));
        nowInput = {c_kWh_now,  nonsv.bat.C_nom(nonsv.i),   nonsv.bat.Tk(nonsv.i),  nonsv.bat.C_batt_for_optimizer};
        optResults = sdpv.optimizer( nowInput ); 
        
        sol =  optResults_to_sol(optResults, SimulSettings.optimizerOutputNames);
        
        run_observer;
        fprintf('<strong> Loop %d of %d is completed.</strong>\n',p_loop, SimulSettings.p_loop_len);
        p_loop = p_loop+1;
        
        tempAllvariables = who;
        tempAllvariables_str = string(tempAllvariables);
        tempAllvariables(tempAllvariables_str=="sdpv"|tempAllvariables_str=="init"|tempAllvariables_str=="sdpvarSettings"|tempAllvariables_str=="binv"|tempAllvariables_str=="func") = [];
        
        if(mod(p_loop,1)==0)
            back_up(SimulSettings.path.checkpoints.current);
            pause(0.2);
            save(SimulSettings.path.checkpoints.current, tempAllvariables{:});
        end
    end
    
    tempAllvariables = who;
    tempAllvariables_str = string(tempAllvariables);
    tempAllvariables(tempAllvariables_str=="sdpv"|tempAllvariables_str=="init"|tempAllvariables_str=="sdpvarSettings"|tempAllvariables_str=="binv"|tempAllvariables_str=="func") = [];
    
    save(SimulSettings.SaveFilePath, tempAllvariables{:});
    
    %     figure;
    %     %     plot((0:arbj.dth:(arbj.Nh*arbj.dth))',(optResults{2}-KELVIN));
    %     %     hold on;
    %     plot((0:nonsv.dth:nonsv.Nh*nonsv.dth)',nonsv.bat.Tk-KELVIN);
    %     title('Temperature Nonsv');
    %     %     legend('Simul','Nonsv');
    %
    %
    %
    %
    %     figure;
    %     stairs(nonsv.AC.Pnett);
    %     hold on;
    %
    %     %
    %     figure;
    %     plot(nonsv.bat.dSOHcal); hold on;
    %     plot(nonsv.bat.dSOHcyc);
    %     legend('cal','cyc');
    %     title('aging');
    %
    %     figure;
    %     plot(nonsv.bat.SOH);
    %     title('SOH');
    
%     figure;
%     plot(nonsv.bat.SOC);
%     title('SOC Nonsv');
%     hold on;
%     plot(nonsv.bat.I_cell/3);

end