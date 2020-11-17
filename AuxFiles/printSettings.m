function [] = printSettings(SimulSettings)
% This function prints settings for a visual check. 
% Author: VK
% Created on 2020.04.11
fprintf('\n\n------------------------------------\n');
fprintf('Nh_all = %d hours, %s days.\nNh = %4.2f hours\nNc = %s hours.\n',...
        SimulSettings.noDays_all*24, strtrim(rats(SimulSettings.noDays_all)) , SimulSettings.noDays*24, strtrim(rats(SimulSettings.noDays_control*24)));
    
    
fprintf("\nEfficiency:  " + SimulSettings.effName + "\n");
fprintf("Temperature: " + SimulSettings.tempMode + "\n");
fprintf("SOC:         " + SimulSettings.SOCmode + "\n");
fprintf("DataName:    " + SimulSettings.dataName + "\n");

fprintf('\n');
%fprintf("p_loop:    " + SimulSettings.dataName + "\n");
fprintf('------------------------------------\n\n');

end