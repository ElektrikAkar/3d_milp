function uJ = calculate_union_jack_triangulation(N1, N2, N3)

% This function calculates union jack triangulation points!
% It is an updated version of test_union_jack_triangulation .m file
% Author : VK
% Date   : 2020.04.30
% Update : 2020.05.08 -> converted to a function. 

uJ.CelltoBoolean = @(y) cell2mat(cellfun(@(x) boolean(x-48), y, 'UniformOutput', false));

uJ.main.bottom = {'000001'; '001001'; '001000'; '000000'; '000010'; '001010'; '001011'; '000011'};
uJ.main.top    = {'000101'; '001101'; '001100'; '000100'; '000110'; '001110'; '001111'; '000111'};

uJ.main.right  = {'110101'; '010101'; '010111'; '110111'; '110011'; '010011'; '010001'; '110001'};
uJ.main.left   = {'110100'; '010100'; '010110'; '110110'; '110010'; '010010'; '010000'; '110000'};

uJ.main.front  = {'111111'; '011111'; '011110'; '111110'; '111010'; '011010'; '011011'; '111011'};
uJ.main.back   = {'111101'; '011101'; '011100'; '111100'; '111000'; '011000'; '011001'; '111001'};

uJ.main = structfun(uJ.CelltoBoolean, uJ.main, 'UniformOutput', false); % Convert all to booleans otherwise very very slow! 
 

uJ.nx_orj = N1;
uJ.ny_orj = N2;
uJ.nz_orj = N3;

uJ.cubes = create_cubes(uJ.nx_orj, uJ.ny_orj, uJ.nz_orj, uJ.main);

uJ.constraints_binaryIndices = cube_constraints([uJ.nx_orj, uJ.ny_orj, uJ.nz_orj], uJ.cubes);

uJ.constraints_allbinaries = all_delta_one_min(uJ.constraints_binaryIndices);

uJ.nt = size(uJ.constraints_allbinaries, 5);

end


function constraints_delta = all_delta_one_min(constraints_binaryIndices)

[sx, sy, sz] = size(constraints_binaryIndices);
sd = size(constraints_binaryIndices{1,1,1}, 2);
constraints_delta = false(sx, sy, sz, 2, sd);


for i =1:sx
    for j = 1:sy
       for k = 1:sz
           constraints_delta(i,j,k,:,:) = delta_one_min(constraints_binaryIndices{i,j,k});
       end
    end
end

end


function constraints_binaryIndices = cube_constraints(num_seg,cubes)
% num_seg is [m,n,p] number of segments. 
%bound = @(x,y) max(min(x,y(2)),y(1));
m = num_seg(1);
n = num_seg(2);
p = num_seg(3);

% only works for even numbers. Max number of cubes. 
% x_max = m/2;
% y_max = n/2;
% z_max = p/2;

delta_indices = cell(m+1,n+1,p+1); %

for i=1:(m+1)
   for j=1:(n+1)
      for k=1:(p+1)
          
          i_set = which_two_cubes(i,m+1);
          j_set = which_two_cubes(j,n+1);
          k_set = which_two_cubes(k,p+1);
          
          
          vertex_gray = [];
          for i2=1:size(i_set,1)
              for j2=1:size(j_set,1)
                  for k2=1:size(k_set,1)
                      
                      cube = cubes(i_set(i2,1),j_set(j2,1),k_set(k2,1) );                      
                      rel_pos = [i_set(i2,2),j_set(j2,2),k_set(k2,2)];
                      
                      vertex_gray = [vertex_gray; vertex_membership_cube(cube,rel_pos)];
                      
                  end
              end
          end
          delta_indices{i,j,k} = vertex_gray;
           
          
      end
   end
end

constraints_binaryIndices =delta_indices;
end

function two_cubes = which_two_cubes(point_no,max_val)
max_cube = (max_val-1)/2;  % need to be odd number of points.

if(point_no==1)
    % if its the first point then 
    two_cubes = [1,1]; % first cube first point. 
elseif(point_no==max_val)
    two_cubes = [max_cube,3];
