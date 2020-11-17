function [] = plt_SOH_comparison3(DY, NO, noSOC, plt_path, plt_save)
% Compare 3 cases: 
% Author: Vk
% Date  : 2020.07.21

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
plt.y3 = 100*noSOC.nonsv.bat.SOH(resampling_rate);


fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');

plot(plt.x, plt.y2, lw{:});
grid on;
hold on;
plot(plt.x, plt.y1, lw{:});
plot(plt.x, plt.y3, lw{:});

xlim([-0.5,30.5]);

xlabel('time / days');
ylabel('SOH / %');

legend('Temperature effect included', 'Temperature effect not included','SOC and temp. effects not included');

%title('SOH Comparison with PE');

set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(gcf,'renderer','Painters')








% Create textarrow
[annot.x, annot.y] = ds2nfu(plt.x(end), plt.y1(end));
annot.arrow{1} = annotation(fig1,'textarrow',[0.789166666666667 annot.x],...
    [0.57 annot.y+0.02],'String',{"SOH = "+sprintf('%2.4f', plt.y1(end) )+"%"});

[annot.x, annot.y] = ds2nfu(plt.x(end), plt.y2(end));
annot.arrow{2} = annotation(fig1,'textarrow',[0.794956140350877 annot.x],...
    [0.65 annot.y+0.02],'String',{"SOH = "+sprintf('%2.4f', plt.y2(end))+"%"});

[annot.x, annot.y] = ds2nfu(plt.x(end), plt.y3(end));
annot.arrow{3} = annotation(fig1,'textarrow',[0.794956140350877 annot.x],...
    [0.22  annot.y-0.02],'String',{"SOH = "+sprintf('%2.4f', plt.y3(end))+"%"});

for i = 1:length(annot.arrow)
    annot.arrow{i}.FontName = 'Times';
    annot.arrow{i}.FontSize = text_font;
end


save_plt(fig1, plt_path, plt_save, "eps");

end