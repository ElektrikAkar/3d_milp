function [err] = func_opt_segm_cost4(X_all, data_segm, testPoints, arbj, func, given_It)
persistent iter;
if(isempty(iter))
    iter = 1;
end
% Author : VK
% Date   : 2020.06.22

% X_all = [I.X(:); SOC.X(:); T.X(:)]

X_all = reshape(X_all, [], 3);


IX   = reshape(X_all(:,1), data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
SOCX = reshape(X_all(:,2), data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
TX   = reshape(X_all(:,3), data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);

COST = arbj.bat.Cost_whole./func_solve_quad_eq(IX, SOCX, TX, func, 0, given_It).t_EOL_h;

F = scatteredInterpolant([IX(:), SOCX(:), TX(:)], COST(:));

TEST = F([testPoints.P.X(:),  testPoints.SOC.X(:), testPoints.T.X(:)]);

err = 10000*norm(TEST - testPoints.cost(:),2)/testPoints.numel;

fprintf('iter %d is done Error is: %4.8f.\n',iter,err);
iter = iter+1;
end