if SimulSettings.Plot_Input_Data
    figure;
    plot(eta_in);
    hold on;
    plot(eta_out);
    grid on;
    legend('\eta_{in}','\eta_{out}')
    figure;
    plot(P_AC_in,P_Batt_in);
    hold on;
    plot(P_AC_out,P_Batt_out);
    grid on;
    legend('P^{Batt}_{in}','P^{Batt}_{out}')
end