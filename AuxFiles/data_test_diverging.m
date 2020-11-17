function [prices,dt] = data_test_diverging()
% Created a diverging test data. 

base_price =  1; %EUR /kWh  

rate = 3; %0.1 percent increase rate. 

dt  = 1/4; %hours of time step. 

length = 7*24; % 1 week should be enough. 


%-----------
num_of_elements = length/dt/2;

positive = zeros(num_of_elements,1);
negative = zeros(num_of_elements,1);


prices = [positive;negative]; %Not exactly but sizing is correct :) 

positive(1,1) = base_price;
negative(1,1) = base_price;


positive(2:end,1) =  base_price*rate/100;
negative(2:end,1) = -base_price*rate/100;

positive = cumsum(positive);
negative = cumsum(negative);

prices(1:2:end-1) = positive;
prices(2:2:end)   = negative;


end

