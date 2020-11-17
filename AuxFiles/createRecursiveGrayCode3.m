function [K,C,Z] = createRecursiveGrayCode3(d)
%MIP formulations for piecewise linear functions Huchette and Vielma
%It creates all K, C, Z. 
if(d==1)
    K = [false;true];
    C = [false;true];
    Z = [false;true];
else
    [tempK, tempC, tempZ] = createRecursiveGrayCode3(d-1);
    
    K = [tempK, false(size(tempK,1),1);tempK(end:-1:1,:),true(size(tempK,1),1)];
    
    C = 0 ; %[tempC, false(size(tempC,1),1);boolean( true(size(tempC,1),1)*tempC')    ,true(size(tempC,1),1)];
    
    Z = [tempZ, false(size(tempZ,1),1);tempZ    ,true(size(tempZ,1),1)];
end

end