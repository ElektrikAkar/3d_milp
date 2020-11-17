function [] = plt_t_EOL(func, plt_path, plt_save)
text_font = 11;
lw = {'LineWidth',1.5};
% figure;
% scatter3(quad_eq.X(:),quad_eq.Y(:),quad_eq.Z(:),40,quad_eq.V,'filled');
% set(gca,'ColorScale','log')
% cb = colorbar;
% 
% ylabel('SOC [%]');
% xlabel('Cell Current [A]');
% zlabel('Temperature [\circC]');
% 
% cb.Label.String = 'Years of t_{EOL}';
% cb.Label.FontSize = 16;
% set(gca,'fontsize',16);


%plt.quad_eq = func_solve_quad_eq(data.segm.P.x,data.segm.SOC.x,data.segm.T.x,func,1);

% golden_ratio = 1.618;
% x0 = 1;
% y0 = 1;
% 
% width = 6.5;
% height= width/golden_ratio/1.4; % For 3 images. 
% text_font = 12;
% 
% fig1=figure('Units','inches',...
% 'Position',[x0 y0 (x0+width) (y0+height)],...
% 'PaperPositionMode','auto');
% 

% %set(gca,'fontsize',16);
% 
% set(gca,...
% 'Units','normalized',...
% 'FontUnits','points',...
% 'FontWeight','normal',...
% 'FontSize',text_font,...
% 'FontName','Times');
% set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
% view([-15.0599, 45.3197]);
% 
% batchPath_plot = "Plot_2020_01_31/";
% 
% set(gcf,'renderer','Painters')
% print((batchPath_plot+'t_EOL_plot.eps'),'-depsc');

[PX, SOCX, TX] = meshgrid(linspace(-20,10,20), linspace(0.05,0.95,25), linspace(18,60,20)+KELVIN);
%[PX, SOCX, TX] = meshgrid(linspace(-20,10,40), linspace(0.05,0.95,40), linspace(18,60,40)+KELVIN);

t_EOL_h = func_solve_quad_eq(PX, SOCX, TX, func, false).t_EOL_h;



x0 = 1;
y0 = 1;

golden_ratio = 1.618;
width = 6;
height= width/golden_ratio/1.4; %1.5; 


fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');

[cb_colors] = cbrewer('div', 'RdYlGn', 400, 'pchip');

xslice = [];%[-8,-5,0,5,8]; %linspace(0.05,0.95,4);   
yslice = 100*[0.05, 0.5, 0.95];
zslice = 18;
h = slice(PX,  100*SOCX, TX-KELVIN, min(t_EOL_h/24/365,20), xslice, yslice, zslice);
 %   set(gca,'ColorScale','log')
    cb = colorbar;
colormap(cb_colors);
%caxis([0.3 20]);

%set(h,'edgecolor','none')
cb.TickLabels = cellstr(string(cb.Ticks(:)));
xlabel('Cell Power / W');
ylabel('SOC / %');
zlabel('Temperature / \circC');

cb.Label.String = 't_{EOL} / years';
cb.Label.FontSize = text_font;
%set(h,'EdgeAlpha',0.2)
set(h,'edgecolor',[1,1,1]*0.75)





set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
%xtickangle(45)

set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(gcf,'renderer','Painters')

view(63.9652, 46.6782);
save_plt(fig1, plt_path, plt_save, "eps");

end