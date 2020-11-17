% This comes from Schimpe's paper. SOH is not calculated rather cost is
% calculated at each point. 
%
% Author: VK
% Date  : ?

data.segm.cost_combined_by_t_EOL =  arbj.bat.Cost_whole./data.segm.t_EOL_h; % per hour cost. 

sdpv.bat.aging_approx.COSTall = sdpvar(arbj.Nh,1);

for ijk = 1:arbj.Nh
    sdpv.const = [sdpv.const, ...
        sdpv.bat.aging_approx.COSTall(ijk) == func.sum3(  data.segm.cost_combined_by_t_EOL.*sdpv.bat.approx_common.w(:,:,:,ijk)  )  ];

end




 