else
    if(mod(point_no,2)==0)
        % if it is an even point. Then it belongs to only one cube. 
        two_cubes = [point_no/2,2];
    else
        two_cubes = [(point_no-1)/2,3;(point_no+1)/2,1];
    end
end

end


function delta_and_one_min_delta = delta_one_min(boolean_values)
%This function takes a  column array of cell then finds which bits are
%non-changing. Delta means  when non-changing bit is 1, one_min_delta is
%non-changing bit is zero. 
%convert_to_boolean = @(y)arrayfun(@(x)boolean(str2num(x)),vertcat(y{:}));

%boolean_values = arrayfun(@(x)boolean(str2double(x)),vertcat(cell_array{:}));

delta = all(boolean_values, 1);
one_min_delta = all(~boolean_values, 1);
delta_and_one_min_delta = [delta; one_min_delta];
end



function vertex_gray = vertex_membership_cube(cube,rel_pos)
% This function takes two arguments one cube and a relative position. 
% where relative position is [x,y,z]  all in 1:3. So it gives the gray code
% values for a certain vertex. 

%vertex_gray = [];

if(isequal(rel_pos,[1,1,1]))
    vertex_gray = [cube.bottom([3,4],:); cube.left([7,8],:); cube.back([5,6],:)];
    
elseif(isequal(rel_pos,[1,1,2]))
    vertex_gray = [cube.left([1,8],:); cube.back([4,5],:)];
    
elseif(isequal(rel_pos,[1,1,3]))
    vertex_gray = [cube.left([1,2],:); cube.back([3,4],:); cube.top([3,4],:) ]  ;
    
elseif(isequal(rel_pos,[1,2,1]))
    vertex_gray = [cube.left([6,7],:); cube.bottom([4,5],:) ] ;
    
elseif(isequal(rel_pos,[1,2,2]))
    vertex_gray = cube.left(1:8,:) ;
    
elseif(isequal(rel_pos,[1,2,3]))
    vertex_gray = [cube.left([2,3],:); cube.top([4,5],:) ]  ;
    
elseif(isequal(rel_pos,[1,3,1]))
    vertex_gray = [cube.front([5,6],:); cube.left([5,6],:); cube.bottom([5,6],:)];
    
elseif(isequal(rel_pos,[1,3,2]))
    vertex_gray = [cube.left([4,5],:); cube.front([4,5],:)];
    
elseif(isequal(rel_pos,[1,3,3]))
    vertex_gray = [cube.left([3,4],:); cube.front([3,4],:); cube.top([5,6],:) ]  ;
    
%%%%%%%%%%%%%%%%%%    
elseif(isequal(rel_pos,[2,1,1]))
    vertex_gray = [cube.bottom([2,3],:); cube.back([6,7],:)];
    
elseif(isequal(rel_pos,[2,1,2]))
    vertex_gray = cube.back(1:8, :);
    
elseif(isequal(rel_pos,[2,1,3]))
    vertex_gray = [cube.back([2,3],:); cube.top([2,3],:) ]  ;
    
elseif(isequal(rel_pos,[2,2,1]))
    vertex_gray = cube.bottom(1:8, :);
    
elseif(isequal(rel_pos,[2,2,2]))
    temp1       = struct2cell(cube);
    vertex_gray = cat(1,temp1{:});
    
elseif(isequal(rel_pos,[2,2,3]))
    vertex_gray = cube.top(1:8, :);
    
elseif(isequal(rel_pos,[2,3,1]))
    vertex_gray = [cube.bottom([6,7],:); cube.front([6,7],:)];
    
elseif(isequal(rel_pos,[2,3,2]))
    vertex_gray = cube.front(1:8, :);
    
elseif(isequal(rel_pos,[2,3,3]))
    vertex_gray = [cube.top([6,7],:); cube.front([2,3],:)];
    
%%%%%%%%%%%%%%%%%%%%    
elseif(isequal(rel_pos,[3,1,1]))
    vertex_gray = [cube.right([7,8],:); cube.back([7,8],:); cube.bottom([1,2],:) ]  ;
    
elseif(isequal(rel_pos,[3,1,2]))
    vertex_gray = [cube.right([1,8],:); cube.back([1,8],:) ]  ;
    
