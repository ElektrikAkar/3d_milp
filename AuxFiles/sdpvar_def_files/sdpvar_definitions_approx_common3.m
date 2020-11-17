%2010 - Paper after Eq. 48,

% binv.bat.approx_common.mu_P   = binvar(data.segm.P.n,  arbj.Nh,'full'); %BATTERY cell power.
% binv.bat.approx_common.mu_SOC = binvar(data.segm.SOC.n,arbj.Nh,'full');
% binv.bat.approx_common.mu_T   = binvar(data.segm.T.n,  arbj.Nh,'full');

arbj.approx_common.t1 = 1:(data.segm.P.n   + data.segm.SOC.n  +1); %N1+N2
arbj.approx_common.t2 = 1:(data.segm.P.n   + data.segm.T.n    +1); %N1+N3
arbj.approx_common.t3 = 1:(data.segm.SOC.n + data.segm.T.n    +1); %N2+N3

arbj.approx_common.N1 = (data.segm.P.n);
arbj.approx_common.N2 = (data.segm.SOC.n);
arbj.approx_common.N3 = (data.segm.T.n);

sdpv.bat.approx_common.w = sdpvar(data.segm.P.n+1, data.segm.SOC.n+1,  data.segm.T.n+1, arbj.Nh);



sdpv.bat.approx_common.Omega_t1 = sdpvar(length(arbj.approx_common.t1),arbj.Nh);
sdpv.bat.approx_common.Omega_t2 = sdpvar(length(arbj.approx_common.t2),arbj.Nh);
sdpv.bat.approx_common.Omega_t3 = sdpvar(length(arbj.approx_common.t3),arbj.Nh);

arbj.approx_common.t1_indiceset = {};
ijk = 1;
    for t_temp = (arbj.approx_common.t1-1)
        
        temp_LU = max(0,arbj.approx_common.N1 - t_temp); % N1 - t1
        temp_UU = min((arbj.approx_common.N2 + arbj.approx_common.N1 - t_temp),arbj.approx_common.N1);
        i_CalAging = (temp_LU:temp_UU)+1; % this is i 
        
        t_temp2 = t_temp + 1; % Index transformation!
        
        j_temp  = i_CalAging -(arbj.approx_common.N1 +1 ) + t_temp2; % This is j
        
   %     temp_Omega = 0;
        
      %  temp_Omega_ind = false(size(sdpv.bat.approx_common.w));
        temp_Omega_ind = {};
     %   fprintf('place\n');
        for p_temp = 1:length(j_temp)
          %  temp_Omega_ind(i_CalAging(p_temp),j_temp(p_temp),:,ijk) = true;
          temp_Omega_ind{p_temp} = {i_CalAging(p_temp),j_temp(p_temp),':'};
        end 
        arbj.approx_common.t1_indiceset{t_temp+1} = temp_Omega_ind;
    end

    
%%    
gray = findGrayWeightIndicators(data.segm.P.n,data.segm.SOC.n,data.segm.T.n); % New logaritmic partitioning.

binv.bat.approx_common.mu_LOG   = binvar(gray.nt,arbj.Nh,'full'); %logaritmic modelling. 


sdpv.bat.Pcell_approx         = sdpvar(arbj.Nh,1,'full');
sdpv.bat.Pcell_ch_approx      = sdpvar(arbj.Nh,1,'full');
sdpv.bat.Pcell_disch_approx   = sdpvar(arbj.Nh,1,'full');





sdpv.const = [sdpv.const, ...
    sum(sdpv.bat.approx_common.Omega_t1,1)==1]; %(:,ijk)
sdpv.const = [sdpv.const, ...
    sum(sdpv.bat.approx_common.Omega_t2,1)==1]; %(:,ijk)
sdpv.const = [sdpv.const, ...
    sum(sdpv.bat.approx_common.Omega_t3,1)==1]; %(:,ijk)

sdpv.const = [sdpv.const, ...
    1>=sdpv.bat.approx_common.w>=0];

for ijk = 1:arbj.Nh
    
    for t_temp = (arbj.approx_common.t1-1)
        
        temp_LU = max(0,arbj.approx_common.N1 - t_temp); % N1 - t1
        temp_UU = min((arbj.approx_common.N2 + arbj.approx_common.N1 - t_temp),arbj.approx_common.N1);
        i_CalAging = (temp_LU:temp_UU)+1; % this is i 
        
        t_temp2 = t_temp + 1; % Index transformation!
        
        j_temp  = i_CalAging -(arbj.approx_common.N1 +1 ) + t_temp2; % This is j
        
   %     temp_Omega = 0;
        
        temp_Omega_ind = false(size(sdpv.bat.approx_common.w));
        
     %   fprintf('place\n');
        for p_temp = 1:length(j_temp)
            temp_Omega_ind(i_CalAging(p_temp),j_temp(p_temp),:,ijk) = true;
        end 
        temp_Omega = sdpv.bat.approx_common.w(temp_Omega_ind);
        
        
        
