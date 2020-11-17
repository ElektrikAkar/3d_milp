function [] = plt_SOC_ecdf3(DY, NO, noSOC, plt_path, plt_save)
text_font = 11;
lw = {'LineWidth',1.5};

color.green     = [0.4660, 0.6740, 0.1880];
color.light_red = [0.8500, 0.3250, 0.0980];
color.yellow    = [0.9290, 0.6940, 0.1250];
color.purple    = [0.4940, 0.1840, 0.5560];

golden_ratio = 1.618;
x0 = 1;
y0 = 1;

width  = 3; % 3.5 inch / 9 cm 
height = width/golden_ratio;

plt.common.time_h = (0:NO.nonsv.dth:((NO.nonsv.Nh)*NO.nonsv.dth))';
plt.common.time_d = plt.common.time_h/24;



fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');

[ff,xx] = ecdf(100*DY.nonsv.bat.SOC(1:DY.nonsv.i));
plot(100*ff,xx,'LineWidth',1.3, 'Color', color.green); grid on;
hold on;

[ff,xx] = ecdf(100*NO.nonsv.bat.SOC);
plot(100*ff,xx,'LineWidth',1.3, 'Color', color.yellow); grid on;

[ff,xx] = ecdf(100*noSOC.nonsv.bat.SOC);
plot(100*ff,xx,'LineWidth',1.3, 'Color', color.light_red); grid on;


legend('Case 1', 'Case 2','Case 3', 'location','northwest');
xlabel('Cumulative Frequency / %');
ylabel('SOC / %');

xlim([-1,101])


set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(gcf,'renderer','Painters')

save_plt(fig1, plt_path, plt_save, "eps");

end