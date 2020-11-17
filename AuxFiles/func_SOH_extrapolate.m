function ext = func_SOH_extrapolate(data, SOH_fitting)
% Author: Vk
% Date  : 2020.08.16
SOH_EOL = 80;


num_points = 500;  % number of points for extrapolation.
num_simul  = 1000; % number of points for simul data. 

i = find(data.nonsv.bat.SOH==0,1)-1; % Find the last element.

if(isempty(i))
    i = length(data.nonsv.bat.SOH);
end

t_h = (0:data.nonsv.dth:((i-1)*data.nonsv.dth))';
t_y = t_h/24/365;

indices = round(linspace(1, i, num_simul));


if (SOH_fitting == "one" || SOH_fitting == "two")
    is_one = SOH_fitting == "one";
    [ext.SOH_fit, ext.SOH_gof] = create_agingFit(t_y, 100*data.nonsv.bat.SOH(1:i), is_one);
    fprintf('Goodness of SOH fitting: %4.2f%%\n',ext.SOH_gof.adjrsquare*100);
elseif (SOH_fitting == "sep" || SOH_fitting == "sep1" || SOH_fitting == "sep2")
    is_one      =  SOH_fitting == "sep1";
    ext.FEC     = [0; 0.5*cumsum(abs(diff(data.nonsv.bat.SOC(1:i))))];
    ext.dSOHcal = [0; 100*data.nonsv.bat.dSOHcal(1:i-1)];
    ext.dSOHcyc = [0; 100*data.nonsv.bat.dSOHcyc(1:i-1)];
    
    ext.FEC_c   = ext.FEC(end)/t_y(end);
    
    [ext.dSOHcal_fit, ext.dSOHcal_gof] = create_agingFit(t_y, ext.dSOHcal, is_one);
    [ext.dSOHcyc_fit, ext.dSOHcyc_gof] = create_agingFit(ext.FEC, ext.dSOHcyc, is_one);
    
    fprintf('Goodness of dSOHcal fitting: %4.2f%%\n',ext.dSOHcal_gof.adjrsquare*100);
    fprintf('Goodness of dSOHcyc fitting: %4.2f%%\n',ext.dSOHcyc_gof.adjrsquare*100);
    ext.SOH_fit     = @(t_y0) 100 - ext.dSOHcal_fit(t_y0) - ext.dSOHcyc_fit(ext.FEC_c*t_y0);
end
    ext.t_EOL_y = fsolve(@(x) ext.SOH_fit(x)-SOH_EOL, 6, optimset('Display','off'));
    ext.t_ext_y = linspace(t_y(end), ext.t_EOL_y, num_points)';
    
    ext.SOH_ext = ext.SOH_fit(ext.t_ext_y);
    ext.t_y     = t_y(indices);
    ext.SOH     = 100*data.nonsv.bat.SOH(indices);    


end