%         for p_temp = 1:length(j_temp)
%             temp_Omega = temp_Omega + sum(sdpv.bat.approx_common.w(i_CalAging(p_temp),j_temp(p_temp),:,ijk)); %::::::::
%         end

        sdpv.const = [sdpv.const, ...
            sdpv.bat.approx_common.Omega_t1(t_temp2,ijk) == sum(temp_Omega(:))];
    end

    %----------------------
    for t_temp = (arbj.approx_common.t2-1)
        
        temp_LU = max(0,arbj.approx_common.N1 - t_temp); % N1 - t1
        temp_UU = min((arbj.approx_common.N3+arbj.approx_common.N1 - t_temp),arbj.approx_common.N1);
        i_CalAging = (temp_LU:temp_UU)+1;  % this is i
        
        t_temp2 = t_temp + 1; % Index transformation!
        
        j_temp  = i_CalAging -(arbj.approx_common.N1 +1 ) + t_temp2; % this is k
        
        temp_Omega_ind = false(size(sdpv.bat.approx_common.w));
        for p_temp = 1:length(j_temp)
            temp_Omega_ind(i_CalAging(p_temp),:,j_temp(p_temp),ijk) = true;
        end        
        
%         for p_temp = 1:length(j_temp)
%             temp_Omega = temp_Omega + sum(sdpv.bat.approx_common.w(i_CalAging(p_temp),:,j_temp(p_temp),ijk));
%         end
        temp_Omega = sdpv.bat.approx_common.w(temp_Omega_ind);
        

        sdpv.const = [sdpv.const, ...
            sdpv.bat.approx_common.Omega_t2(t_temp2,ijk) == sum(temp_Omega(:))];
        %
    end

%     %----------------------
    for t_temp = (arbj.approx_common.t3-1)
        
        temp_LU = max(0,arbj.approx_common.N2 - t_temp); % N1 - t1
        temp_UU = min((arbj.approx_common.N3+arbj.approx_common.N2 - t_temp),arbj.approx_common.N2);
        i_CalAging = (temp_LU:temp_UU)+1; % this is j
        
        t_temp2 = t_temp + 1; % Index transformation!
        
        j_temp  = i_CalAging -(arbj.approx_common.N2 +1 ) + t_temp2; % this is k
        
        temp_Omega_ind = false(size(sdpv.bat.approx_common.w));
        for p_temp = 1:length(j_temp)
            temp_Omega_ind(:,i_CalAging(p_temp),j_temp(p_temp),ijk) = true;
        end        
        temp_Omega = sdpv.bat.approx_common.w(temp_Omega_ind);
        
        
%         for p_temp = 1:length(j_temp)
%             temp_Omega = temp_Omega + sum(sdpv.bat.approx_common.w(:,i_CalAging(p_temp),j_temp(p_temp),ijk));
%         end
        sdpv.const = [sdpv.const, ...
            sdpv.bat.approx_common.Omega_t3(t_temp2,ijk) == sum(temp_Omega(:))];
        %
    end
    
%         sdpv.const = [sdpv.const, ...
%             sos2(sdpv.bat.approx_common.Omega_t1(:,ijk))];
%         sdpv.const = [sdpv.const, ...
%             sos2(sdpv.bat.approx_common.Omega_t2(:,ijk))];    
%         sdpv.const = [sdpv.const, ...
%             sos2(sdpv.bat.approx_common.Omega_t3(:,ijk))];

grayOmega_t1 = findGrayWeightIndicators(length(sdpv.bat.approx_common.Omega_t1(:,ijk))-1,0,0); 
grayOmega_t2 = findGrayWeightIndicators(length(sdpv.bat.approx_common.Omega_t2(:,ijk))-1,0,0); 
grayOmega_t3 = findGrayWeightIndicators(length(sdpv.bat.approx_common.Omega_t3(:,ijk))-1,0,0); 

binv.bat.approx_common.Omega_t1 = binvar(grayOmega_t1.nt,arbj.Nh,'full');
binv.bat.approx_common.Omega_t2 = binvar(grayOmega_t2.nt,arbj.Nh,'full');
binv.bat.approx_common.Omega_t3 = binvar(grayOmega_t3.nt,arbj.Nh,'full');

