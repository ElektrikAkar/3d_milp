function [] = save_plt(fig, plt_path, plt_save, plt_type)
% This function is to save plot files. 
% Author: VK
% Date  : 2020.05.06

% Argument order, plt_save, plt_path, type, 

if(iscell(plt_type))
    other_set = plt_type;
    
elseif(strcmpi(plt_type, "png"))
    other_set = {'-dpng','-r800'};
    plt_path2  = plt_path + ".png";
    
elseif(strcmpi(plt_type, "eps"))
    other_set = {'-depsc'};
    plt_path2  = plt_path + ".eps";
    
else
    error('plt_type is unknown.');
end

switch plt_save
    case 1
        print(fig,   plt_path2, other_set{:} );
    case 2
        print(fig,   plt_path2, other_set{:} );
        savefig(fig, plt_path + ".fig");
end



end