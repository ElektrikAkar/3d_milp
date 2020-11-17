function Zq = interp22(X,Y,Z,Xq,Yq)
X1 = X(:);
Y1 = (Y(:))';

X1 = X1.*ones(size(Z));
Y1 = Y1.*ones(size(Z));

tic;

F = griddedInterpolant(X1,Y1,Z);

Zq = F(Xq.*ones(size(Yq)), Yq.*ones(size(Xq)));
% toc
% tic;
% G  = scatteredInterpolant(X1(:),Y1(:),Z(:));
% 
% GZq = G(Xq.*ones(size(Yq)), Yq.*ones(size(Xq)));
% toc
%disp(3);



% if(ndims(Xq)>2)
%    p = length(Xq);
%    [m,n] = size(Yq);
%    if(m==1)
%        Xq_temp(:,1) = Xq(1,1,:);
%        Zq(1,1:n,1:p) = interp2(X,Y,Z, Xq_temp,  Yq)';
%    else
%        Xq_temp(1,:) = Xq(1,1,:);
%        Zq(:,1:n,1:p) = interp2(X,Y,Z, Xq_temp,  Yq);
%    end
%    
% elseif(ndims(Yq)>2)
%    p = length(Yq);
%    [m,n] = size(Xq);
%    if(m==1)
%        Yq_temp(:,1) = Yq(1,1,:);
%        Zq(1,1:n,1:p) = interp2(X,Y,Z, Xq,  Yq_temp)';
%    else
%        Yq_temp(1,:) = Yq(1,1,:);
%        Zq(1:n,1,1:p) = interp2(X,Y,Z, Xq,  Yq_temp);
%    end
%    
% else
%    Zq = interp2(X,Y,Z, Xq,  Yq);
% end

end