elseif(isequal(rel_pos,[3,1,3]))
    vertex_gray = [cube.right([1,2],:); cube.back([1,2],:); cube.top([1,2],:) ]  ;
    
elseif(isequal(rel_pos,[3,2,1]))
    vertex_gray = [cube.right([6,7],:); cube.bottom([1,8],:)]  ;
    
elseif(isequal(rel_pos,[3,2,2]))
    vertex_gray = cube.right(1:8, :);
    
elseif(isequal(rel_pos,[3,2,3]))
    vertex_gray = [cube.right([2,3],:); cube.top([1,8],:)]  ;
    
elseif(isequal(rel_pos,[3,3,1]))
    vertex_gray = [cube.right([5,6],:); cube.front([7,8],:); cube.bottom([7,8],:) ]  ;
    
elseif(isequal(rel_pos,[3,3,2]))
    vertex_gray = [cube.right([4,5],:); cube.front([1,8],:) ]  ;
    
elseif(isequal(rel_pos,[3,3,3]))
    vertex_gray = [cube.right([3,4],:); cube.front([1,2],:); cube.top([7,8],:) ]  ;
else
    error('Relpos(1) is : %d',rel_pos(1));
end


end


function alldiff = is_all_gray_different(cubes)
% This function checks if all gray code in all cubes are different. 
%cubes = cubes(:);

cubes2 = [cubes{:}];
cubes3 = [struct2cell(cubes2)];
cubes4 = [cubes3{:}];
cubes5 = cat(1,cubes4{:});

cubes6 = unique(cubes5,'rows');

if(size(cubes6,1)==size(cubes5,1))
    alldiff = true;
else
    alldiff = false;
end


end


function diff_between = surface_difference(surface1,surface2)
% Given two surfaces, checks the difference between bits. It can be used to
% check if two adjacent surfaces have 1 bit difference between triangles. 

diff_between = zeros(length(surface1),1);

for i=1:length(surface1)
   diff_between(i) = norm(surface1{i}-surface2{i},1);
   fprintf('%s | %s \t= %d\n',surface1{i},surface2{i},diff_between(i));
end

fprintf('\n');
end



function cubes = create_cubes(nx_orj,ny_orj,nz_orj,main_cube)
% This function creates many cubes. 
% This file is for log-formulation and it creates gray-code enumaration
% similar to paper "Using Gray codes as Location Identifiers - Thomas Strang"

nx = nx_orj;
ny = ny_orj; 
nz = nz_orj;

nx_log = ceil(log2(nx/2));
ny_log = ceil(log2(ny/2)); 
nz_log = ceil(log2(nz/2)); 

nt_log = nx_log + ny_log+nz_log; 

cubes = [main_cube]; 

nx = nx/2;
ny = ny/2;
nz = nz/2;

for iLog = 1:nt_log
        
        if(nx>ny)  %
            % Cut half in direction of nx
            [s_x, s_y, s_z] = size(cubes);
            % -> Expansion in direction of x means to right. 
            cubes = repmat(cubes,2,1,1); %cat(1,cubes,cell(s_x,s_y,s_z)); %Double the size. 
            
            for iC = 1:s_x
                for jC = 1:s_y
                    for kC = 1:s_z
                        cubes(s_x+iC,jC,kC)   = cube_expand_right(cubes(s_x+1-iC,jC,kC));
                        cubes(s_x+1-iC,jC,kC) = cube_add_bit( cubes(s_x+1-iC,jC,kC), false);
                        cubes(s_x+iC,jC,kC)   = cube_add_bit( cubes(s_x+iC,jC,kC),   true );
                    end
                end
            end
            nx = nx/2;
        elseif(ny>nz)
            % Cut half in direction of nx
            [s_x, s_y, s_z] = size(cubes);
            % -> Expansion in direction of x means to right. 
            cubes =  repmat(cubes,1,2,1); % cat(2,cubes,cell(s_x,s_y,s_z)); %Double the size. 
            
            for iC = 1:s_x
                for jC = 1:s_y
                    for kC = 1:s_z
                        cubes(iC,s_y+jC,kC)   = cube_expand_front(cubes(iC,s_y+1-jC,kC) );
                        cubes(iC,s_y+1-jC,kC) = cube_add_bit( cubes(iC,s_y+1-jC,kC), false);
                        cubes(iC,s_y+jC,kC)   = cube_add_bit( cubes(iC,s_y+jC,kC),   true);
                    end
                end
            end
            ny = ny/2;
        else
            [s_x, s_y, s_z] = size(cubes);
            % -> Expansion in direction of x means to right. 
            cubes = repmat(cubes,1,1,2);  %cat(3,cubes,cell(s_x,s_y,s_z)); %Double the size. 
            
            for iC = 1:s_x
                for jC = 1:s_y
                    for kC = 1:s_z
                        cubes(iC,jC,s_z+kC)   = cube_expand_top(cubes(iC,jC,s_z+1-kC) );
                        cubes(iC,jC,s_z+1-kC) = cube_add_bit( cubes(iC,jC,s_z+1-kC), false);
                        cubes(iC,jC,s_z+kC)   = cube_add_bit( cubes(iC,jC,s_z+kC), true);
                    end
                end
            end
            nz = nz/2;            
        end
