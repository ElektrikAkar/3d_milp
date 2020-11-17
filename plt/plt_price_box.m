function [] = plt_price_box(price_signal, plt_path, plt_save)
text_font = 11;
lw = {'LineWidth',1.5};


x0 = 1;
y0 = 1;

width = 6;
height= 1.8; 
golden_ratio = 1.618;

fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');

data = price_signal(1:(30*24*4));
data = reshape(data,[],30);

boxplot(data); grid on;
ylabel('Price / (EUR/kWh)');
xlabel('Day number');

set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
xtickangle(45)
ax1= gca;

dim = [.671 .61 .3 .3];
str1= "\mu = " + sprintf('%4.4f',mean(data(:))) + " EUR/kWh";
str2= "\sigma = " +sprintf('%4.4f',std(data(:)))+ " EUR/kWh";
str = {str1,str2};
%annotation('textbox',dim,'String',str,'FitBoxToText','on','FontName','Times','FontSize',text_font,'BackgroundColor','white');

myTitle = title(str1+"    " + str2)
myTitle.FontWeight = 'Normal';
myTitle.FontSize = text_font;
%yyaxis right



%ylim([-0.15 0.3859]);

set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(gcf,'renderer','Painters')

save_plt(fig1, plt_path, plt_save, "eps");

end