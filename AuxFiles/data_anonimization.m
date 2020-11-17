% This file randomize the data to anonimize it and creates a dummy data. 
% Author : VK
% Date   : 2020.11.04

anon.price2d = reshape(data.price.values,365,[]);
anon.dummy2d = unifrnd(0.8,1.2, size(anon.price2d) ).*anon.price2d;
random_prices = reshape(anon.dummy2d, size(data.price.values));

save(fullfile(SimulSettings.path.data.main, 'profile_price_random_data_similar_idc_last.mat'),'random_prices');