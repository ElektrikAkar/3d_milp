% dQ Approximation
%
% Author: VK
% Date  : ?
%
% Variable indexing, 
% N1 = Px, 
% N2 = SOCx, 
% N3 = Tx 

sdpv.bat.thermal_approx.dQ = reshape(sdpv.bat.approx_common.w,[],arbj.Nh)'*data.segm.dQcell_Pt(:);

% for ijk = 1:arbj.Nh
%     const = [const, ...
%         sdpv.bat.thermal_approx.dQ(ijk) == sum(sum(sum(  data.segm.dQcell_Pt.*sdpv.bat.approx_common.w(:,:,:,ijk)  )))  ];
%     
% end
