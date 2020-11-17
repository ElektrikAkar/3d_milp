function [] = plt_SOC_dist_hist(DYorNO, plt_path, plt_save, plt_additional)

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

width = 2.3;
height= width/golden_ratio; % For 3 images. 
text_font = 12;


fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');

clear temp;
temp.data = 100*DYorNO.nonsv.bat.SOC(1:DYorNO.nonsv.i); %(DYorNO.nonsv.bat.SOC>0)

% temp.min = min(temp.data);
% 
% temp.data2 = temp.data - temp.min;
% temp.max2 = max(temp.data2);
% 
% temp.data3 = temp.data2/temp.max2;

edges = 100*linspace(0,1,22);
h1 = histogram(temp.data, edges);
ax = gca;
temp_perct = 0.01*(0:5:40); 
max_perct = 0.25; % temp_perct(find(diff(temp_perct<(max(h1.Values)/length(temp.data)))==-1)+1);

my_ylimfreq =  max_perct*length(temp.data);

ylim([0,my_ylimfreq]);

ax.YTick = (0:0.05:my_ylimfreq/length(temp.data))*length(temp.data);
ax.YTickLabel = cellstr(num2str(100*ax.YTick'/length(temp.data)));
switch plt_additional.color_SOC_dist
    case 0
        set(h1, 'FaceColor', cb(4, :)); % red
    case 1
        set(h1, 'FaceColor', cb(1, :)); % green
    case 2
        set(h1, 'FaceColor', cb(3, :)); % purple
    case 3
        set(h1, 'FaceColor', cb(6, :)); % purple
    otherwise
        error('plt_additional.color_SOC_dist value is unknown');
end


    

%set(gca, 'XLim', [17 56]);
%set(gca, 'YLim', [-0.14 0.14]);
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
ylabel('Frequency / %');
xlabel('SOC / %');
ax1 = gca;

% for i_temp = 1:length(ax1.YTickLabel)
%         ax1.YTickLabel{i_temp} = '';
% end

grid on;
box off

temp.text = sprintf('Mean: %2.2f',mean(temp.data));

temp.ann = annotation(gcf,'textbox',...
    [0.588671232876713 0.857862595419845 0.355712328767123 0.087786259541984],...
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


save_plt(fig1, plt_path, plt_save, "eps");

end