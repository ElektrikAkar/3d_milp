function [] = plt_SOH_comparison3_sepfit_1y(DY, NO, noSOC, plt_path, plt_save, plt_additional)
% Compare 3 cases: 
% Author: Vk
% Date  : 2020.07.21

text_font = 11;
lw = {'LineWidth',1.5};

color.green = [0.4660, 0.6740, 0.1880];
color.light_red = [0.8500, 0.3250, 0.0980];
color.yellow  = [0.9290, 0.6940, 0.1250];
color.purple = [0.4940, 0.1840, 0.5560];


golden_ratio = 1.618;
x0 = 1;
y0 = 1;

width  = 3.5; % 3.5 inch / 9 cm 
height = width/golden_ratio;

plt.common.time_h = (0:NO.nonsv.dth:((NO.nonsv.Nh)*NO.nonsv.dth))';
plt.common.time_m = plt.common.time_h/24/365;

resampling_rate = 1:1:length(plt.common.time_h);

plt.x  = plt.common.time_m(resampling_rate);
plt.y1 = 100*NO.nonsv.bat.SOH(resampling_rate);
plt.y2 = 100*DY.nonsv.bat.SOH(resampling_rate);
plt.y3 = 100*noSOC.nonsv.bat.SOH(resampling_rate);

plt.x1 = plt.x(plt.y1>0);
plt.x2 = plt.x(plt.y2>0);
plt.x3 = plt.x(plt.y3>0);


plt.y1 = plt.y1(plt.y1>0);
plt.y2 = plt.y2(plt.y2>0);
plt.y3 = plt.y3(plt.y3>0);

SOH_EOL = 80;
[fitresult.y1, gof.y1] = create_agingFit(plt.x1, plt.y1);
[fitresult.y2, gof.y2] = create_agingFit(plt.x2, plt.y2);
[fitresult.y3, gof.y3] = create_agingFit(plt.x3, plt.y3);

plt.x11 = linspace(plt.x1(end), 10,1000);
plt.y11 = fitresult.y1(plt.x11);

plt.x11 = plt.x11(plt.y11>=SOH_EOL);
plt.y11 = plt.y11(plt.y11>=SOH_EOL);
%------------------------

plt.x22 = linspace(plt.x2(end), 15,1500);
plt.y22 = fitresult.y2(plt.x22);

plt.x22 = plt.x22(plt.y22>=SOH_EOL);
plt.y22 = plt.y22(plt.y22>=SOH_EOL);
%-------------------
plt.x33 = linspace(plt.x3(end), 20,2000);
plt.y33 = fitresult.y3(plt.x33);

plt.x33 = plt.x33(plt.y33>=SOH_EOL);
plt.y33 = plt.y33(plt.y33>=SOH_EOL);

%-------------------------------
resampling_rate = 1:20:length(plt.common.time_h);

plt.x  = [plt.common.time_m(resampling_rate); plt.common.time_m(end)];
plt.y1 = 100*[NO.nonsv.bat.SOH(resampling_rate); NO.nonsv.bat.SOH(end)];
plt.y2 = 100*[DY.nonsv.bat.SOH(resampling_rate); DY.nonsv.bat.SOH(end)];
plt.y3 = 100*[noSOC.nonsv.bat.SOH(resampling_rate); noSOC.nonsv.bat.SOH(end)];

plt.x1 = plt.x(plt.y1>0);
plt.x2 = plt.x(plt.y2>0);
plt.x3 = plt.x(plt.y3>0);


plt.y1 = plt.y1(plt.y1>0);
plt.y2 = plt.y2(plt.y2>0);
plt.y3 = plt.y3(plt.y3>0);


fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');

plt.h(1) = plot(plt.x(plt.y2>0), plt.y2(plt.y2>0), 'Color', color.green,  lw{:});
grid on;
hold on;
plt.h(2) = plot(plt.x(plt.y1>0), plt.y1(plt.y1>0), 'Color', color.yellow,  lw{:});
plt.h(3) = plot(plt.x(plt.y3>0), plt.y3(plt.y3>0), 'Color', color.light_red,  lw{:});

uistack(plt.h(1),'top');

xlabel('time / years');
ylabel('SOH / %');

plt.h(4) = plot(plt.x22,plt.y22,'--', 'Color',color.green, lw{:});
plt.h(5) = plot(plt.x11,plt.y11, '--', 'Color',color.yellow, lw{:});

plt.h(6) = plot(plt.x33,plt.y33,'--', 'Color',color.light_red, lw{:});

xlim([-0.5,1.05*ceil(max([plt.x11(end),plt.x22(end),plt.x33(end)]))]);

legend(plt.h(1:3),'Temperature effect included', 'Temperature effect not included','SOC and temp. effects not included');

%title('SOH Comparison with PE');

ylim([79.5,100.5]);
set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(gcf,'renderer','Painters')








% % Create textarrow
% [annot.x, annot.y] = ds2nfu(plt.x(end), plt.y1(end));
% annot.arrow{1} = annotation(fig1,'textarrow',[0.789166666666667 annot.x],...
%     [0.57 annot.y+0.02],'String',{"SOH = "+sprintf('%2.4f', plt.y1(end) )+"%"});
% 
% [annot.x, annot.y] = ds2nfu(plt.x(end), plt.y2(end));
% annot.arrow{2} = annotation(fig1,'textarrow',[0.794956140350877 annot.x],...
%     [0.65 annot.y+0.02],'String',{"SOH = "+sprintf('%2.4f', plt.y2(end))+"%"});
% 
% [annot.x, annot.y] = ds2nfu(plt.x(end), plt.y3(end));
% annot.arrow{3} = annotation(fig1,'textarrow',[0.794956140350877 annot.x],...
%     [0.22  annot.y-0.02],'String',{"SOH = "+sprintf('%2.4f', plt.y3(end))+"%"});

% for i = 1:length(annot.arrow)
%     annot.arrow{i}.FontName = 'Times';
%     annot.arrow{i}.FontSize = text_font;
% end


save_plt(fig1, plt_path, plt_save, "eps");

end