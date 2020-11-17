
%% We Should test optimally spaces points! 
clear optPoints
temp = load('x_0_21074225_zero.mat');

optPoints.P  = temp.x(1:(temp.data_segm.P.n+1)); 
optPoints.SOC = temp.x((temp.data_segm.P.n+2):(temp.data_segm.P.n+2+temp.data_segm.SOC.n)); 
optPoints.Tk  = temp.x((temp.data_segm.P.n+3+temp.data_segm.SOC.n):end); 

[optPoints.PX, optPoints.SOCX, optPoints.TkX] = ndgrid(optPoints.P, optPoints.SOC, optPoints.Tk);

optPoints.cost = arbj.bat.Cost_whole./func_solve_quad_eq(optPoints.PX, optPoints.SOCX, optPoints.TkX, func, 0).t_EOL_h;

G = griddedInterpolant(optPoints.PX, optPoints.SOCX, optPoints.TkX, optPoints.cost);


%%

lw = {'Linewidth',1.5};
optPoints.test.P   = optPoints.P(15);
optPoints.test.SOC = (0.05:0.005:0.95);
optPoints.test.Tk  =  optPoints.Tk(4); 

[optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX] = ndgrid(optPoints.test.P, optPoints.test.SOC, optPoints.test.Tk);

optPoints.test.cost = G([optPoints.test.PX(:), optPoints.test.SOCX(:), optPoints.test.TkX(:)]);


figure; plot(optPoints.test.SOC, arbj.bat.Cost_whole./func_solve_quad_eq(optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX, func, 0).t_EOL_h,lw{:})
grid on
xlabel('SOC')
ylabel('Battery cost [EUR/h]')
hold on



plot(optPoints.test.SOC(:), optPoints.test.cost(:),'--',lw{:});
%%
optPoints.test.Tk  =  35+KELVIN; 

[optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX] = ndgrid(optPoints.test.P, optPoints.test.SOC, optPoints.test.Tk);
optPoints.test.cost = G([optPoints.test.PX(:), optPoints.test.SOCX(:), optPoints.test.TkX(:)]);
plot(optPoints.test.SOC, arbj.bat.Cost_whole./func_solve_quad_eq(optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX, func, 0).t_EOL_h,lw{:})
plot(optPoints.test.SOC(:), optPoints.test.cost(:),'--',lw{:});

optPoints.test.Tk  =  45+KELVIN; 

[optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX] = ndgrid(optPoints.test.P, optPoints.test.SOC, optPoints.test.Tk);
optPoints.test.cost = G([optPoints.test.PX(:), optPoints.test.SOCX(:), optPoints.test.TkX(:)]);
plot(optPoints.test.SOC, arbj.bat.Cost_whole./func_solve_quad_eq(optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX, func, 0).t_EOL_h,lw{:})
plot(optPoints.test.SOC(:), optPoints.test.cost(:),'--',lw{:});

optPoints.test.Tk  =  55+KELVIN; 

[optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX] = ndgrid(optPoints.test.P, optPoints.test.SOC, optPoints.test.Tk);
optPoints.test.cost = G([optPoints.test.PX(:), optPoints.test.SOCX(:), optPoints.test.TkX(:)]);
plot(optPoints.test.SOC, arbj.bat.Cost_whole./func_solve_quad_eq(optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX, func, 0).t_EOL_h,lw{:})
plot(optPoints.test.SOC(:), optPoints.test.cost(:),'--',lw{:});

