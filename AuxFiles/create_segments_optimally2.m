% This uses an optimization routine to find optimal segmentation!
clear testPoints candidate
data_segm.P.n   = 16; %16; %SimulSettings.segm.P.n; 
data_segm.SOC.n = 8; %8; %SimulSettings.segm.SOC.n;
data_segm.T.n   = 8;% 8; %SimulSettings.segm.T.n;


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


candidate.P.x(:,1)   = linspace(data_segm.P.min,   data_segm.P.max,   data_segm.P.n+1);
candidate.I.x(:,1)   = linspace(data_segm.I_min,   data_segm.I_max,   data_segm.P.n+1);
candidate.SOC.x(1,:) = linspace(data_segm.SOC.min, data_segm.SOC.max, data_segm.SOC.n+1);
candidate.T.x(1,1,:) = linspace(data_segm.T.min,   data_segm.T.max,   data_segm.T.n+1);

[candidate.I.X, candidate.SOC.X, candidate.T.X] = ndgrid(candidate.I.x, candidate.SOC.x, candidate.T.x);
[candidate.P.X, ~, ~] = ndgrid(candidate.P.x, candidate.SOC.x, candidate.T.x);


candidate.cost = arbj.bat.Cost_whole./func_solve_quad_eq(candidate.I.X, candidate.SOC.X, candidate.T.X,func,0, true).t_EOL_h;

candidate.cost_P = arbj.bat.Cost_whole./func_solve_quad_eq(candidate.P.X, candidate.SOC.X, candidate.T.X,func,0, false).t_EOL_h;


candidate.F = scatteredInterpolant([candidate.I.X(:), candidate.SOC.X(:), candidate.T.X(:)], candidate.cost(:));





testPoints.P.x(:,1)   = linspace(data_segm.P.min,   data_segm.P.max,   291);
testPoints.SOC.x(1,:) = linspace(data_segm.SOC.min, data_segm.SOC.max, 131);
testPoints.T.x(1,1,:) = linspace(data_segm.T.min,   data_segm.T.max,   131);

[testPoints.P.X, testPoints.SOC.X, testPoints.T.X] = ndgrid(testPoints.P.x, testPoints.SOC.x, testPoints.T.x);

testPoints.cost = arbj.bat.Cost_whole./func_solve_quad_eq(testPoints.P.X, testPoints.SOC.X, testPoints.T.X,func,0, false).t_EOL_h;

testPoints.numel = numel(testPoints.cost);

% tic;
% candidate.test = candidate.F([testPoints.I.X(:),  testPoints.SOC.X(:), testPoints.T.X(:)]);
% toc
% 
% 
% 
% candidate.err  = norm(candidate.test-testPoints.cost(:),2)/length(testPoints.cost);
% 
% deneme = func_opt_segm_cost([candidate.I.X(:); candidate.SOC.X(:); candidate.T.X(:)],data_segm,testPoints,arbj,func,true);

candidate.n_tot =  (data_segm.P.n+1)+(data_segm.SOC.n+1)+(data_segm.T.n+1);

candidate.n_all = (data_segm.P.n+1)*(data_segm.SOC.n+1)*(data_segm.T.n+1);

candidate.n_rows = 3*(data_segm.P.n)*(data_segm.SOC.n+1)*(data_segm.T.n+1) + ...
                   3*(data_segm.P.n+1)*(data_segm.SOC.n)*(data_segm.T.n+1) + ...
                   3*(data_segm.P.n+1)*(data_segm.SOC.n+1)*(data_segm.T.n) + ...
                   2*(data_segm.SOC.n+1)*(data_segm.T.n+1) + ...
                   2*(data_segm.P.n+1)*(data_segm.T.n+1) + ...
                   2*(data_segm.P.n+1)*(data_segm.SOC.n+1); 

candidate.A = [];
candidate.b = [];

