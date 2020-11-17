function data_segm = func_create_segmentation(SimulSettings, func, param, saveSettings)
% Create segmentation. 
% An updated version of create_segmentation.m 
% Author : VK
% Date   : 2020.04.29
% Update : 2020.07.04

KELVIN      = 273.15; 

%folder_name = SimulSettings.path.data.main+"/";
file_name   = "temp_paper_data_segm";
file_path   = fullfile(SimulSettings.path.data.main, file_name+".mat");


if(SimulSettings.segm.battery=="equi")
    data_segm.equi  = true; % if this is true it basically divides things into equally spaced segments. Easier and first method.
else
    data_segm.equi  = false; % On-going implementation. 
end

data_segm.P.n   = SimulSettings.segm.P.n;   % Number of segments for power; MUST BE even number to include 0. (16 IDEAL)
data_segm.SOC.n = SimulSettings.segm.SOC.n; % Number of segments for SOC.  %Defined by following not here. 
data_segm.T.n   = SimulSettings.segm.T.n;   % Number of segments for temperature.  % 8 is ideal. for equivalent. 2 is (39-34)/34 difference. 15% ERROR.


data_segm.C_min = -SimulSettings.C_rate_disch;
data_segm.C_max =  SimulSettings.C_rate_ch;

data_segm.P.min =  data_segm.C_min*9.6;  % -10W for minimum power. 
data_segm.P.max =  data_segm.C_max*9.6/0.85;   % 10W for maximum cell power.  % Because of the efficiency loss in charging. 1 C is considered.

data_segm.I_min = data_segm.C_min*param.cell.Cnom; 
data_segm.I_max = data_segm.C_max*param.cell.Cnom; 

data_segm.SOC.min= 0.048; 
data_segm.SOC.max= 0.952; 

data_segm.T.min = KELVIN + 18; % 18 degrees for minimum temperature. 
data_segm.T.max = KELVIN + 60; % 60 Celcius degrees for max temp. 



if(data_segm.equi)
    data_segm.T.x(1,1,:)      = (linspace(data_segm.T.min,data_segm.T.max,data_segm.T.n+1));
    %data_segm.SOC.x(1,:)  =      (linspace(data_segm.SOC.min,data_segm.SOC.max,data_segm.SOC.n+1));
    data_segm.SOC.x(1,:)      =  [0.048,  0.10, 0.15 0.25, 0.32  0.41, 0.65, 0.82 0.952];
    
    temp_SOC_X = ones(size(data_segm.T.x)).*data_segm.SOC.x;
    temp_T_X   = ones(size(data_segm.SOC.x)).*data_segm.T.x;
    
    temp_P_minX  = func.It_to_Pt(data_segm.I_min,temp_SOC_X,temp_T_X);
    temp_P_maxX  = func.It_to_Pt(data_segm.I_max,temp_SOC_X,temp_T_X);
    
    temp_P_allX  = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
    
    
    for iii=1:size(temp_P_minX,2)
        for jjj=1:size(temp_P_minX,3)
            temp_low  = temp_P_minX(1,iii,jjj);
            temp_high = temp_P_maxX(1,iii,jjj);
            temp_first_half = linspace(temp_low,0,data_segm.P.n/2 +1);
            temp_sec_half   = linspace(0,temp_high,data_segm.P.n/2 +1);
            
            temp_P_allX(:,iii,jjj) = [temp_first_half,temp_sec_half(2:end)];
            
        end
    end
    
    data_segm.P.X = temp_P_allX;
    
    
    %data_segm.SOC.x(1,:)  = (linspace(data_segm.SOC.min,data_segm.SOC.max,data_segm.SOC.n+1));
    %data_segm.SOC.x(1,:)      = [0.048,  0.10, 0.15 0.25, 0.32  0.41, 0.68, 0.82 0.952];
    data_segm.T.x(1,1,:)      = (linspace(data_segm.T.min,data_segm.T.max,data_segm.T.n+1));
    

    data_segm.SOC.X = data_segm.SOC.x.*ones(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
    data_segm.T.X   = data_segm.T.x  .*ones(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
    
else
    
    if(data_segm.P.n==16 && data_segm.SOC.n==8 && data_segm.T.n==8 && data_segm.C_min==-2 && data_segm.C_max ==1)
        temp_segm = load( fullfile(SimulSettings.path.data.fit, 'x_0_21074225_zero.mat') );
        
        data_segm.P.x(:,1)   =  temp_segm.x(1:(temp_segm.data_segm.P.n+1));
        data_segm.SOC.x(1,:) = temp_segm.x((temp_segm.data_segm.P.n+2):(temp_segm.data_segm.P.n+2+temp_segm.data_segm.SOC.n));
        data_segm.T.x(1,1,:) = temp_segm.x((temp_segm.data_segm.P.n+3+temp_segm.data_segm.SOC.n):end);
        
        [data_segm.P.X, data_segm.SOC.X, data_segm.T.X] = ndgrid(data_segm.P.x, data_segm.SOC.x, data_segm.T.x);
        
        
    else
        error('We do not have data for this optimal PWA, use equal distance setting "equi"');
    end
end

% if it is not dynamic mode, replace SOC or T values with constant values
% before calculating important approximation values. 

%pseudo X for non-dynamic cases. Not to change actual X values. 
data_segm.SOC.Xp = data_segm.SOC.X; %
data_segm.T.Xp   = data_segm.T.X;

if(SimulSettings.SOCmode ~= "dynamic")
    data_segm.SOC.Xp(:) = SimulSettings.const.SOC;
end

if(SimulSettings.tempMode ~= "dynamic")
    data_segm.T.Xp(:)   = SimulSettings.const.Tk;
end


%Specially determined points, see plot_fun for figures.
%(linspace(data_segm.SOC.min,data_segm.SOC.max,data_segm.SOC.n+1));

data_segm.P_AC_kW      = [-345.6,-200,-100,-12,0,2.3,58,148,240,345.6]'; % Cellwise -17.3077 - 17.3077

data_segm.dQcell_Pt    = func.dQcell_Pt(data_segm.P.X, data_segm.SOC.Xp, data_segm.T.Xp);

data_segm.dTcell0_Pt   = func.dTcell0_Pt(data_segm.P.X, data_segm.SOC.Xp, data_segm.T.Xp);

data_segm.I_cell_Pt    = func.It(data_segm.P.X, data_segm.SOC.Xp, data_segm.T.Xp);

data_segm.t_EOL_h      = func_solve_quad_eq(data_segm.P.X, data_segm.SOC.Xp, data_segm.T.Xp, func, false).t_EOL_h;


data_segm.P_AC_loss_kW = func.only_PE_loss(data_segm.P_AC_kW);
data_segm.P.zero       = find(data_segm.P.X(:,1,1)==0);       % Zero crossing point for power!
data_segm.P_AC_zero    = find(data_segm.P_AC_kW == 0);


my_fields = fields(data_segm);
for i_fields =1:length(my_fields)
    if(isstruct(data_segm.(my_fields{i_fields})))
        continue;
    end
    if(nnz(isnan(data_segm.(my_fields{i_fields})))~=0)
        disp((my_fields{i_fields})+ " has NaN values.")
        % assert(false,'There is NaN in segmentation data.');
    end
end

if (saveSettings)
    save(file_path,'-struct','data_segm');
end
end