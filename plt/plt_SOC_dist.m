function [] = plt_SOC_dist(DYorNO, plt_path, plt_save, plt_additional)

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

width = 3.5;
height= width/golden_ratio; % For 3 images. 
text_font = 12;


fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');

clear temp;
temp.data = DYorNO.nonsv.bat.SOC;

temp.min = min(temp.data);

temp.data2 = temp.data - temp.min;
temp.max2 = max(temp.data2);

temp.data3 = temp.data2/temp.max2;


h1 = raincloud_plot(temp.data*100 , 'box_on', 1, 'density_type', 'ks');


if(plt_additional.color_SOC_dist==0)
    set(h1{2}, 'MarkerEdgeColor', 'red'); %
    set(h1{1}, 'FaceColor', cb(4, :));
else
    set(h1{2}, 'MarkerEdgeColor', 'green'); %
    set(h1{1}, 'FaceColor', cb(1, :));
end
%set(gca, 'XLim', [17 56]);
%set(gca, 'YLim', [-0.14 0.14]);
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
ylabel('Probability density');
xlabel('SOC / %');
ax1 = gca;

for i_temp = 1:length(ax1.YTickLabel)
        ax1.YTickLabel{i_temp} = '';
end

grid on;
box off

temp.text = sprintf('Mean: %2.2f',mean(100*DYorNO.nonsv.bat.SOC));

temp.ann = annotation(gcf,'textbox',...
    [0.638671232876713 0.897862595419845 0.355712328767123 0.087786259541984],...
    'String',temp.text+"%",...
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

save_plt(fig1, plt_path, plt_save, "png");

end