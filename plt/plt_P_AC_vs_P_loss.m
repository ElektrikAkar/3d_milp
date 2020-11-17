function [] = plt_P_AC_vs_P_loss(DY, plt_path, plt_save, plt_additional)

text_font = 11;
lw = {'LineWidth',1.5};

x0 = 1;
y0 = 1;

width = 3.3;
height= 1.5; 
golden_ratio = 1.618;

fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');



plot(DY.data.only_PE_loss.P_AC_kW, DY.data.only_PE_loss.P_loss_kW, lw{:});
grid on; hold on;
plot(DY.data.segm.P_AC_kW,DY.data.segm.P_AC_loss_kW, '*--', lw{:});


ylabel('L_{AC} / kW');
xlabel('P_{AC} / kW');

legend('Actual', 'Approximated','location','southeast','Position',[0.3905    0.7881    0.3099    0.1521]);


set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',text_font,...
'FontName','Times');
%xtickangle(45)
if(plt_additional.gray_code_ON)
    grayAC = findGrayWeightIndicators(length(DY.data.segm.P_AC_kW)-1,0,0);
    codes  = num2str(vertcat(grayAC.code{:}));
    codes  = codes(:,1:3:end);
    text(-267,7,codes(1,:))
    text(-145,4.3,codes(2,:))
    
    [x1,y1] = ds2nfu(-140,1.8);
    [x2,y2] = ds2nfu(-65,2.2);
    
    x = [x1, x2];
    y = [y1, y2];
    annotation('textarrow',x,y,'String',codes(3,:))

    
  %  text(-120,2,codes(3,:))
    text(-90,0.8,codes(4,:))
    text(17,0.8,codes(5,:))
    
    [x1,y1] = ds2nfu(120,1.3);
    [x2,y2] = ds2nfu(40,2);
    x = [x1, x2];
    y = [y1, y2];
    annotation('textarrow',x,y,'String',codes(6,:))

    
%    text(25,2, codes(6,:))
    text(120,3.1,codes(7,:))
    text(220,4.9,codes(8,:))
    text(310,7.2,codes(9,:))
end

ax1= gca;
set(gcf,'renderer','Painters')


save_plt(fig1, plt_path, plt_save, "eps");

end