% m = 1;
% 
% for ijk = 1:candidate.n_tot
%     temp_row = zeros(1, candidate.n_tot);
%     if(ijk==(data_segm.P.n+1))
%         continue;
%     elseif(ijk==(data_segm.P.n+2+data_segm.SOC.n))
%         continue;
%     elseif(ijk==(data_segm.P.n+3+data_segm.SOC.n+data_segm.T.n))
%         continue;
%     else
%         temp_row(ijk)   =  1;
%         temp_row(ijk+1) = -1;
%         candidate.A = [candidate.A; temp_row];
%         candidate.b = [candidate.b; 0];
%     end
% end

candidate.Aeq = [];
candidate.beq = [];

% temp_row    = zeros(1, candidate.n_tot);
% temp_row(1) = 1;
% 
% candidate.Aeq = [candidate.Aeq; temp_row];
% candidate.beq = [candidate.beq; data_segm.P.min];
% 
% temp_row    = zeros(1, candidate.n_tot);
% temp_row(data_segm.P.n+1) = 1;
% 
% candidate.Aeq = [candidate.Aeq; temp_row];
% candidate.beq = [candidate.beq; data_segm.P.max];
% 
% 
% temp_row    = zeros(1, candidate.n_tot);
% temp_row(data_segm.P.n+2) = 1;
% 
% candidate.Aeq = [candidate.Aeq; temp_row];
% candidate.beq = [candidate.beq; data_segm.SOC.min];
% 
% temp_row    = zeros(1, candidate.n_tot);
% temp_row(data_segm.P.n+2+data_segm.SOC.n) = 1;
% 
% candidate.Aeq = [candidate.Aeq; temp_row];
% candidate.beq = [candidate.beq; data_segm.SOC.max];
% 
% temp_row    = zeros(1, candidate.n_tot);
% temp_row(data_segm.P.n+3+data_segm.SOC.n) = 1;
% 
% candidate.Aeq = [candidate.Aeq; temp_row];
% candidate.beq = [candidate.beq; data_segm.T.min];
% 
% temp_row    = zeros(1, candidate.n_tot);
% temp_row(data_segm.P.n+3+data_segm.SOC.n+data_segm.T.n) = 1;
% 
% candidate.Aeq = [candidate.Aeq; temp_row];
% candidate.beq = [candidate.beq; data_segm.T.max];


%%
candidate.n_all = (data_segm.P.n+1)*(data_segm.SOC.n+1)*(data_segm.T.n+1);
candidate.n_rows = 3*(data_segm.P.n)*(data_segm.SOC.n+1)*(data_segm.T.n+1) + ...
    3*(data_segm.P.n+1)*(data_segm.SOC.n)*(data_segm.T.n+1) + ...
    3*(data_segm.P.n+1)*(data_segm.SOC.n+1)*(data_segm.T.n);% + ...
   % 2*(data_segm.SOC.n+1)*(data_segm.T.n+1) + ...
  %  2*(data_segm.P.n+1)*(data_segm.T.n+1) + ...
  %  2*(data_segm.P.n+1)*(data_segm.SOC.n+1);

candidate.A = zeros(candidate.n_rows,candidate.n_all*3);
candidate.b = zeros(candidate.n_rows,1);

candidate.Aeq = [];
candidate.beq = [];

