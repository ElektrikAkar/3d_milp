function [] = plt_SOH_comparison3_1y(DY, NO, noSOC, plt_path, plt_save, plt_additional)
% Compare 3 cases: 
% Author: Vk
% Date  : 2020.07.21

text_font = 11;
lw = {'LineWidth',1.3};
lw2 = {'LineWidth',1.5};

color.green     = [0.4660, 0.6740, 0.1880];
color.light_red = [0.8500, 0.3250, 0.0980];
color.yellow    = [0.9290, 0.6940, 0.1250];
color.purple    = [0.4940, 0.1840, 0.5560];


golden_ratio = 1.618;
x0 = 1;
y0 = 1;

width  = 3.3; % 3.5 inch / 9 cm 
height = width/golden_ratio;

% plt.common.time_h = (0:NO.nonsv.dth:((NO.nonsv.Nh)*NO.nonsv.dth))';
% plt.common.time_m = plt.common.time_h/24/365;

ext_DY    = func_SOH_extrapolate(DY, plt_additional.SOH_fitting);
ext_NO    = func_SOH_extrapolate(NO, plt_additional.SOH_fitting);
ext_noSOC = func_SOH_extrapolate(noSOC, plt_additional.SOH_fitting);


fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');

plt.h(1) = plot(ext_DY.t_y,   ext_DY.SOH,    'Color', color.green,  lw{:});
grid on;
hold on;
plt.h(2) = plot(ext_NO.t_y,    ext_NO.SOH,    'Color', color.yellow,  lw{:});
plt.h(3) = plot(ext_noSOC.t_y, ext_noSOC.SOH, 'Color', color.light_red,  lw{:});

uistack(plt.h(1),'top');

xlabel('time / years');
ylabel('SOH / %');

plt.h(4) = plot(ext_DY.t_ext_y,   ext_DY.SOH_ext, ':', 'Color',color.green, lw2{:});
plt.h(5) = plot(ext_NO.t_ext_y,   ext_NO.SOH_ext, ':', 'Color',color.yellow, lw2{:});

plt.h(6) = plot(ext_noSOC.t_ext_y,   ext_noSOC.SOH_ext,':', 'Color',color.light_red, lw2{:});

xlim([-0.5,1.02*ceil(ext_DY.t_EOL_y)]);
ylim([79.5,100.5]);

legend(plt.h(1:3),'Case 1', 'Case 2','Case 3','Location','Southwest');
set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(gcf,'renderer','Painters')

[small.x1, small.y1] = ds2nfu(4,90);
[small.x2, small.y2] = ds2nfu(8,100);

small.dx = small.x2 - small.x1;
small.dy = small.y2 - small.y1;

ax2 =axes('position',[small.x1 small.y1 small.dx small.dy]); box on;
plt.h(7) = plot(ext_DY.t_y,   ext_DY.SOH,    'Color', color.green,  lw{:});
grid on;
hold on;
plt.h(8) = plot(ext_NO.t_y,    ext_NO.SOH,    'Color', color.yellow,  lw{:});
plt.h(9) = plot(ext_noSOC.t_y, ext_noSOC.SOH, 'Color', color.light_red,  lw{:});

thr = 1.44;
plt.h(10) = plot(ext_DY.t_ext_y(ext_DY.t_ext_y<=thr),   ext_DY.SOH_ext(ext_DY.t_ext_y<=thr), ':', 'Color',color.green, lw2{:});
plt.h(11) = plot(ext_NO.t_ext_y(ext_NO.t_ext_y<=thr),   ext_NO.SOH_ext(ext_NO.t_ext_y<=thr), ':', 'Color',color.yellow, lw2{:});

plt.h(12) = plot(ext_noSOC.t_ext_y(ext_NO.t_ext_y<=thr),   ext_noSOC.SOH_ext(ext_NO.t_ext_y<=thr),':', 'Color',color.light_red, lw2{:});
set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
%set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
%set(gcf,'renderer','Painters')
xlim([0,1.26]);

ax2.XTick = 0:0.2:1.2;

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