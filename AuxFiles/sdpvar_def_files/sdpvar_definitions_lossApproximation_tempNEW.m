% Loss approximation. 
%
% Author: VK
% Date  : ?

% try
% data.approx = csvread(('CSVs\PWA_eff_'+effName+'.csv'),2);
% catch
% error('Check if your efficiency approximation data file realy exists!');    
% end

%Define a weight for the 

if(SimulSettings.effName=="no_loss" || SimulSettings.effName=="bat_loss") %no power electronics loss here. 
   sdpv.const = [sdpv.const, ...
        sdpv.AC.P_loss==0]; 

   sdpv.AC.Pch_loss     = zeros(arbj.Nh,1);
   sdpv.AC.Pdisch_loss  = zeros(arbj.Nh,1);
else % adding power electronics loss here. 
    sdpv.AC.new_approx.w = sdpvar(length(data.segm.P_AC_kW),arbj.Nh);
    
    sdpv.const = [sdpv.const, ...
        1>=sdpv.AC.new_approx.w>=0];
    
% % %     
% % %     for ii=1:arbj.Nh
% % %         sdpv.const = [sdpv.const, ...
% % %             sos2(sdpv.AC.new_approx.w(:,ii))];
% % %         
% % %         sdpv.const = [sdpv.const, ...
% % %             sum(sdpv.AC.new_approx.w(:,ii))==1];
% % %     end

% Creating a log-formula instead of SOS!
grayAC = findGrayWeightIndicators(length(data.segm.P_AC_kW)-1,0,0);

binv.AC.mu_LOG = binvar(grayAC.nt,arbj.Nh,'full');

sdpv.const = [sdpv.const, ...
    sum(sdpv.AC.new_approx.w)==1];

    for ijk=1:arbj.Nh   
%         0     0     0     0
%         1     0     0     0
%         1     1     0     0
%         0     1     0     0
%         0     1     1     0
%         1     1     1     0
%         1     0     1     0
%         0     0     1     0
%         0     0     1     1
%         sdpv.const = [sdpv.const, ...
%             (1-binv.AC.mu_LOG(1,ijk))>= binv.AC.mu_LOG(4,ijk)];
%         sdpv.const = [sdpv.const, ...
%             (1-binv.AC.mu_LOG(2,ijk))>= binv.AC.mu_LOG(4,ijk)];    
%         sdpv.const = [sdpv.const, ...
%             (binv.AC.mu_LOG(3,ijk))>= binv.AC.mu_LOG(4,ijk)];     
%----------------------------------------------------------
        for iOut=1:grayAC.nt
            % A loop over the new binary variables.
            temp = sdpv.AC.new_approx.w(:,ijk);
            %delta
            sdpv.const = [sdpv.const, ...
                sum( temp(grayAC.delta{iOut})  )  <=( binv.AC.mu_LOG(iOut,ijk)  )];
            %1-delta
            sdpv.const = [sdpv.const, ...
                sum( temp(grayAC.one_min_delta{iOut})  )  <=( 1 - binv.AC.mu_LOG(iOut,ijk)  )];
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
end


