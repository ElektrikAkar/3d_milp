% This is test file to see if approximation really works! 
%clc;
% % dT approx testing: 
% fprintf('Unit tests are commencing\n');
% uTest.N = length(sol.sdpv.bat.Pcell_approx);
% uTest.real.dQ = zeros(uTest.N,1);
% for i_uTest =1:uTest.N
%     uTest.real.dQ(i_uTest) = func.dQcell_Pt(sol.sdpv.bat.Pcell_approx(i_uTest),sol.sdpv.bat.SOCavg(i_uTest),sol.sdpv.bat.Tk_avg(i_uTest));
%     
% end
% uTest.real.dQ
% sol.sdpv.bat.thermal_approx.dQ

%% Unit test delaunay triangulation. 
uTest.sum = 0;
for i_uTest =1:size(Edges,1)
    uTest.temp = nnz(abbc(Edges(i_uTest,1),:)-abbc(Edges(i_uTest,2),:));
    if(uTest.temp ~=1)
        error("sad");
    end
end

fprintf('Test is successful!!\n');