end


end


function cube_out = cube_add_bit(cube_in,bit)

cube_out = cube_in;

for face_in = string(fields(cube_in))'
    cube_out.(face_in)(:,end+1) = bit;
end

end


function cube_out = cube_expand_right(cube_in)

cube_out = cube_in; 

cube_out.left   = cube_in.right;
cube_out.right  = cube_in.left;

cube_out.top([4,3,6,5],:)    = cube_in.top([1,2,7,8],:);
cube_out.bottom([4,3,6,5],:) = cube_in.bottom([1,2,7,8],:);

cube_out.top([1,2,7,8],:)    = cube_in.top([4,3,6,5],:);
cube_out.bottom([1,2,7,8],:) = cube_in.bottom([4,3,6,5],:);

cube_out.front([4,3,6,5],:)= cube_in.front([1,2,7,8],:);
cube_out.back([4,3,6,5],:) = cube_in.back([1,2,7,8],:);

cube_out.front([1,2,7,8],:)= cube_in.front([4,3,6,5],:);
cube_out.back([1,2,7,8],:) = cube_in.back([4,3,6,5],:);

end


function cube_out = cube_expand_top(cube_in) 

cube_out = cube_in; 

cube_out.top     = cube_in.bottom;
cube_out.bottom  = cube_in.top;

% % % 

cube_out.left([1,2,3,4],:)    = cube_in.left([8,7,6,5],:);
cube_out.right([1,2,3,4],:)   = cube_in.right([8,7,6,5],:);

cube_out.left([8,7,6,5],:)    = cube_in.left([1,2,3,4],:);
cube_out.right([8,7,6,5],:)   = cube_in.right([1,2,3,4],:);

%
cube_out.back([1,2,3,4],:)    = cube_in.back([8,7,6,5],:);
cube_out.front([1,2,3,4],:)   = cube_in.front([8,7,6,5],:);

cube_out.back([8,7,6,5],:)    = cube_in.back([1,2,3,4],:);
cube_out.front([8,7,6,5],:)   = cube_in.front([1,2,3,4],:);

end


function cube_out = cube_expand_front(cube_in) 

cube_out = cube_in; 

cube_out.front = cube_in.back;
cube_out.back  = cube_in.front;

% % % 
cube_out.left([1,2,7,8],:)    = cube_in.left([4,3,6,5],:);
cube_out.right([1,2,7,8],:)   = cube_in.right([4,3,6,5],:);

cube_out.left([4,3,6,5],:)    = cube_in.left([1,2,7,8],:);
cube_out.right([4,3,6,5],:)   = cube_in.right([1,2,7,8],:);

%
cube_out.bottom([1,2,3,4],:)  = cube_in.bottom([8,7,6,5],:);
cube_out.top([1,2,3,4],:)     = cube_in.top([8,7,6,5],:);

cube_out.bottom([8,7,6,5],:)  = cube_in.bottom([1,2,3,4],:);
cube_out.top([8,7,6,5],:)     = cube_in.top([1,2,3,4],:);

end


