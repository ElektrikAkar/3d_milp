function [] = plt_PAC_ecdf(DY, NO, plt_path, plt_save)
text_font = 11;
lw = {'LineWidth',1.5};



golden_ratio = 1.618;
x0 = 1;
y0 = 1;

width  = 3.5; % 3.5 inch / 9 cm 
height = width/golden_ratio;

plt.common.time_h = (0:NO.nonsv.dth:((NO.nonsv.Nh)*NO.nonsv.dth))';
plt.common.time_d = plt.common.time_h/24;



fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');


[ff,xx] = ecdf(DY.nonsv.AC.Pnett);
plot(100*ff,xx,'LineWidth',1.5); grid on;

[ff,xx] = ecdf(NO.nonsv.AC.Pnett);
plot(100*ff,xx,'LineWidth',1.5); grid on;
hold on;




legend('Temperature effect included', 'Temperature effect not included','location','southeast');
xlabel('Cumulative Frequency / %');
ylabel('P_{AC} / kW');

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