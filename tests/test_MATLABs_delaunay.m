clear all;
% Number of segments.
delu.nx = 14;
delu.ny = 8;
delu.nz = 4;


[x,y,z] = meshgrid(1:(delu.nx+1),1:(delu.ny+1),1:(delu.nz+1));
delu.dt = delaunayTriangulation(x(:),y(:),z(:));

delu.n_points = (size(delu.dt.Points,1));

delu.n_trig = (size(delu.dt.ConnectivityList,1));

delu.d = ceil(log2(delu.n_trig)); % logaritmich variables.

delu.gray_raw = createRecursiveGrayCode(delu.d);

delu.gray = delu.gray_raw(1:delu.n_trig,:);

delu.delta         = repmat({false(delu.nx+1,delu.ny+1,delu.nz+1)},delu.d,1);
delu.one_min_delta = repmat({false(delu.nx+1,delu.ny+1,delu.nz+1)},delu.d,1);

delu.VertexAttachments = vertexAttachments(delu.dt);

for i =1:delu.n_points
   % delu.dt.Points(delu.dt.ConnectivityList(1,:)',:)
    
    
    delu.possib       = delu.gray(delu.VertexAttachments{i}',:);
    
    delu.non_changing = delu.possib(1,:);
    
    delu.outcome      = all(delu.possib==delu.non_changing,1);
    
    for iOut = 1:delu.d
        if(delu.outcome(iOut)) %if it is a non-changing variable.
            tmp = delu.dt.Points(i,:);
            if(delu.non_changing(iOut)) %then if it is 1 it is delta
                delu.delta{iOut}(tmp(1),tmp(2),tmp(3)) = true;
            else %else it is 1-delta
                delu.one_min_delta{iOut}(tmp(1),tmp(2),tmp(3)) = true;
            end
        end
    end
end





