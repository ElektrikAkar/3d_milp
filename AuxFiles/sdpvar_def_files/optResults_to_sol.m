function sol =  optResults_to_sol(optResults, optimizerOutputNames)
% This file is created to extract solutions from optimizer output.
% Written by: Volkan Kumtepeli
% Date: 2020.04.26

% optResults          : 1xN cell   array     
% optimizerOutputNames: 1xN string array.

sol = struct();

expressions = ("sol." + optimizerOutputNames + " = " + "optResults{") + ...
               (string(1:length(optResults)) + "};"); 

for i=1:length(optimizerOutputNames)
    eval(expressions(i));
end
    

end