function [] = plt_time_series_oneweek(DY, NO, noSOC, plt_path, plt_save, plt_additional)
% Time series plot for one week. 
% Author: Vk
% Date  : 2020.08.18


text_font = 10;
lw = {'LineWidth',1.2};

color.green     = [0.4660, 0.6740, 0.1880];
color.light_red = [0.8500, 0.3250, 0.0980];
color.yellow    = [0.9290, 0.6940, 0.1250];
color.purple    = [0.4940, 0.1840, 0.5560];


golden_ratio = 1.618;
x0 = 1;
y0 = 1;

width  = 7; % 3.5 inch / 9 cm 
height = 1.5;%width/golden_ratio/2;


% Select the most week. 

n_days = 1;
a_week = 4*24*n_days;

res_len = mod(length(DY.c_kWh), a_week);

prices = DY.c_kWh(1:(end-res_len));
prices = reshape(prices, a_week, []);

price.std = std(prices);
price.mean_std = mean(price.std);
[~, price.i] = min(abs(price.std-price.mean_std)); 
%price.i = 1;
%-------------------------------
a_week_nonsv  = 24*n_days/NO.nonsv.dth;

price.i_nonsv = (price.i-1)*a_week_nonsv + 1;
price.ind_nonsv = ((price.i_nonsv):(price.i_nonsv+a_week_nonsv))';




plt.common.time_h = (price.ind_nonsv-1)*NO.nonsv.dth;
plt.common.time_d = plt.common.time_h/24;

plt.common.time_d_n = plt.common.time_d(1:(1/DY.nonsv.dth/4):end);
plt.common.time_h_n = plt.common.time_h(1:(1/DY.nonsv.dth/4):end);

resampling_rate = 1:1:length(plt.common.time_h);

pos{1} = [x0 y0 (x0+width) (y0+height/1.2)];

fig(1)=figure('Units','inches',...
'Position',pos{1},...
'PaperPositionMode','auto');

