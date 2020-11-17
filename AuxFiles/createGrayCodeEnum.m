function gray_cell = createGrayCodeEnum(nx_orj,ny_orj,nz_orj)


% This file is for log-formulation and it creates gray-code enumaration
% similar to paper "Using Gray codes as Location Identifiers - Thomas Strang"



% nx_orj = 4;
% ny_orj = 7;
% nz_orj = 2;

% there is a zero segment (it is less dimensional system but gives same
% gray code as 1 segment).
nx_orj = max(1,nx_orj);
ny_orj = max(1,ny_orj);
nz_orj = max(1,nz_orj);

nx = nx_orj;
ny = ny_orj; 
nz = nz_orj;

nx_log = ceil(log2(nx));
ny_log = ceil(log2(ny)); 
nz_log = ceil(log2(nz)); 

nt_log = nx_log + ny_log+nz_log; 

gray_cell = {[]}; % grayGen(test.Cell0,1);
% 
for iLog = 1:nt_log
        
        if(nx>ny)
            % Cut half in direction of nx
            gray_cell = grayGen(gray_cell,1);
            nx = nx/2;
        elseif(ny>nz)
            gray_cell = grayGen(gray_cell,2);
            ny = ny/2;
        else
            gray_cell = grayGen(gray_cell,3);
            nz = nz/2;            
        end
end


gray_cell = gray_cell(1:nx_orj,1:ny_orj,1:nz_orj);
%test.Cell0 = {false,true};


function newGrayCell = grayGen(oldGrayCell,direction)

oldSize = size(oldGrayCell);

if((direction==3)&&(length(oldSize)<3))
    oldSize(3) = 1;
end

newSize = oldSize;

newSize(direction) = 2*newSize(direction);

newGrayCell = cell(newSize);


initial_enum = [false true];


addBit = @(old_array,newBit) [newBit,old_array];


for iDir=0:(oldSize(direction)-1)
    
    for iBit = 1:2
    subses = repmat({':'}, [1 ndims(newGrayCell)]);
    subses{direction} = iDir*2+iBit;
    
    subses0 = repmat({':'}, [1 ndims(oldGrayCell)]);
    subses0{direction} = iDir+1;    
    
    newGrayCell(subses{:}) = cellfun((@(c) addBit(c,initial_enum(iBit))),oldGrayCell(subses0{:}),'UniformOutput',false);
    end
    initial_enum = ~initial_enum;
end


end
end
