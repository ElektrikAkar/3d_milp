% Union Jack triangulation. 
%
% Author: VK
% Date  : ?

% arbj.approx_common.t1 = 1:(data.segm.P.n   + data.segm.SOC.n  +1); %N1+N2
% arbj.approx_common.t2 = 1:(data.segm.P.n   + data.segm.T.n    +1); %N1+N3
% arbj.approx_common.t3 = 1:(data.segm.SOC.n + data.segm.T.n    +1); %N2+N3

arbj.approx_common.N1 = (data.segm.P.n);
arbj.approx_common.N2 = (data.segm.SOC.n);
arbj.approx_common.N3 = (data.segm.T.n);

%union_jack_triangulation_2020_04_30;

%constraints_allbinaries 2xbinary.

uJ = calculate_union_jack_triangulation(arbj.approx_common.N1, arbj.approx_common.N2, arbj.approx_common.N3);

sdpv.bat.approx_common.w = sdpvar(data.segm.P.n+1, data.segm.SOC.n+1,  data.segm.T.n+1, arbj.Nh);

binv.bat.approx_common.unionJack = binvar(uJ.nt, arbj.Nh, 'full'); % Log modelling for union jack.

    
%%    

%binv.bat.approx_common.mu_LOG   = binvar(gray.nt,arbj.Nh,'full'); %logaritmic modelling. 

sdpv.bat.Pcell_approx         = sdpvar(arbj.Nh,1,'full');
sdpv.bat.Pcell_ch_approx      = sdpvar(arbj.Nh,1,'full');
sdpv.bat.Pcell_disch_approx   = sdpvar(arbj.Nh,1,'full');


sdpv.const = [sdpv.const, ...
    1>=sdpv.bat.approx_common.w>=0];

sdpv.const = [sdpv.const, ...
    binv.bat.approx_common.unionJack(1,:)<= binv.bat.approx_common.unionJack(2,:)]; % to cover not covered gray codes.

sdpv.const = [sdpv.const, ...
    func.sum3(sdpv.bat.approx_common.w)==1]; % Very interestingly moving this out changes optimization but not values. 


%sdpv.bat.Icell_approx(ijk) 
% sdpv.const = [sdpv.const, ...
%     sdpv.bat.Pcell_approx(ijk)    == func.sum3( data.segm.P.X.*sdpv.bat.approx_common.w(:,:,:,ijk)  )];  
sdpv.const = [sdpv.const, ...
    sdpv.bat.Pcell_approx    == squeeze(func.sum3(repmat(data.segm.P.X,1,1,1,arbj.Nh).*sdpv.bat.approx_common.w))];    

% sdpv.const = [sdpv.const, ...
%     sdpv.bat.Pcell_ch_approx(ijk) == func.sum3( data.segm.P.X(data.segm.P.zero:end,:,:).*sdpv.bat.approx_common.w(data.segm.P.zero:(data.segm.P.n+1),:,:,ijk)  )];  
sdpv.const = [sdpv.const, ...
    sdpv.bat.Pcell_ch_approx == squeeze(func.sum3(repmat(data.segm.P.X(data.segm.P.zero:end,:,:),1,1,1,arbj.Nh).*sdpv.bat.approx_common.w(data.segm.P.zero:(data.segm.P.n+1),:,:,:)  ))]; 


%     sdpv.const = [sdpv.const, ...
%         sdpv.bat.Pcell_disch_approx(ijk) == -func.sum3( data.segm.P.X(1:data.segm.P.zero,:,:).*sdpv.bat.approx_common.w(1:data.segm.P.zero,:,:,ijk)  )];    
sdpv.const = [sdpv.const, ...
    sdpv.bat.Pcell_disch_approx == -squeeze(func.sum3(repmat(data.segm.P.X(1:data.segm.P.zero,:,:),1,1,1,arbj.Nh) .*sdpv.bat.approx_common.w(1:data.segm.P.zero,:,:,:)  ))];   

%sdpv.bat.SOCavg(ijk)
sdpv.const = [sdpv.const, ...
    sdpv.bat.SOCavg == squeeze(func.sum3( repmat(data.segm.SOC.X, 1,1,1,arbj.Nh).*sdpv.bat.approx_common.w)) ]; %sdpv.bat.SOCavg(ijk)


%sdpv.bat.Tk_avg(ijk)
% sdpv.const = [sdpv.const, ...
%     sdpv.bat.Tk_avg(ijk) == func.sum3( data.segm.T.X.*sdpv.bat.approx_common.w(:,:,:,ijk)  )];
sdpv.const = [sdpv.const, ...
    sdpv.bat.Tk_avg == squeeze(func.sum3( repmat(data.segm.T.X, 1,1,1,arbj.Nh).*sdpv.bat.approx_common.w  ))];

for ijk = 1:arbj.Nh


for iOut=1:uJ.nt
   % A loop over the new binary variables. 
   temp = sdpv.bat.approx_common.w(:,:,:,ijk);
   %delta
   sdpv.const = [sdpv.const, ...
        sum( temp(uJ.constraints_allbinaries(:,:,:,1,iOut)  )  )  <=( binv.bat.approx_common.unionJack(iOut,ijk)  )];
   %1-delta
   sdpv.const = [sdpv.const, ...
        sum( temp(uJ.constraints_allbinaries(:,:,:,2,iOut)   )  )  <=( 1 - binv.bat.approx_common.unionJack(iOut,ijk)  )];    
end

    
end





  
  
  