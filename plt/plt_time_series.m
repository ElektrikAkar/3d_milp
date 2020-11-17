function [] = plt_time_series(DYorNO, plt_path, plt_save)
text_font = 11;
lw = {'LineWidth',1.5};
time_series_title = "BESS AC-side power / kW";

reduced_data = kron(eye(length(DYorNO.nonsv.AC.Pnett)/DYorNO.nonsv.N  ),ones(1,DYorNO.nonsv.N))*DYorNO.nonsv.AC.Pnett/DYorNO.nonsv.N;

x0 = 1;
y0 = 1;

width  = 7; % 3.5 inch / 9 cm 
height = 1.3*width;

plt.common.time_h = (0:DYorNO.nonsv.dth:((DYorNO.nonsv.Nh)*DYorNO.nonsv.dth))';
plt.common.time_d = plt.common.time_h/24;

resampling_rate = 1:10:length(plt.common.time_h);

fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');

hold on;
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))

subplot(3,2,1:2);

axx= area((0:(length(reduced_data)-1))*DYorNO.arbj.dth/24, reduced_data,...
    'LineWidth',0.5,'FaceColor',[0.00,0.20,0.35],'EdgeColor','None'); grid on;
title(time_series_title);
xlabel('time / days');
ylabel('P_{AC} / kW'); %[1/h] for C-rate


ax1 = gca;

ylim([-350,350]);

assert(max(reduced_data)<350);
assert(min(reduced_data)>-350);


set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))

time_temp = (0:(length(DYorNO.nonsv.bat.SOC)-1))*DYorNO.nonsv.dth/24;
subplot(3,2,3:4);

plot(time_temp, 100*DYorNO.nonsv.bat.SOC); grid on; hold on;
title('BESS SOC / %');
xlabel('time / days');
ylabel('SOC / %');
%xlim([274,305]);
ax2 = gca;
linkaxes([ax1,ax2],'x');

ylim([0,119]);

set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))

yyaxis right;

plot(time_temp,100*DYorNO.nonsv.bat.SOH,'linewidth',2); grid on; hold on;
title('BESS SOH / %');
xlabel('time / days');
ylabel('SOH / %');

legend('SOC','SOH','location','northeast','orientation','horizontal');

set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
ylim([97.3,100.38]);
subplot(3,2,5);


DYorNO.nonsv.bat.meanSOC = movmean(DYorNO.nonsv.bat.SOC,2);
DYorNO.nonsv.bat.meanSOC = DYorNO.nonsv.bat.meanSOC(2:end);
DYorNO.nonsv.bat.meanSOC = 100*kron(eye(length(DYorNO.nonsv.AC.Pnett)/DYorNO.nonsv.N  ),ones(1,DYorNO.nonsv.N))*DYorNO.nonsv.bat.meanSOC/DYorNO.nonsv.N;

DYorNO.nonsv.bat.meanC_nom = movmean(DYorNO.nonsv.bat.C_nom,2); 
DYorNO.nonsv.bat.meanC_nom = DYorNO.nonsv.bat.meanC_nom(2:end);


DYorNO.nonsv.bat.reducedCrate = kron(eye(length(DYorNO.nonsv.AC.Pnett)/DYorNO.nonsv.N  ),ones(1,DYorNO.nonsv.N))*((DYorNO.nonsv.bat.I_cell)./DYorNO.nonsv.bat.meanC_nom)...
                            /DYorNO.nonsv.N; 

colormap('jet');
imagesc(reshape(DYorNO.nonsv.bat.meanSOC,floor(length(DYorNO.nonsv.bat.meanSOC)/30),30));
c1 = colorbar;
my_factor = length(DYorNO.nonsv.bat.meanSOC)/30/24;
xlabel('Day number');
ylabel('Hours / h');
title('SOC / %');
ax = gca;

ylim([0,length(DYorNO.nonsv.bat.meanSOC)/30])
desired_ytix = 0:3:24;  %Change here! 
desired_ytix_conv = desired_ytix*my_factor;

ytix = get(gca, 'YTick');
set(gca, 'YTick',desired_ytix_conv, 'YTickLabel',desired_ytix);

set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))

%c1.Label.String = 'SOC [%]';
%c1.Label.FontSize = text_font;
caxis([0,100]);
%----------------------------
subplot(3,2,6);
i=5; %SOC


colormap('jet');
imagesc(reshape(DYorNO.nonsv.bat.reducedCrate,length(DYorNO.nonsv.bat.reducedCrate)/30,30));
c1 = colorbar;
my_factor = length(DYorNO.nonsv.bat.reducedCrate)/30/24;
xlabel('Day number');
ylabel('Hours / h');
title('C-rate / 1/h');
ax = gca;

ylim([0,length(DYorNO.nonsv.bat.reducedCrate)/30])
desired_ytix = 0:3:24;  %Change here! 
desired_ytix_conv = desired_ytix*my_factor;

ytix = get(gca, 'YTick');
set(gca, 'YTick',desired_ytix_conv, 'YTickLabel',desired_ytix);

caxis([-2,2]);

set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))


save_plt(fig1, plt_path, plt_save, "png");

end