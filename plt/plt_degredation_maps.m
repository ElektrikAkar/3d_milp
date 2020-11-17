function [] = plt_degredation_maps(func, plt_path, plt_save, arbj)

 plt_degradation_map2(func, plt_path, plt_save);
plt_degradation_map22(func, plt_path, plt_save, arbj);
end

function [] = plt_degradation_map1(func, plt_path, plt_save)
text_font = 11;
lw = {'LineWidth',1.5};

P   = linspace(-18,18,7);
SOC = linspace(0.05,0.95,5);
Tk  = KELVIN + linspace(18,60,5);

[PX, SOCX, TkX] = ndgrid(P, SOC, Tk);

quad_eq = func_solve_quad_eq(PX, SOCX, TkX, func, false);



golden_ratio = 1.618;
x0 = 1;
y0 = 1;

width  = 8; % 3.5 inch / 9 cm
height = width/golden_ratio/1.5;

fig1=figure('Units','inches',...
    'Position',[x0 y0 (x0+width) (y0+height)],...
    'PaperPositionMode','auto');

ax  = scatter3(PX(:), SOCX(:)*100, TkX(:)-KELVIN, 40, quad_eq.t_EOL_h(:)/24/365,'filled');

set(gca,'ColorScale','log')
cb = colorbar;%('location','northoutside');
colormap(flipud(jet));


ylabel('SOC / %');
xlabel('Cell Power / W');
zlabel('Temperature / \circC ');

cb.Label.String = 'End of life time / years';
cb.Label.FontSize = text_font;
set(gca,...
    'Units','normalized',...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',text_font,...
    'FontName','Times');
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(gcf,'renderer','Painters')

view(-74.8,56)

ax.Parent.Position(2) = 0.1;
cb.Position(1) = 0.935 - cb.Position(3); 

ax.Parent.Position(3) = cb.Position(1) - ax.Parent.Position(1) - 0.07;



if plt_save
    print(fig1, plt_path, '-depsc');
end


end

function [] = plt_degradation_map2(func, plt_path, plt_save)
text_font = 11;
lw = {'LineWidth',1.5};

P   = linspace(-18,18,13);
SOC = linspace(0.05,0.95,19);
Tk  = KELVIN + linspace(18,60,13);

[PX, SOCX, TkX] = ndgrid(P, SOC, Tk);

quad_eq = func_solve_quad_eq(PX, SOCX, TkX, func, false);



golden_ratio = 1.618;
x0 = 1;
y0 = 1;

width  = 8; % 3.5 inch / 9 cm
height = width/golden_ratio/1.7;

fig1=figure('Units','inches',...
    'Position',[x0 y0 (x0+width) (y0+height)],...
    'PaperPositionMode','auto');



xslice = 100*[0.05, 0.35, 0.65, 0.95]; %linspace(0.05,0.95,4);   
yslice = [];
zslice = 18;

ax = slice( SOCX*100,  PX,  TkX-KELVIN,   quad_eq.t_EOL_h/24/365, xslice,yslice,zslice);

set(gca,'ColorScale','log')
cb = colorbar;
colormap(flipud(jet));

xlabel('SOC / %');
ylabel('Cell Power / W');
zlabel('Temperature / \circC ');

cb.Label.String = 'End of life time / years';
cb.Label.FontSize = text_font;
set(gca,...
    'Units','normalized',...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',text_font,...
    'FontName','Times');
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(gcf,'renderer','Painters')

view(-15.71,47.84)

for i_ax = 1:length(ax)

ax(i_ax).Parent.Position(2) = 0.12;
cb.Position(1) = 0.935 - cb.Position(3); 

ax(i_ax).Parent.Position(3) = cb.Position(1) - ax(i_ax).Parent.Position(1) - 0.07;
end

if plt_save
    print(fig1, plt_path, '-depsc');
end

end

function [] = plt_degradation_map11(func, plt_path, plt_save, arbj)
text_font = 11;
lw = {'LineWidth',1.5};

P   = linspace(-18,18,7);
SOC = linspace(0.05,0.95,5);
Tk  = KELVIN + linspace(18,60,5);

[PX, SOCX, TkX] = ndgrid(P, SOC, Tk);

quad_eq = func_solve_quad_eq(PX, SOCX, TkX, func, false);



golden_ratio = 1.618;
x0 = 1;
y0 = 1;

width  = 7; % 3.5 inch / 9 cm
height = width/golden_ratio/1.5;

fig1=figure('Units','inches',...
    'Position',[x0 y0 (x0+width) (y0+height)],...
    'PaperPositionMode','auto');

ax = scatter3(PX(:), SOCX(:)*100, TkX(:)-KELVIN, 40, arbj.bat.Cost_whole./quad_eq.t_EOL_h(:),'filled');

set(gca,'ColorScale','log')
cb = colorbar; %('location','northoutside')
colormap hsv
ylabel('SOC / %');
xlabel('Cell Power / W');
zlabel('Temperature / \circC ');

cb.Label.String = 'Battery cost / EUR/h';
cb.Label.FontSize = text_font;
set(gca,...
    'Units','normalized',...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',text_font,...
    'FontName','Times');
%set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(gcf,'renderer','Painters')

view(-74.8,56)

ax.Parent.Position(2) = 0.15;
cb.Position(1) = 0.935 - cb.Position(3); 

ax.Parent.Position(3) = cb.Position(1) - ax.Parent.Position(1) - 0.07;
ax.Parent.Position(1) = 0.08;
if plt_save
    print(fig1, plt_path, '-depsc');
end


end

function [] = plt_degradation_map22(func, plt_path, plt_save, arbj)
text_font = 11;
lw = {'LineWidth',1.5};

P   = linspace(-18,18,13);
SOC = linspace(0.05,0.95,19);
Tk  = KELVIN + linspace(18,60,13);

[PX, SOCX, TkX] = ndgrid(P, SOC, Tk);

quad_eq = func_solve_quad_eq(PX, SOCX, TkX, func, false);



golden_ratio = 1.618;
x0 = 1;
y0 = 1;

width  = 8; % 3.5 inch / 9 cm
height = width/golden_ratio/1.7;

fig1=figure('Units','inches',...
    'Position',[x0 y0 (x0+width) (y0+height)],...
    'PaperPositionMode','auto');



xslice = 100*[0.05, 0.35, 0.65, 0.95]; %linspace(0.05,0.95,4);   
yslice = [];
zslice = 18;

ax = slice( SOCX*100,  PX,  TkX-KELVIN,   arbj.bat.Cost_whole./quad_eq.t_EOL_h, xslice,yslice,zslice);

set(gca,'ColorScale','log')
cb = colorbar;
mycolormap = customcolormap(linspace(0,1,11), {'#a60126','#d7302a','#f36e43','#faac5d','#fedf8d','#fcffbf','#d7f08b','#a5d96b','#68bd60','#1a984e','#006936'});
colormap jet;

xlabel('SOC / %');
ylabel('Cell Power / W');
zlabel('Temperature / \circC ');

cb.Label.String = 'Battery cost / EUR/h';
cb.Label.FontSize = text_font;
set(gca,...
    'Units','normalized',...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',text_font,...
    'FontName','Times');
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(gcf,'renderer','Painters')

view(-15.71,47.84)

for i_ax = 1:length(ax)

ax(i_ax).Parent.Position(2) = 0.12;
cb.Position(1) = 0.935 - cb.Position(3); 

ax(i_ax).Parent.Position(3) = cb.Position(1) - ax(i_ax).Parent.Position(1) - 0.07;
end

if plt_save
    print(fig1, plt_path, '-depsc');
end

end

