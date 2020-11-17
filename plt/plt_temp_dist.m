function [] = plt_temp_dist(DYorNO, plt_path, plt_save, plt_additional)
KELVIN = 273.15;

try
    % get nice colours from colorbrewer
    % (https://uk.mathworks.com/matlabcentral/fileexchange/34087-cbrewer---colorbrewer-schemes-for-matlab)
    [cb] = cbrewer('qual', 'Set3', 12, 'pchip');
catch
    % if you don't have colorbrewer, accept these far more boring colours
    cb = [0.5 0.8 0.9; 1 1 0.7; 0.7 0.8 0.9; 0.8 0.5 0.4; 0.5 0.7 0.8; 1 0.8 0.5; 0.7 1 0.4; 1 0.7 1; 0.6 0.6 0.6; 0.7 0.5 0.7; 0.8 0.9 0.8; 1 1 0.4];
end

cl(1, :) = cb(4, :);
cl(2, :) = cb(1, :);


golden_ratio = 1.618;
x0 = 1;
y0 = 1;

width = 2.26;
height= width/golden_ratio/1; % For 3 images. 
text_font = 12;


fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');

clear temp;
temp.data = DYorNO.nonsv.bat.Tk(DYorNO.nonsv.bat.Tk>0)-KELVIN;

temp.min = min(temp.data);

temp.data2 = temp.data - temp.min;
temp.max2 = max(temp.data2);

temp.data3 = temp.data2/temp.max2;


h1 = raincloud_plot(temp.data , 'box_on', 1,'density_type', 'ks','band_width',[]);


if(plt_additional.color_temp_dist==0)
    set(h1{2}, 'MarkerEdgeColor', 'red'); %
    set(h1{1}, 'FaceColor', cb(4, :));
elseif(plt_additional.color_temp_dist==1)
    set(h1{2}, 'MarkerEdgeColor', 'green'); %
    set(h1{1}, 'FaceColor', cb(1, :));
elseif(plt_additional.color_temp_dist==2)
    set(h1{2}, 'MarkerEdgeColor', cb(3, :));%'blue'); %
    set(h1{1}, 'FaceColor', cb(3, :));
elseif(plt_additional.color_temp_dist==3)
    % yellow:
    set(h1{2}, 'MarkerEdgeColor', cb(end, :));%'blue'); %
    set(h1{1}, 'FaceColor', cb(6, :));    
    
end
set(gca, 'XLim', [17 55]);
set(gca, 'YLim', [-0.045 0.08]);
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
ylabel('Probability density');
xlabel('Temperature / ^oC');
ax1 = gca;

for i_temp = 1:length(ax1.YTickLabel)
        ax1.YTickLabel{i_temp} = '';
end

grid on;
box off

temp.text = sprintf('Mean: %2.2f',mean(temp.data));

temp.ann = annotation(gcf,'textbox',...
    [0.615671232876713 0.897862595419845 0.385712328767123 0.087786259541984],...
    'String',temp.text+" ^oC",...
    'FitBoxToText','off','EdgeColor','none');
temp.ann.FontName = 'times';
temp.ann.FontSize = text_font;

set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(gcf,'renderer','Painters')

set(gca, 'layer', 'top');

ax = gca;
ax.GridAlpha=0.2;

save_plt(fig1, plt_path, plt_save, "png");

end