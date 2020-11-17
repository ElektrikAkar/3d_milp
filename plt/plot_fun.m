% For plotting functions and seeing the situation. 

%% dT/dt -> func.dTcell0_Pt (P_t,SOC_pu,Tk)

% numer.SOC_pu = 0:0.01:1;
% numer.Tk     = KELVIN + (18:2:60);
% numer.P_t    = -10:0.2:10;
% 
% 
% numer.dT_for_SOC_05 = zeros(length(numer.P_t),length(numer.Tk));
% 
% for i=1:length(numer.P_t)
%    for j=1:length(numer.Tk)
%        
%        numer.dT_for_SOC_05(i,j) = func.dTcell0_Pt(numer.P_t(i),0.5,numer.Tk(j));
%    end
% end


KELVIN = 273.15;

%% For Charging  dT 
%clc;
%tic
clear exdata

%profile on
exdata.I_t(:,1) = gpuArray(linspace(0,9.6/3.2,100)); %1000 pieces
%gpuDevice(1)
exdata.P_t(:,1) = gpuArray(linspace(-9.6,9.6,100)); %0 to 10W.  % 1000 pieces 
exdata.SOC(1,:) = gpuArray(linspace(0.05,0.95,50)); %300 pieces
exdata.Tk(1,1,:)= gpuArray(KELVIN + linspace(0,60,50)); % 10C to 60C  %300 pieces


%toc
%  tic;
% Itt1= func.It(exdata.P_t,exdata.SOC,exdata.Tk);
%  toc;
tic;
Itt = func.dQcell_Pt(exdata.P_t,exdata.SOC,exdata.Tk);
toc

Itd = Itt(:,:,15);

[PTX,SOCX] = meshgrid(exdata.P_t,exdata.SOC);

