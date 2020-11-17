function membership = find_trangulation_vertices()

membership.bottom = cell(8,1);
membership.top    = cell(8,1);
membership.left   = cell(8,1);
membership.right  = cell(8,1);
membership.back   = cell(8,1);
membership.front  = cell(8,1);

% 1,1,1;

vertex  = [1,1,1];

segments  = {'bottom', [3,4]; 'left', [7,8]; 'back', [5,6]};
for i = 1:size(segments,1)
    seg = segments{i,1};
    for j =  segments{i,2}
        membership.(seg){j} = [membership.(seg){j}; vertex]; 
    end
end


end