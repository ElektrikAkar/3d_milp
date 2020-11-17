function [] = plt_Uk(thisResults, func, plt_path, plt_save)
% Plot terminal voltage of battery; 
% Author: VK
% Date  : 2020.07.29

text_font = 11;
lw = {'LineWidth',1};

golden_ratio = 1.618;
x0 = 1;
y0 = 1;

width  = 3.5; % 3.5 inch / 9 cm 
height = width/golden_ratio;


fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');

thisCase.n = length(thisResults.nonsv.bat.I_cell);
MovMean = spdiags(0.5*ones(thisCase.n+1, 2), 0:1, thisCase.n, thisCase.n+1);
thisCase.MovMean.SOC = MovMean*thisResults.nonsv.bat.SOC;
thisCase.MovMean.Tk  = MovMean*thisResults.nonsv.bat.Tk;

Uk = zeros(length(thisResults.nonsv.bat.I_cell),1);

U_OCV = func.U_OCV(thisCase.MovMean.SOC);
dU = func.dU(thisResults.nonsv.bat.I_cell, thisCase.MovMean.SOC, thisCase.MovMean.Tk);

Uk = U_OCV + dU;





plot((0.5:length(thisResults.nonsv.bat.Tk)-1.5)*thisResults.nonsv.dth/24,Uk,lw{:}); grid on;



%legend('Temperature effect included', 'Temperature effect not included','location','southeast');
xlabel('Time / days');
ylabel('Cell Voltage / V');

xlim([0,30])


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