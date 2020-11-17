% This is for delta T approximation using PWA.
%
% Author: VK
% Date  : ?

% 3D delta T approximation! 

% Variable indexing, 
% N1 = Px, 
% N2 = SOCx, 
% N3 = Tx 


%sdpv.bat.thermal_approx.w = sdpvar(data.segm.P.n+1, data.segm.SOC.n+1,  data.segm.T.n+1, arbj.Nh);

sdpv.bat.thermal_approx.dT = sdpvar(arbj.Nh,1);

sdpv.const = [sdpv.const, ...
    sdpv.bat.thermal_approx.dT == squeeze(func.sum3( repmat(data.segm.dTcell0_Pt, 1,1,1,arbj.Nh)  .*sdpv.bat.approx_common.w  ))  ];

% for ijk = 1:arbj.Nh
%     const = [const, ...
%         sdpv.bat.thermal_approx.dT(ijk) == sum(sum(sum(  data.segm.dTcell0_Pt.*sdpv.bat.approx_common.w(:,:,:,ijk)  )))  ];
% 
% end
% 