m = 1;
for i=1: (data_segm.P.n+1)
    for j=1:(data_segm.SOC.n+1)
        for k=1:(data_segm.T.n+1)
            
            % i < i+1 -> f(i,j,k) <= f(i+1,j,k) => f(i,j,k) - f(i+1,j,k)<=0
            if(i<=data_segm.P.n )
                temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
                temp_row(i,j,k)   =  1;
                temp_row(i+1,j,k) = -1;
                candidate.A(m:m+2,:) = blkdiag(temp_row(:)',temp_row(:)',temp_row(:)');
                candidate.b(m:m+2,:) = zeros(3,1);
                m = m+3;
            else
                temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
                temp_row(i,j,k)   =  1;
                candidate.Aeq(end+1,:) =  [temp_row(:)', zeros(1,2*candidate.n_all)];
                candidate.beq(end+1,:) =  data_segm.P.max;
%                m = m+1;
%                candidate.Aeq(end+1,:) = [temp_row(:)', zeros(1,2*candidate.n_all)];
%                candidate.beq(end+1,:) = data_segm.P.max;                
            end
            
            if(j<=data_segm.SOC.n)
                temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
                temp_row(i,j,k)   =  1;
                temp_row(i,j+1,k) = -1;
                candidate.A(m:m+2,:) = [blkdiag(temp_row(:)',temp_row(:)',temp_row(:)')];
                candidate.b(m:m+2,:) = zeros(3,1);
                m = m+3;
            else
                temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
                temp_row(i,j,k)   =  1;
                candidate.Aeq(end+1,:) = [zeros(1,candidate.n_all),temp_row(:)', zeros(1,candidate.n_all)];
                candidate.beq(end+1,:) = data_segm.SOC.max;
               % m = m+1;
            end
            
            if(k<=data_segm.T.n)
                temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
                temp_row(i,j,k)   =  1;
                temp_row(i,j,k+1) = -1;
                candidate.A(m:m+2,:) = [blkdiag(temp_row(:)',temp_row(:)',temp_row(:)')];
                candidate.b(m:m+2,:) = zeros(3,1);
                m = m+3;
            else
                temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
                temp_row(i,j,k)   =  1;
                candidate.Aeq(end+1,:) = [zeros(1,2*candidate.n_all),temp_row(:)'];
                candidate.beq(end+1,:) = data_segm.T.max;
             %   m = m+1;
            end
            
            if(i==1)
                temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
                temp_row(i,j,k)   =  1;
                candidate.Aeq(end+1,:) = [temp_row(:)', zeros(1,2*candidate.n_all)];
                candidate.beq(end+1,:) = data_segm.P.min;
             %   m = m+1;
            end
            
            if(j==1)
                temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
                temp_row(i,j,k)   =  1;
                candidate.Aeq(end+1,:) = [zeros(1,candidate.n_all),temp_row(:)', zeros(1,candidate.n_all)];
                candidate.beq(end+1,:) = data_segm.SOC.min;
              %  m = m+1;
            end
            
            if(k==1)
                temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
                temp_row(i,j,k)   =  1;
                candidate.Aeq(end+1,:) = [zeros(1,2*candidate.n_all),temp_row(:)'];
                candidate.beq(end+1,:) = data_segm.T.min;
           %     m = m+1;
            end
        end
        
    end
end



%%

%%
clear func_opt_segm_cost4 func_opt_segm_cost2 func_opt_segm_cost3



temp = load('x_0_21074225_zero.mat');

ccandidate.P  = temp.x(1:(temp.data_segm.P.n+1)); 
ccandidate.SOC = temp.x((temp.data_segm.P.n+2):(temp.data_segm.P.n+2+temp.data_segm.SOC.n)); 
ccandidate.Tk  = temp.x((temp.data_segm.P.n+3+temp.data_segm.SOC.n):end); 

[ccandidate.PX, ccandidate.SOCX, ccandidate.TkX] = ndgrid(ccandidate.P, ccandidate.SOC, ccandidate.Tk);


ccandidate.X0 = [ccandidate.PX(:); ccandidate.SOCX(:); ccandidate.TkX(:)];




%candidate.X2 = temp.x;

%candidate.X1 = [-6.0000   -2.0009   -1.8320   -1.0687   -0.9673   -0.5308,...
%    -0.2206   -0.0198    0.1479    0.3784    0.6639    1.2829    1.7256    2.1122    2.4337    2.7549,...
%    3.0000    0.0480    0.0830 0.1380    0.1652    0.2230    0.3591    0.5620    0.7198,...
%    0.9520  291.1500  297.1635  309.4598  321.9963  333.1500]';


%[~, minind] = min(abs(candidate.X2(1:data_segm.P.n+1)));
%candidate.X3 = candidate.X0;
%candidate.X2(minind-1) = 0;
%candidate.X3(minind-1) = 0;



% temp_row    = zeros(1, candidate.n_tot);
% temp_row(minind-1) = 1;
% candidate.Aeq2 = [candidate.Aeq; temp_row];
% candidate.beq2 = [candidate.beq; 0];



cost_fun = @(x) func_opt_segm_cost4(x, data_segm, testPoints, arbj, func, false);
opt = optimoptions('fmincon','MaxFunctionEvaluations',20e3); %'algorithm','interior-point'
%[x,fval,exitflag,output] = fmincon(cost_fun, candidate.X2, candidate.A, candidate.b, candidate.Aeq, candidate.beq,[],[],[],opt);

[x,fval,exitflag,output] = fmincon(cost_fun, ccandidate.X0, candidate.A, candidate.b, candidate.Aeq, candidate.beq,[],[],[],opt);





%%
% 
% candidate.X0 = [candidate.I.X(:); candidate.SOC.X(:); candidate.T.X(:)];
% cost_fun = @(x) func_opt_segm_cost(x,data_segm,testPoints,arbj,func,true);
% 
% [x,fval,exitflag,output] = fmincon(cost_fun, candidate.X0, candidate.A, candidate.b);


% %%
% clear func_opt_segm_cost2 func_opt_segm_cost3
% temp = load('x_0_2045.mat');
% candidate.X0 = [candidate.P.x; candidate.SOC.x(:); candidate.T.x(:)];
% 
% candidate.X2 = temp.x;
% 
% %candidate.X1 = [-6.0000   -2.0009   -1.8320   -1.0687   -0.9673   -0.5308,...
% %    -0.2206   -0.0198    0.1479    0.3784    0.6639    1.2829    1.7256    2.1122    2.4337    2.7549,...
% %    3.0000    0.0480    0.0830 0.1380    0.1652    0.2230    0.3591    0.5620    0.7198,...
% %    0.9520  291.1500  297.1635  309.4598  321.9963  333.1500]';
% 
% 
% [~, minind] = min(abs(candidate.X2(1:data_segm.P.n+1)));
% candidate.X3 = candidate.X0;
% candidate.X2(minind-1) = 0;
% candidate.X3(minind-1) = 0;
% 
% 
% 
% temp_row    = zeros(1, candidate.n_tot);
% temp_row(minind-1) = 1;
% candidate.Aeq2 = [candidate.Aeq; temp_row];
% candidate.beq2 = [candidate.beq; 0];
% 
% 
% 
% cost_fun = @(x) func_opt_segm_cost3(x, data_segm, testPoints, arbj, func, false, false);
% opt = optimoptions('fmincon','MaxFunctionEvaluations',20e3); %'algorithm','interior-point'
% %[x,fval,exitflag,output] = fmincon(cost_fun, candidate.X2, candidate.A, candidate.b, candidate.Aeq, candidate.beq,[],[],[],opt);
% 
% [x,fval,exitflag,output] = fmincon(cost_fun, candidate.X3, candidate.A, candidate.b, candidate.Aeq2, candidate.beq2,[],[],[],opt);



%%
clear func_opt_segm_cost2 func_opt_segm_cost3
candidate.X0 = [candidate.P.x; candidate.SOC.x(:); candidate.T.x(:)];
cost_fun = @(x) func_opt_segm_cost3(x,data_segm,testPoints,arbj,func,false);
[X,FVAL,EXITFLAG,OUTPUT] = ga(cost_fun,length(candidate.X0),candidate.A, candidate.b, candidate.Aeq, candidate.beq)

%%


% for i=1: (data_segm.P.n+1)
%     for j=1:(data_segm.SOC.n+1)
%         tic;
%         for k=1:(data_segm.T.n+1)
%             
%             % i < i+1 -> f(i,j,k) <= f(i+1,j,k) => f(i,j,k) - f(i+1,j,k)<=0
%             if(i<=data_segm.P.n )
%                 temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
%                 temp_row(i,j,k)   =  1;
%                 temp_row(i+1,j,k) = -1;
%                 candidate.A = [candidate.A; blkdiag(temp_row(:)',temp_row(:)',temp_row(:)')];
%                 candidate.b = [candidate.b; zeros(3,3*candidate.n_all)];
%             else
%                 temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
%                 temp_row(i,j,k)   =  1;
%                 candidate.A = [candidate.A; [temp_row(:)', zeros(1,2*candidate.n_all)]];
%                 candidate.b = [candidate.b; data_segm.I_max*[temp_row(:)', zeros(1,2*candidate.n_all)]];
%             end
%             
%             if(j<=data_segm.SOC.n)
%                 temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
%                 temp_row(i,j,k)   =  1;
%                 temp_row(i,j+1,k) = -1;
%                 candidate.A = [candidate.A; blkdiag(temp_row(:)',temp_row(:)',temp_row(:)')];
%                 candidate.b = [candidate.b; zeros(3,3*candidate.n_all)];
%             else
%                 temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
%                 temp_row(i,j,k)   =  1;
%                 candidate.A = [candidate.A; [zeros(1,candidate.n_all),temp_row(:)', zeros(1,candidate.n_all)]];
%                 candidate.b = [candidate.b; data_segm.SOC.max*[zeros(1,candidate.n_all),temp_row(:)', zeros(1,candidate.n_all)]];
%             end
%             
%             if(k<=data_segm.T.n)
%                 temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
%                 temp_row(i,j,k)   =  1;
%                 temp_row(i,j,k+1) = -1;
%                 candidate.A = [candidate.A; blkdiag(temp_row(:)',temp_row(:)',temp_row(:)')];
%                 candidate.b = [candidate.b; zeros(3,3*candidate.n_all)];
%             else
%                 temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
%                 temp_row(i,j,k)   =  1;
%                 candidate.A = [candidate.A; [zeros(1,2*candidate.n_all),temp_row(:)']];
%                 candidate.b = [candidate.b; data_segm.T.max*[zeros(1,2*candidate.n_all),temp_row(:)']];
%             end
%             
%             if(i==1)
%                 temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
%                 temp_row(i,j,k)   =  -1;
%                 candidate.A = [candidate.A; [temp_row(:)', zeros(1,2*candidate.n_all)]];
%                 candidate.b = [candidate.b; -data_segm.I_min*[temp_row(:)', zeros(1,2*candidate.n_all)]];
%             end
%             
%             if(j==1)
%                 temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
%                 temp_row(i,j,k)   =  -1;
%                 candidate.A = [candidate.A; [zeros(1,candidate.n_all),temp_row(:)', zeros(1,candidate.n_all)]];
%                 candidate.b = [candidate.b; -data_segm.SOC.min*[zeros(1,candidate.n_all),temp_row(:)', zeros(1,candidate.n_all)]];
%             end
%             
%             if(k==1)
%                 temp_row = zeros(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1);
%                 temp_row(i,j,k)   =  -1;
%                 candidate.A = [candidate.A; [zeros(1,2*candidate.n_all),temp_row(:)']];
%                 candidate.b = [candidate.b; -data_segm.T.min*[zeros(1,2*candidate.n_all),temp_row(:)']];
%             end
%             
%             
%         end
%         toc
%     end
% end





%%
%----

data_segm.equi  = false; % if this is true it basically divides things into equally spaced segments. Easier and first method. 

data_segm.P.n   = 32;   % Number of segments for power; MUST BE even number to include 0. (16 IDEAL)
data_segm.SOC.n = 8;    % Number of segments for SOC.  %Defined by following not here. 
data_segm.T.n   = 4;    % Number of segments for temperature.  % 4 is ideal. for equivalent. 2 is (39-34)/34 difference. 15% ERROR.

data_segm.P.min = -9.6*1.7;  % -10W for minimum power. 
data_segm.P.max =  9.6*2.5;   % 10W for maximum cell power.  % Because of the efficiency loss in charging. 1 C is considered.

data_segm.C_min = -2;
data_segm.C_max =  2; 

data_segm.I_min = data_segm.C_min*3; 
data_segm.I_max = data_segm.C_max*3; 

data_segm.SOC.min= 0.05; 
data_segm.SOC.max= 0.95; 

data_segm.T.min = KELVIN + 18; % 18 degrees for minimum temperature. 
data_segm.T.max = KELVIN + 60; % 60 Celcius degrees for max temp. 




data_segm.T.x(1,1,:)      = (linspace(data_segm.T.min,data_segm.T.max,data_segm.T.n+1));
data_segm.SOC.x(1,:)      = [0.048,  0.10, 0.15 0.25, 0.32  0.41, 0.68, 0.82 0.952];

temp_SOC_X = ones(size(data_segm.T.x)).*data_segm.SOC.x;
temp_T_X   = ones(size(data_segm.SOC.x)).*data_segm.T.x;

temp_P_minX  = func.It_to_Pt(data_segm.I_min,temp_SOC_X,temp_T_X);
temp_P_maxX  = func.It_to_Pt(data_segm.I_max,temp_SOC_X,temp_T_X);


sdpv.segm.PX = sdpvar(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1,'full');
sdpv.segm.SOCX = sdpvar(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1,'full');
sdpv.segm.TX = sdpvar(data_segm.P.n+1, data_segm.SOC.n+1, data_segm.T.n+1,'full');

sdpv.segm.F = [];


sdpv.segm.F = [sdpv.segm.F, sdpv.segm.PX(17,:,:)==0];

sdpv.segm.F = [sdpv.segm.F, sdpv.segm.PX(1,:,:)   ==  temp_P_minX];
sdpv.segm.F = [sdpv.segm.F, sdpv.segm.PX(end,:,:) ==  temp_P_maxX];

sdpv.segm.F = [sdpv.segm.F, sdpv.segm.PX(:,1,:)     ==  data_segm.SOC.min];
sdpv.segm.F = [sdpv.segm.F, sdpv.segm.PX(:,end,:)   ==  data_segm.SOC.max];

sdpv.segm.F = [sdpv.segm.F, sdpv.segm.PX(:,:,1)     ==  data_segm.T.min];
sdpv.segm.F = [sdpv.segm.F, sdpv.segm.PX(:,:,end)   ==  data_segm.T.max];


sdpv.segm.F = [sdpv.segm.F, sdpv.segm.PX(1:end-1,:,:) <=  sdpv.segm.PX(2:end,:,:)];
sdpv.segm.F = [sdpv.segm.F, sdpv.segm.PX(:,1:end-1,:) <=  sdpv.segm.PX(:,2:end,:)];
sdpv.segm.F = [sdpv.segm.F, sdpv.segm.PX(:,:,1:end-1) <=  sdpv.segm.PX(:,:,2:end)];

sdpv.segm.F = [sdpv.segm.F, sdpv.segm.SOCX(1:end-1,:,:) <=  sdpv.segm.SOCX(2:end,:,:)];
sdpv.segm.F = [sdpv.segm.F, sdpv.segm.SOCX(:,1:end-1,:) <=  sdpv.segm.SOCX(:,2:end,:)];
sdpv.segm.F = [sdpv.segm.F, sdpv.segm.SOCX(:,:,1:end-1) <=  sdpv.segm.SOCX(:,:,2:end)];

sdpv.segm.F = [sdpv.segm.F, sdpv.segm.TX(1:end-1,:,:) <=  sdpv.segm.TX(2:end,:,:)];
sdpv.segm.F = [sdpv.segm.F, sdpv.segm.TX(:,1:end-1,:) <=  sdpv.segm.TX(:,2:end,:)];
sdpv.segm.F = [sdpv.segm.F, sdpv.segm.TX(:,:,1:end-1) <=  sdpv.segm.TX(:,:,2:end)];

test_points.n1 = 500;
test_points.n2 = 200;
test_points.n3 = 100;

test_points.PX =  min(temp_P_minX(:))+ (max(temp_P_maxX(:) - min(temp_P_minX(:))))*rand(test_points.n1,test_points.n2,test_points.n3);
test_points.SOCX =  data_segm.SOC.min+ (data_segm.SOC.max - data_segm.SOC.min)*rand(test_points.n1,test_points.n2,test_points.n3);
test_points.TX =  data_segm.T.min+ (data_segm.T.max - data_segm.T.min)*rand(test_points.n1,test_points.n2,test_points.n3);

test_points.quad =  func_solve_quad_eq(test_points.PX,test_points.SOCX,test_points.TX,func,0);

fun_min = sdpfun(sdpv.segm.PX,sdpv.segm.SOCX,sdpv.segm.TX,"to_be_minimized");




