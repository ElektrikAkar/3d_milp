% Settings for optimization. 
%
% Author: VK
% Date  : ?
yalmip('clear');
%sdpvarSettings = sdpsettings('solver','gurobi','verbose',2,'debug',1,'gurobi.NumericFocus',3,'gurobi.Presolve',2,'gurobi.TimeLimit',60*60*60); %Time limit is 60 hours 


sdpvarSettings = sdpsettings('solver','gurobi','debug',1,'gurobi.Presolve',2,'gurobi.TimeLimit',SimulSettings.TimeLimit); %Time limit is 60 hours 
sdpvarSettings.gurobi.Threads= SimulSettings.Threads;
%sdpvarSettings.usedx0 = 1;
fprintf(num2str(SimulSettings.Threads) + " threads are used.\n");

if(SimulSettings.OptMode=="Once")
    sdpvarSettings.verbose = 2;
elseif(SimulSettings.OptMode =="Optimizer")
    sdpvarSettings.verbose = 2;
end
    
% CPLEX is much slower than Gurobi.
    


%sdpvarSettings = sdpsettings('solver','gurobi','verbose',2,'debug',1,'gurobi.TimeLimit',60*60*60,'convertconvexquad',1); %Time limit is 60 hours 

%sdpvarSettings.cplex.mip.strategy.miqcpstrat =1; % Works slower when it is one
%but still better than Gurobi's wrong answer/ 
%sdpvarSettings.cplex.preprocessing.presolve =2;


%sdpvarSettings.gurobi.NumericFocus = 3;
%sdpvarSettings.gurobi.Presolve = 2;
%sdpvarSettings.gurobi.Heuristics = 0.8;
%sdpvarSettings.gurobi.Method = 0;
%sdpvarSettings.gurobi.Symmetry = 2;
sdpvarSettings.gurobi.Cuts = 1;
%sdpvarSettings.gurobi.VarBranch = 2;
%sdpvarSettings.gurobi.MIRCuts = 2;

%sdpvarSettings.gurobi.MIPFocus =1;
sdpvarSettings.gurobi.MIPGap = SimulSettings.MIPGap;

%sdpvarSettings.gurobi.PreSparsify =1;
%sdpvarSettings.gurobi.ImproveStartGap = 0.01; % = not good. 
%sdpvarSettings.gurobi.VarBranch = 0; % = not good. 
%sdpvarSettings.gurobi.ImproveStartTime = 40;
%sdpvarSettings.gurobi.PreQLinearize = 2; % 
%,'gurobi.MIPGap',1e-5
%sdpvarSettings.gurobi.MIQCPMethod =1; %Value 1 uses a linearized, outer-approximation approach, 
%while value 0 solves continuous QCP relaxations at each node. The default setting (-1) chooses automatically.

%warning('PreQlinearize is not activated');

%Controls presolve Q matrix linearization. Options 1 and 2 attempt to linearize quadratic constraints 
%or a quadratic objective, potentially transforming an MIQP or MIQCP model into an MILP. Option 1 focuses
%on getting a strong LP relaxation. Option 2 aims for a compact relaxation. Option 0 always leaves Q matrices unmodified. 
%The default setting (-1) chooses automatically.


%sdpvarSettings.mosek.MSK_IPAR_MIO_CONIC_OUTER_APPROXIMATION = 'MSK_ON';
%sdpvarSettings.mosek.MSK_IPAR_MIO_ROOT_REPEAT_PRESOLVE_LEVEL = 1;
