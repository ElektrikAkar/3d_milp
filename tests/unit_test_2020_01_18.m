% These are units tests to verify results. 

test_DY = DY;
test_NO = NO;
clc;

%% Test for efficiency correctness. 

fprintf('test_DY.effName == test_DY.nonsv.effName: %d, %s\n',test_DY.effName == test_DY.nonsv.effName,test_DY.effName);
fprintf('test_NO.effName == test_NO.nonsv.effName: %d, %s\n',test_NO.effName == test_NO.nonsv.effName,test_NO.effName);

test_DY.quad_eq.Tk % all different.
test_NO.quad_eq.Tk % all same. 

%% Correctness of cost approximation points. 
clc;
close all;
clear quad_eq;
clear test;
quad_eq = func_solve_quad_eq((-9.6:0.1:9.6), 0.05:0.01:0.95, KELVIN + (18:1:45), test_DY.func,1);



% ----- for test -----
test.my_ones = ones(size(quad_eq.t_EOL_h ));
quad_eq.interp3 = @(x1,x2,x3) interp3(quad_eq.SOC.*test.my_ones, quad_eq.P_t.*test.my_ones, quad_eq.Tk.*test.my_ones, data.segm.t_EOL_h,x2,x1,x3,'linear');

test.DY.quad_eq.interp3 =  @(x1,x2,x3) interp3(test_DY.quad_eq.SOC.*ones(size(test_DY.data.segm.t_EOL_h)), ...
                                               test_DY.quad_eq.P_t.*ones(size(test_DY.data.segm.t_EOL_h)),...
                                               test_DY.quad_eq.Tk.*ones(size(test_DY.data.segm.t_EOL_h)),...
                                               test_DY.data.segm.t_EOL_h,   x2,x1,x3,'linear');
                                            
test.DY.interp_results  = test.DY.quad_eq.interp3(quad_eq.P_t,quad_eq.SOC,quad_eq.Tk(:));                                            
                                            
assert(nnz(isnan(test.DY.interp_results))==0);  % No NaNs are allowed.       

test.difference = 100*abs(test.DY.interp_results - data.segm.t_EOL_h)./data.segm.t_EOL_h;

fprintf('Min, max, mean errors [percent]: %4.4f, %4.4f, %4.4f \n',min(test.difference(:)), max(test.difference(:)), mean(test.difference(:)));

%histogram(test.difference(:));


% Another imaginary case: 

test.imag.P_t(:,1)  = linspace(-9.6,9.6,17); %-9.6:2.4:9.6; %-9.6:2.4:9.6;
test.imag.SOC(1,:)  = [0.05,  0.10, 0.15 0.25, 0.32  0.41, 0.68, 0.82 0.95]; % [0.05, 0.1, 0.4, 0.8, 0.95];
test.imag.Tk(1,1,:) = KELVIN + linspace(18,45,5); % KELVIN + linspace(18,45,5);

test.imag.quad_eq = func_solve_quad_eq(test.imag.P_t, test.imag.SOC, test.imag.Tk, test_DY.func,0);

test.imag.interp3 = @(x1,x2,x3) interp3(test.imag.SOC.*ones(test.imag.quad_eq.Nsize), ...
                                               test.imag.P_t.*ones(test.imag.quad_eq.Nsize),...
                                               test.imag.Tk.*ones(test.imag.quad_eq.Nsize),...
                                               test.imag.quad_eq.t_EOL_h,   x2,x1,x3,'linear');

test.imag.interp_results = test.imag.interp3(quad_eq.P_t,quad_eq.SOC,quad_eq.Tk(:));   

assert(nnz(isnan(test.imag.interp_results))==0);  % No NaNs are allowed.   

test.imag.difference = 100*abs(test.imag.interp_results - quad_eq.t_EOL_h)./quad_eq.t_EOL_h;
                                            
fprintf('Test imag Min, max, mean errors [percent]: %4.4f, %4.4f, %4.4f \n',min(test.imag.difference(:)), max(test.imag.difference(:)), mean(test.imag.difference(:)));

histogram(test.imag.difference(:));

%%
