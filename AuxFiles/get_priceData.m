function priceStruct = get_priceData(data_tag)
% This function gets the price data. 
% Author : VK
% Date   : 2020.05.05
%---------------------------------
% Inputs:
% data_tag: Name of the data:
%
% Outputs:
% priceStruct.data_tag : Data Tag     (string/char array)
% priceStruct.filename : File name    (string/char array)
% priceStruct.path     : Full path    (string/char array)
% priceStruct.values   : Price values (double Nx1 array) [kWh]
% priceStruct.dth      : Time step    (double 1x1) [h] 


pathStruct = get_paths(); % First, get paths where data lies. 

priceStruct = struct();
priceStruct.data_tag = data_tag;
switch data_tag
    case "EPEX"
        priceStruct.filename = "intraday_results_germany_austria_2017.mat";
        priceStruct.path     = fullfile(pathStruct.data.main, 'priv', priceStruct.filename);
        
        temp                 = load(priceStruct.path);   % Temporary! 
        priceStruct.values   = temp.Data.Profile_1/1e3; 
        priceStruct.dth      = 1/4; 
        
    case "idc_2018_last"
        priceStruct.filename = "profile_price_idc_last_2018.mat";
        priceStruct.path     = fullfile(pathStruct.data.main, 'priv', priceStruct.filename);
        
        temp                 = load(priceStruct.path);   % Temporary! 
        priceStruct.values   = temp.profile_price_idc_last_2018(1:15:end);
        priceStruct.dth      = 1/4;         
        
    case "idc_2018_wap"
        priceStruct.filename = "profile_price_idc_wap_2018.mat";
        priceStruct.path     = fullfile(pathStruct.data.main, 'priv', priceStruct.filename);
        
        temp                 = load(priceStruct.path);   % Temporary! 
        priceStruct.values   = temp.profile_price_idc_wap_2018(1:15:end);
        priceStruct.dth      = 1/4;    

    case "dayaheadauktion"
        priceStruct.filename = "dayaheadauktion_data_EURperMWh.csv";
        priceStruct.path     = fullfile(pathStruct.data.CSV, 'priv', priceStruct.filename);
        
        temp                 = csvread(priceStruct.path, 1);   % Temporary! 
        priceStruct.values   = temp(:)/1e3;
        priceStruct.dth      = 1;        
        
    case "square_wave"
        priceStruct.filename = "";
        priceStruct.path     = "";
        
        priceStruct.values   = repmat([0.1*ones(4,1);10*ones(4,1)],12*15,1);
        priceStruct.dth      = 1/4;
        
    case "first_oneday"
        priceStruct.filename = "price_dayprice_signal.csv";
        priceStruct.path     = fullfile(pathStruct.data.CSV, 'priv', priceStruct.filename);
        
        temp                 = csvread(priceStruct.path, 1);  % Temporary! 
        priceStruct.values   = temp(:,3);
        priceStruct.dth      = 1;
        
    case "test_diverging"
        priceStruct.filename = "";
        priceStruct.path     = "";
        
        [temp.values, temp.dth] = data_test_diverging(); % Prepare a test data diverging. 
        priceStruct.values   = temp.values;
        priceStruct.dth      = temp.dth; 
        
        
    % Open data files: 
    
    case "random_data_similar_idc"
        priceStruct.filename = "profile_price_random_data_similar_idc_last.mat";
        priceStruct.path     = fullfile(pathStruct.data.main, priceStruct.filename);
        
        temp                 = load(priceStruct.path);   % Temporary! 
        priceStruct.values   = temp.random_prices;
        priceStruct.dth      = 1/4;       
        
    otherwise
        error("Unknown data tag");
end

priceStruct.values = double(priceStruct.values); % To convert if not double!



end