mesh(PTX,SOCX,Itd')


%%
% Test for cycle aging functions! 
% low T: 
close all;

test.func_k_cyc_low_T           = func.k_cyc_low_T(exdata.I_t,exdata.Tk); % -> slightly different. 
test.func_k_cyc_high_T          = func.k_cyc_high_T(exdata.I_t,exdata.Tk); % -> Verified.

test.func_k_cal                 = func.k_cal(exdata.SOC, exdata.Tk);


[exdata.I_t_X,exdata.TkX]= meshgrid(exdata.I_t,exdata.Tk);
[exdata.SOCx,exdata.TkX]= meshgrid(exdata.SOC,exdata.Tk);

mesh(exdata.I_t_X/param.cyc.C0,exdata.TkX-KELVIN,squeeze(test.func_k_cyc_low_T )');

figure;
mesh(exdata.I_t_X/param.cyc.C0,exdata.TkX-KELVIN,squeeze(test.func_k_cyc_high_T )');

figure;
mesh(100*exdata.SOCx,exdata.TkX-KELVIN,squeeze(test.func_k_cal )');





figure;
test.func_k_cyc_low_T_high_SOC  = func.k_cyc_low_T_high_SOC(exdata.I_t,0.90,exdata.Tk); 
mesh(exdata.I_t_X/param.cyc.C0,exdata.TkX-KELVIN,squeeze(test.func_k_cyc_low_T_high_SOC )');

%% Test for current and determine segmentation! 
figure; 

plot(0.02:0.01:0.98,-func.It(9,0.02:0.01:0.98,KELVIN+25))
hold on; grid on;

plot(0.02:0.01:0.98,func.It(-9,0.02:0.01:0.98,KELVIN+25))

%From this figures, SOC points are determined visually: 

[0.02, 0.1, 0.2, 0.4, 0.8,0.98]; 

figure; plot(0.02:0.01:0.98,func.dTcell0_Pt(5,0.02:0.01:0.98,KELVIN+30))

%[0.02, 0.1, 0.2, 0,4, 0.5, 0.7, 0.8, 0.9, 0.98] -> temperature! 


%%
x0 = 1;
y0 = 1;

width = 5.5;
height= 2; 
text_font = 11;
 

plot_lw     = {'LineWidth',2};

figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');


plot(data.only_PE_loss.P_AC_kW,data.only_PE_loss.P_loss_kW,plot_lw{:}); hold on;
grid on
xlabel('P_{AC} [kW]');
ylabel('P_{loss} [kW]');

plot(data.segm.P_AC_kW,data.segm.P_AC_loss_kW,'*:',plot_lw{:});
legend('Actual','Approximation','location','southeast');

set(gcf,'renderer','Painters')

tempName = "P_AC_vs_P_loss";
savefig((Plotting.batchPath+tempName+'.fig'));
print((Plotting.batchPath+tempName+'.eps'),'-depsc');

%%
%Linearization tests: 1,500, 700, 850, 1024, 1146, 1160, 1184, 

mar1 = 1185;
mar2 = 1250;

lintest1 = data.only_PE_loss.P_AC_kW(mar1:mar2);
lintest2 = data.only_PE_loss.P_loss_kW(mar1:mar2);


%%

exdata.k_cal = func.k_cal( data.segm.SOC.x, data.segm.T.x);

[exdata.SOCX,exdata.TkX]= meshgrid(data.segm.SOC.x,data.segm.T.x);

mesh(exdata.SOCX,exdata.TkX,squeeze(exdata.k_cal)');


%%



%Minimum temperature must be higher than 18, otherwise battery cannot give
%power on discharge. Optimization fails.
% tic;
% %exdata.dTT = func.dTcell0_Pt(exdata.P_t,exdata.SOC,exdata.Tk);
% func.dTcell0_Pt(exdata.P_t,exdata.SOC,exdata.Tk);
% toc
% 
% tic
% abc = func.dTcell0(exdata.I_t,exdata.SOC,exdata.Tk);
% toc
% %profile viewer
% save('exdata_dT_charging.mat','exdata');

%%





% 
% exdata.p   = length(exdata.P_t);
% exdata.q   = length(exdata.SOC);
% exdata.r   = length(exdata.Tk);
% 
% exdata.dT  = zeros(length(exdata.P_t),length(exdata.SOC),length(exdata.Tk));
% tic
% for i=1:(exdata.p)
%     for j=1:(exdata.q)
%         for k=1:(exdata.r)
%             exdata.dT(i,j,k) = func.dTcell0_Pt(exdata.P_t(i),exdata.SOC(j),exdata.Tk(k));
%         end
%     end
%     fprintf('%d of %d is finished\n',i,exdata.p);
% end
% toc



%exdata.dT(i,j,k) = func.dTcell0_Pt(exdata.P_t(i),exdata.SOC(k),exdata.Tk(j));

%    
%     for j=1:(exdata.q)
%         for k=1:(exdata.r)
%             exdata.dT(i,j,k) = func.dTcell0_Pt(exdata.P_t(i),exdata.Tk(j),exdata.SOC(k));
%         end
%     end

    
    
    
% [exdata.P_t, exdata.Tk,exdata.SOC] = meshgrid(exdata.P_t,exdata.Tk,exdata.SOC);
% 
% exdata.P_t = reshape(exdata.P_t,[],1);
% exdata.Tk  = reshape(exdata.Tk,[],1);
% exdata.SOC = reshape(exdata.SOC,[],1);






% numerc.P_tX = num2cell(numer.P_tX);
% numerc.TkY = num2cell(numer.TkY);
%  aaa = (linspace(-10,10,100));
%  bbb = (linspace(KELVIN+0,KELVIN+50,100));
% 
% C = arrayfun(@(x,y) func.dTcell0_Pt(x,0.5,y),numer.P_tX2,numer.TkY2);
% 
% mesh(numer.P_tX, numer.TkY,C);  
% 
% xlabel('P_t');
% ylabel('Tk');

%%

%  aaa = (linspace(-3,3,1000));
%  bbb = (linspace(KELVIN+0,KELVIN+50,1000)); tic;
% cc = arrayfun(@(x,y) func.dTcell0_Pt(x,0.5,y),aaa,bbb); toc

% tic;
% cc2 = bsxfun(@(x,y) func.dTcell0_Pt(x,0.5,y),aaa,bbb); toc

% tic;
% parfor iii=1:length(aaa)
%     func.dTcell0_Pt(aaa(iii),0.5,bbb(iii));
% end
% toc