for iOut=1:grayOmega_t1.nt
    % A loop over the new binary variables.
    temp = sdpv.bat.approx_common.Omega_t1(:,ijk);
    %delta
    sdpv.const = [sdpv.const, ...
        sum( temp(grayOmega_t1.delta{iOut})  )  <=( binv.bat.approx_common.Omega_t1(iOut,ijk)  )];
    %1-delta
    sdpv.const = [sdpv.const, ...
        sum( temp(grayOmega_t1.one_min_delta{iOut})  )  <=( 1 - binv.bat.approx_common.Omega_t1(iOut,ijk)  )];
end

for iOut=1:grayOmega_t2.nt
    % A loop over the new binary variables.
    temp = sdpv.bat.approx_common.Omega_t2(:,ijk);
    %delta
    sdpv.const = [sdpv.const, ...
        sum( temp(grayOmega_t2.delta{iOut})  )  <=( binv.bat.approx_common.Omega_t2(iOut,ijk)  )];
    %1-delta
    sdpv.const = [sdpv.const, ...
        sum( temp(grayOmega_t2.one_min_delta{iOut})  )  <=( 1 - binv.bat.approx_common.Omega_t2(iOut,ijk)  )];
end

for iOut=1:grayOmega_t3.nt
    % A loop over the new binary variables.
    temp = sdpv.bat.approx_common.Omega_t3(:,ijk);
    %delta
    sdpv.const = [sdpv.const, ...
        sum( temp(grayOmega_t3.delta{iOut})  )  <=( binv.bat.approx_common.Omega_t3(iOut,ijk)  )];
    %1-delta
    sdpv.const = [sdpv.const, ...
        sum( temp(grayOmega_t3.one_min_delta{iOut})  )  <=( 1 - binv.bat.approx_common.Omega_t3(iOut,ijk)  )];
end

    
    sdpv.const = [sdpv.const, ...
    sum(sum(sum(sdpv.bat.approx_common.w(:,:,:,ijk))))==1];

%%%%    Square finding! LOGARITMIC

% no need for sos1, all variables are active. Since we have logical
% adressing, we also do not need three conditions. 

for iOut=1:gray.nt
   % A loop over the new binary variables. 
   temp = sdpv.bat.approx_common.w(:,:,:,ijk);
   %delta
   sdpv.const = [sdpv.const, ...
        sum( temp(gray.delta{iOut})  )  <=( binv.bat.approx_common.mu_LOG(iOut,ijk)  )];
   %1-delta
   sdpv.const = [sdpv.const, ...
        sum( temp(gray.one_min_delta{iOut})  )  <=( 1 - binv.bat.approx_common.mu_LOG(iOut,ijk)  )];    
end



    
    
    
    %sdpv.bat.Icell_approx(ijk) 
    sdpv.const = [sdpv.const, ...
        sdpv.bat.Pcell_approx(ijk)    == sum(sum(sum( (repmat(data.segm.P.x',1,data.segm.SOC.n+1,data.segm.T.n+1)).*sdpv.bat.approx_common.w(:,:,:,ijk)  )))];    
    
    sdpv.const = [sdpv.const, ...
        sdpv.bat.Pcell_ch_approx(ijk) == sum(sum(sum( (repmat(data.segm.P.x(data.segm.P.zero:end)'...
                                         ,1,data.segm.SOC.n+1,data.segm.T.n+1)).*sdpv.bat.approx_common.w(data.segm.P.zero:(data.segm.P.n+1),:,:,ijk)  )))];    
    
    sdpv.const = [sdpv.const, ...
        sdpv.bat.Pcell_disch_approx(ijk) == -sum(sum(sum( (repmat(data.segm.P.x(1:data.segm.P.zero)'...
                                         ,1,data.segm.SOC.n+1,data.segm.T.n+1)).*sdpv.bat.approx_common.w(1:data.segm.P.zero,:,:,ijk)  )))];         
    %sdpv.bat.SOCavg(ijk)
    sdpv.const = [sdpv.const, ...
        sdpv.bat.SOCavg(ijk) == sum(sum(sum( (repmat(data.segm.SOC.x,data.segm.P.n+1,1,data.segm.T.n+1)).*sdpv.bat.approx_common.w(:,:,:,ijk) )))]; %sdpv.bat.SOCavg(ijk)
    %sdpv.bat.Tk_avg(ijk)
    sdpv.const = [sdpv.const, ...
        sdpv.bat.Tk_avg(ijk) == sum(sum(sum( repmat(data.segm.T.x,data.segm.P.n+1,data.segm.SOC.n+1,1).*sdpv.bat.approx_common.w(:,:,:,ijk)  )))];
    
end





  
  
  