function [] = plt_SOH_comparison(DY, NO, plt_path, plt_save)
text_font = 11;
lw = {'LineWidth',1.5};



golden_ratio = 1.618;
x0 = 1;
y0 = 1;

width  = 3.5; % 3.5 inch / 9 cm 
height = width/golden_ratio;

plt.common.time_h = (0:NO.nonsv.dth:((NO.nonsv.Nh)*NO.nonsv.dth))';
plt.common.time_d = plt.common.time_h/24;

resampling_rate = 1:10:length(plt.common.time_h);

plt.x  = plt.common.time_d(resampling_rate);
plt.y1 = 100*NO.nonsv.bat.SOH(resampling_rate);
plt.y2 = 100*DY.nonsv.bat.SOH(resampling_rate);

fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');

plot(plt.x, plt.y1, lw{:});
grid on;
hold on;
plot(plt.x, plt.y2, lw{:});

xlim([-0.5,30.5]);

xlabel('time / days');
ylabel('SOH / %');

legend('Temperature effect not included','Temperature effect included');

%title('SOH Comparison with PE');

set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(gcf,'renderer','Painters')




[annot.x, annot.y] = ds2nfu(plt.x(end), plt.y1(end));



%annotation('textarrow',annot.x,annot.y,'String','y = x ')

% Create textarrow
annot.t1 = annotation(fig1,'textarrow',[0.729166666666667 annot.x-0.02],...
    [0.217267531797869 annot.y-0.02],'String',{"SOH = "+sprintf('%2.4f', plt.y1(end) )+"%"});

[annot.x, annot.y] = ds2nfu(plt.x(end), plt.y2(end));
% Create textarrow
annot.t2 = annotation(fig1,'textarrow',[0.794956140350877 annot.x],...
    [0.576483184370345 annot.y+0.02],'String',{"SOH = "+sprintf('%2.4f', plt.y2(end))+"%"});

annot.t1.FontName = 'Times';
annot.t2.FontName = 'Times';

annot.t1.FontSize = text_font;
annot.t2.FontSize = text_font;

save_plt(fig1, plt_path, plt_save, "eps");

end