function [] = plt_temp_time_series(DYorNO, plt_path, plt_save)
text_font = 11;
lw = {'LineWidth',1.5};

golden_ratio = 1.618;
x0 = 1;
y0 = 1;

width  = 3.5; % 3.5 inch / 9 cm 
height = width/golden_ratio;


fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');


plot((0:length(DYorNO.nonsv.bat.Tk)-1)*DYorNO.nonsv.dth/24,DYorNO.nonsv.bat.Tk-KELVIN,lw{:}); grid on;



%legend('Temperature effect included', 'Temperature effect not included','location','southeast');
xlabel('Time / days');
ylabel('Cell temperature / ^oC');

xlim([0,30])


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