% plot((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(-2, (0.05:0.01:0.95)', 45+KELVIN,func, 0).t_EOL_h)
% plot((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(-2, (0.05:0.01:0.95)', 55+KELVIN,func, 0).t_EOL_h)
% 
legend('25^oC','35^oC', '45^oC', '55^oC','location','northwest')


%%
lw = {'Linewidth',1.5};
optPoints.test.P   = optPoints.P(1):0.1:optPoints.P(end);
optPoints.test.SOC =  0.1;
optPoints.test.Tk  =  25+KELVIN; 

[optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX] = ndgrid(optPoints.test.P, optPoints.test.SOC, optPoints.test.Tk);

optPoints.test.cost = G([optPoints.test.PX(:), optPoints.test.SOCX(:), optPoints.test.TkX(:)]);


figure; plot(optPoints.test.P, arbj.bat.Cost_whole./func_solve_quad_eq(optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX, func, 0).t_EOL_h,lw{:})
grid on
xlabel('SOC')
ylabel('Battery cost [EUR/h]')
hold on


plot(optPoints.test.P(:), optPoints.test.cost(:),'--',lw{:});



optPoints.test.Tk  =  35+KELVIN; 

[optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX] = ndgrid(optPoints.test.P, optPoints.test.SOC, optPoints.test.Tk);
optPoints.test.cost = G([optPoints.test.PX(:), optPoints.test.SOCX(:), optPoints.test.TkX(:)]);

plot(optPoints.test.P, arbj.bat.Cost_whole./func_solve_quad_eq(optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX, func, 0).t_EOL_h,lw{:})
plot(optPoints.test.P(:), optPoints.test.cost(:),'--',lw{:});

optPoints.test.Tk  =  45+KELVIN; 

[optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX] = ndgrid(optPoints.test.P, optPoints.test.SOC, optPoints.test.Tk);
optPoints.test.cost = G([optPoints.test.PX(:), optPoints.test.SOCX(:), optPoints.test.TkX(:)]);
plot(optPoints.test.P, arbj.bat.Cost_whole./func_solve_quad_eq(optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX, func, 0).t_EOL_h,lw{:})
plot(optPoints.test.P(:), optPoints.test.cost(:),'--',lw{:});

optPoints.test.Tk  =  55+KELVIN; 

[optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX] = ndgrid(optPoints.test.P, optPoints.test.SOC, optPoints.test.Tk);
optPoints.test.cost = G([optPoints.test.PX(:), optPoints.test.SOCX(:), optPoints.test.TkX(:)]);
plot(optPoints.test.P, arbj.bat.Cost_whole./func_solve_quad_eq(optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX, func, 0).t_EOL_h,lw{:})
plot(optPoints.test.P(:), optPoints.test.cost(:),'--',lw{:});

% plot((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(-2, (0.05:0.01:0.95)', 45+KELVIN,func, 0).t_EOL_h)
% plot((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(-2, (0.05:0.01:0.95)', 55+KELVIN,func, 0).t_EOL_h)
% 
legend('25^oC','35^oC', '45^oC', '55^oC','location','northwest')


%%
%Here is a problem with third dimension. func_solve_quad_eq does not solve it. gives problem numbers
myFlatten = @(x) reshape(x,[],1);

lw = {'Linewidth',1.5};
optPoints.test.P   =  1;%optPoints.P(1):0.1:optPoints.P(end);
optPoints.test.SOC =  0.1;
optPoints.test.Tk  =  optPoints.Tk(1):1:optPoints.Tk(end); 

[optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX] = ndgrid(optPoints.test.P, optPoints.test.SOC, optPoints.test.Tk);

optPoints.test.cost = G([optPoints.test.PX(:), optPoints.test.SOCX(:), optPoints.test.TkX(:)]);


figure; plot(optPoints.test.Tk, myFlatten(arbj.bat.Cost_whole./func_solve_quad_eq(optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX, func, 0).t_EOL_h), lw{:})
grid on
xlabel('SOC')
ylabel('Battery cost [EUR/h]')
hold on


plot(optPoints.test.Tk(:), optPoints.test.cost(:),'--',lw{:});



optPoints.test.SOC  =  0.2; 

[optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX] = ndgrid(optPoints.test.P, optPoints.test.SOC, optPoints.test.Tk);
optPoints.test.cost = G([optPoints.test.PX(:), optPoints.test.SOCX(:), optPoints.test.TkX(:)]);

plot(optPoints.test.Tk, myFlatten(arbj.bat.Cost_whole./func_solve_quad_eq(optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX, func, 0).t_EOL_h), lw{:})
plot(optPoints.test.Tk(:), optPoints.test.cost(:),'--',lw{:});


optPoints.test.SOC  =  0.3;

[optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX] = ndgrid(optPoints.test.P, optPoints.test.SOC, optPoints.test.Tk);
optPoints.test.cost = G([optPoints.test.PX(:), optPoints.test.SOCX(:), optPoints.test.TkX(:)]);
plot(optPoints.test.Tk, myFlatten(arbj.bat.Cost_whole./func_solve_quad_eq(optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX, func, 0).t_EOL_h), lw{:})
plot(optPoints.test.Tk(:), optPoints.test.cost(:),'--',lw{:});

optPoints.test.SOC  =  0.4;

[optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX] = ndgrid(optPoints.test.P, optPoints.test.SOC, optPoints.test.Tk);
optPoints.test.cost = G([optPoints.test.PX(:), optPoints.test.SOCX(:), optPoints.test.TkX(:)]);
plot(optPoints.test.Tk, myFlatten(arbj.bat.Cost_whole./func_solve_quad_eq(optPoints.test.PX, optPoints.test.SOCX, optPoints.test.TkX, func, 0).t_EOL_h), lw{:})
plot(optPoints.test.Tk(:), optPoints.test.cost(:),'--',lw{:});

% plot((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(-2, (0.05:0.01:0.95)', 45+KELVIN,func, 0).t_EOL_h)
% plot((0.05:0.01:0.95)', arbj.bat.Cost_whole./func_solve_quad_eq(-2, (0.05:0.01:0.95)', 55+KELVIN,func, 0).t_EOL_h)
% 
legend('25^oC','35^oC', '45^oC', '55^oC','location','northwest')