poss = get(fig(1),'Position');
set(fig(1),'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[poss(3), poss(4)]);

% ax(1) = axes('Units','inches',...
% 'OuterPosition',[0 0 (width) (height/1.2)]);


%plt.h(1) = bar(plt.common.time_h_n(1:end-1)-plt.common.time_h_n(1), prices(:,price.i), 'Color', 'k', lw{:}); %lw{:}
stairs(plt.common.time_h_n-plt.common.time_h_n(1), [prices(:,price.i);prices(1,price.i+1)])
grid on;
xlabel('time / h');
ylabel('Price / (EUR/kWh)');
xlim([0,24]);
ylim([-0.03,0.14]);

ax(1) = gca;



pos{2} = [x0 y0 (x0+width) (y0+height)];
fig(2)=figure('Units','inches',...
'Position',pos{2},...
'PaperPositionMode','auto');

poss = get(fig(2),'Position');
set(fig(2),'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[poss(3), poss(4)]);

stairs(plt.common.time_h(1:end)-plt.common.time_h_n(1), DY.nonsv.AC.Pnett(price.ind_nonsv), 'Color', color.green,  lw{:}); 
hold on; grid on;

stairs(plt.common.time_h(1:end)-plt.common.time_h_n(1), NO.nonsv.AC.Pnett(price.ind_nonsv), 'Color', color.yellow,  lw{:}); 
stairs(plt.common.time_h(1:end)-plt.common.time_h_n(1), noSOC.nonsv.AC.Pnett(price.ind_nonsv), 'Color', color.light_red,  lw{:}); 
xlabel('time / h');
ylabel('P_{AC} / kW');

ylim([-450,220]);
xlim([0,24]);
legend('Case 1', 'Case 2','Case 3','location','southeast', 'Orientation','horizontal');

ax(2) = gca;
% set(gca,...
% 'Units','normalized',...
% 'FontUnits','points',...
% 'FontWeight','normal',...
% 'FontSize',text_font,...
% 'FontName','Times');
% set(gca,'LooseInset',max(get(gca,'TightInset'), 0.01))
% set(gcf,'renderer','Painters')




% 

pos{3} = [x0 y0 (x0+width) (y0+height)];
fig(3)=figure('Units','inches',...
'Position',pos{3},...
'PaperPositionMode','auto');

poss = get(fig(3),'Position');
set(fig(3),'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[poss(3), poss(4)]);


plot(plt.common.time_h(1:end)-plt.common.time_h_n(1), 100*DY.nonsv.bat.SOC(price.ind_nonsv), 'Color', color.green,  lw{:}); 
hold on;grid on;

plot(plt.common.time_h(1:end)-plt.common.time_h_n(1), 100*NO.nonsv.bat.SOC(price.ind_nonsv), 'Color', color.yellow,  lw{:}); 
plot(plt.common.time_h(1:end)-plt.common.time_h_n(1), 100*noSOC.nonsv.bat.SOC(price.ind_nonsv), 'Color', color.light_red,  lw{:}); 

xlabel('time / h');
ylabel('SOC / %');
xlim([0,24]);
legend('Case 1', 'Case 2','Case 3','location','northeast');

ax(3) = gca;


pos{4} = [x0 y0 (x0+width) (y0+height)];
fig(4)=figure('Units','inches',...
'Position',pos{3},...
'PaperPositionMode','auto');

poss = get(fig(4),'Position');
set(fig(4),'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[poss(3), poss(4)]);


plot(plt.common.time_h(1:end)-plt.common.time_h_n(1), DY.nonsv.bat.Tk(price.ind_nonsv)-KELVIN, 'Color', color.green,  lw{:}); 
hold on;grid on;

plot(plt.common.time_h(1:end)-plt.common.time_h_n(1), NO.nonsv.bat.Tk(price.ind_nonsv)-KELVIN, 'Color', color.yellow,  lw{:}); 
plot(plt.common.time_h(1:end)-plt.common.time_h_n(1), noSOC.nonsv.bat.Tk(price.ind_nonsv)-KELVIN, 'Color', color.light_red,  lw{:}); 

xlabel('time / h');
ylabel('Temperature / ^oC');
xlim([0,24]);
ylim([18,50]);
legend('Case 1', 'Case 2','Case 3','location','northeast');

ax(4) = gca;



for i=1:4
    set(ax(i),...
    'Units','normalized',...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',text_font,...
    'FontName','Times');
end

% end
[~, ax_ind] = max([ax(1).Position(1), ax(2).Position(1), ax(3).Position(1), ax(4).Position(1)]);

for i =1:4
   ax(i).Position([1,3]) = ax(ax_ind).Position([1,3]);
   ax(i).OuterPosition(2) = 0;%ax(i).OuterPosition(2)+0.015;
 %  ax(i).Position(3) =  0.99 - ax(i).Position(1);
    ax(i).XTick = 0:3:24;
end



for i=1:4
 %   set(ax(i),'LooseInset',max(get(ax(i),'TightInset'), 0.02))
    set(fig(i),'renderer','Painters')
%     set(fig(i),'PaperUnits','inches');
%     set(fig(i),'PaperPosition',[x0 y0 (x0+width) (y0+height)]);
%     set(fig(i),'PaperPositionMode','manual');
end

% for i=2:3
%     ax(i).Units = 'inches';
% end


exportgraphics(fig(1),plt_path+"_price2.eps")
exportgraphics(ax(1),plt_path+"_price3.eps")
save_plt(fig(1), plt_path+"_price", plt_save, "eps");
save_plt(fig(2), plt_path+"_PAC", plt_save, "eps");
save_plt(fig(3), plt_path+"_SOC", plt_save, "eps");
save_plt(fig(4), plt_path+"_Tc", plt_save, "eps");
exportgraphics(ax(4),plt_path+"_Tc2.eps")
end