% I_cell approximation.
%
% Author: VK
% Date  : ?
%
% Variable indexing, 
% N1 = Px, 
% N2 = SOCx, 
% N3 = Tx 


%sdpv.bat.thermal_approx.w = sdpvar(data.segm.P.n+1, data.segm.SOC.n+1,  data.segm.T.n+1, arbj.Nh);

sdpv.bat.I_cell        = reshape(sdpv.bat.approx_common.w,[],arbj.Nh)'*data.segm.I_cell_Pt(:);
%sdpv.bat.I_cell_ch     = reshape(sdpv.bat.approx_common.w(data.segm.P.zero:(data.segm.P.n+1),:,:,:),[],arbj.Nh)'*reshape(data.segm.I_cell(data.segm.P.zero:(data.segm.P.n+1),:,:),[],1);
%sdpv.bat.I_cell_disch  = -reshape(sdpv.bat.approx_common.w(1:data.segm.P.zero,:,:,:),[],arbj.Nh)'*reshape(data.segm.I_cell(1:data.segm.P.zero,:,:),[],1);

%sdpv.bat.I_cell_abs    = sdpv.bat.I_cell_ch+sdpv.bat.I_cell_disch;



% 
% sdpv.bat.C_rate_ch    = sdpv.bat.I_cell_ch/arbj.bat.C_nom;
% sdpv.bat.C_rate_dsch  = sdpv.bat.I_cell_disch/arbj.bat.C_nom;

%-----------------------------------------
% C-rate constraints: 
% const = [const, ...
% 	  0<=sdpv.bat.C_rate_ch  <= arbj.bat.C_rate_ch]; 
% 
% const = [const, ...
% 	  0<=sdpv.bat.C_rate_dsch<= arbj.bat.C_rate_dsch]; 

sdpv.const = [sdpv.const, ...
	  -arbj.bat.C_rate_dsch<=sdpv.bat.I_cell/init.bat.C_nom<= arbj.bat.C_rate_ch]; 
