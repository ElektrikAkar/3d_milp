function sol =  sdpvar_to_sol(sdpv)
% This file is created to extract solutions. It only takes values of the
% sdpvar objects. It is moved here not to occupy so many lines in the main
% file.
% Written by: Volkan Kumtepeli
% Date: ?

names = fieldnames(sdpv);

for i=1:length(names)
    temp_name   = names{i};
    
    class_name  = class(sdpv.(temp_name));
    
    
    if strcmpi(class_name, "struct")
        sol.(temp_name) = sdpvar_to_sol(sdpv.(temp_name));
        
    elseif strcmpi(class_name, "lmi")
        continue
    else
        sol.(temp_name) = value(sdpv.(temp_name));
    end
end
end