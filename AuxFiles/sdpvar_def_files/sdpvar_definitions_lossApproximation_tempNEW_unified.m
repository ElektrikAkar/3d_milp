% Loss approximation. 


try
data.approx = csvread(('CSVs\PWA_eff_'+effName+'.csv'),2);
catch
error('Check if your efficiency approximation data file realy exists!');    
end

%Define a weight for the 

sdpv.AC.new_approx.w = sdpvar(length(data.segm.P_AC_kW),arbj.Nh);

sdpv.AC.new_approx.w_convex = sdpvar(5,arbj.Nh);




sdpv.const = [sdpv.const, ...
    1>=sdpv.AC.new_approx.w>=0];


for ii=1:arbj.Nh
  %  sdpv.const = [sdpv.const, ...
  %      sos2(sdpv.AC.new_approx.w(:,ii))];
    
    sdpv.const = [sdpv.const, ...
        sum(sdpv.AC.new_approx.w(:,ii))==1];
    
    sdpv.const = [sdpv.const, ...
        sdpv.AC.new_approx.w_convex(1,ii) == sum(sdpv.AC.new_approx.w(1:3,ii))];
    sdpv.const = [sdpv.const, ...
        sdpv.AC.new_approx.w_convex(2:4,ii) == (sdpv.AC.new_approx.w(4:6,ii))];
    sdpv.const = [sdpv.const, ...
        sdpv.AC.new_approx.w_convex(5,ii) == sum(sdpv.AC.new_approx.w(7:10,ii))];
    
    if(c_kWh(ii)>0)
    sdpv.const = [sdpv.const, ...
        sos2(sdpv.AC.new_approx.w_convex(:,ii))];
    else
    sdpv.const = [sdpv.const, ...
         sos2(sdpv.AC.new_approx.w(:,ii))];    
    end
end







sdpv.const = [sdpv.const, ...
	sdpv.AC.Pcharge   ==(   data.segm.P_AC_kW(data.segm.P_AC_zero:length(data.segm.P_AC_kW))'*sdpv.AC.new_approx.w(data.segm.P_AC_zero:length(data.segm.P_AC_kW),:)     )'];

sdpv.const = [sdpv.const, ...
	sdpv.AC.Pdischarge ==-(data.segm.P_AC_kW(1:data.segm.P_AC_zero)'*sdpv.AC.new_approx.w(1:data.segm.P_AC_zero,:) )'];

sdpv.const = [sdpv.const, ...
	sdpv.AC.Pnett      == (data.segm.P_AC_kW'*sdpv.AC.new_approx.w)'];


% Total must be equal to the loss variable. 


sdpv.AC.Pch_loss        = (data.segm.P_AC_loss_kW(data.segm.P_AC_zero:length(data.segm.P_AC_kW))'*sdpv.AC.new_approx.w(data.segm.P_AC_zero:length(data.segm.P_AC_kW),:))';
sdpv.AC.Pdisch_loss     = (data.segm.P_AC_loss_kW(1:data.segm.P_AC_zero)'*sdpv.AC.new_approx.w(1:data.segm.P_AC_zero,:) )';

sdpv.const = [sdpv.const, ...
	sdpv.AC.P_loss==(data.segm.P_AC_loss_kW'*sdpv.AC.new_approx.w)'];

%% Manual inspections:
% PAC_in_kW (positive) vs P_loss_in (W)
% Breakpoint is 8-9th element. Which happens to be 0.2880 kW. 
% Linear model Poly1:
%      f(x) = p1*x + p2
% Coefficients (with 95% confidence bounds):
%        p1 =        1000  (1000, 1000)
%        p2 =   9.173e-15  (7.067e-15, 1.128e-14)
% 
% Goodness of fit:
%   SSE: 3.315e-27
%   R-square: 1
%   Adjusted R-square: 1
%   RMSE: 1.663e-15

% Linear model Poly5:
%      f(x) = p1*x^5 + p2*x^4 + p3*x^3 + p4*x^2 + p5*x + p6
% Coefficients (with 95% confidence bounds):
%        p1 =  -1.295e-05  (-1.348e-05, -1.241e-05)
%        p2 =    0.001365  (0.001306, 0.001424)
%        p3 =    -0.05574  (-0.05806, -0.05341)
%        p4 =       2.371  (2.331, 2.411)
%        p5 =      0.1892  (-0.097, 0.4755)
%        p6 =       277.4  (276.8, 278)
% 
% Goodness of fit:
%   SSE: 3280
%   R-square: 1
%   Adjusted R-square: 1
%   RMSE: 1.657


%% P_AC_out


% General model Rat53:
%      f(x) = 
%                (p1*x^5 + p2*x^4 + p3*x^3 + p4*x^2 + p5*x + p6) /
%                (x^3 + q1*x^2 + q2*x + q3)
% Coefficients (with 95% confidence bounds):
%        p1 =       -4994  (-9.989e+07, 9.988e+07)
%        p2 =   4.695e+06  (-9.388e+10, 9.389e+10)
%        p3 =   7.494e+06  (-1.498e+11, 1.499e+11)
%        p4 =   7.239e+08  (-1.447e+13, 1.447e+13)
%        p5 =  -3.598e+07  (-7.196e+11, 7.195e+11)
%        p6 =  -6.029e+04  (-1.205e+09, 1.205e+09)
%        q1 =   2.644e+06  (-5.287e+10, 5.287e+10)
%        q2 =   6.009e+05  (-1.202e+10, 1.202e+10)
%        q3 =  -3.811e+04  (-7.621e+08, 7.62e+08)
% 
% Goodness of fit:
%   SSE: 1.135e+04
%   R-square: 1
%   Adjusted R-square: 1
%   RMSE: 3.086
