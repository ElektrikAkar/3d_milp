function x = mergeStructs(x, y, isCheckpointsActive)
% Author: VK
% Date: 2020.04.09
% This function merges the struct y into x recursively. Old data in x is replaced by
% the data y. If there is a new field in y, it will be added to x.

pass_list = ["isCheckpointsActive", "checkpointName", "checkpointPath"];

for field = fields(y)'
    if(isCheckpointsActive)
        if(ismember(field{1}, pass_list))
            % if checkpoints are active then they should not be
            % overwritten. 
            continue;
        end
    end
    if(isstruct(y.(field{1})))
        % If the field itself is another struct, then copy it recursively.
        if(~ismember(field{1}, fields(x))) % if x does not have that field. 
            x.(field{1}) = y.(field{1});
        else
            x.(field{1}) = mergeStructs(x.(field{1}), y.(field{1}), isCheckpointsActive);
        end
    else
        x.(field{1}) = y.(field{1});
    end
end

end