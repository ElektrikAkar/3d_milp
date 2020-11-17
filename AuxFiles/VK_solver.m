function I_sol = VK_solver(P_t,SOC_pu,Tk,func_UOCV,func_dU)

p = size(P_t,1);
q = size(SOC_pu,2);
r = size(Tk,3);

I_sol = (P_t.*ones(p,q,r))/3.2;

err =  I_sol.*(func_UOCV(SOC_pu)+func_dU(I_sol,SOC_pu,Tk))  - P_t;
% power_fun = @(I_sol) I_sol.*(func_UOCV(SOC_pu)+func_dU(I_sol,SOC_pu,Tk))  - P_t;
% yy = power_fun(-20:0.1:5);
%plot(-20:0.1:5,power_fun(-20:0.1:5))
alpha = 0.25;
i=1;
while(norm(err(:),'inf')>1e-6)
   I_sol = I_sol - alpha*err;
   err =  I_sol.*(func_UOCV(SOC_pu)+func_dU(I_sol,SOC_pu,Tk))  - P_t;
   if(i>4000)
       error('Maximum iteration achieved!');
   end
   i=i+1;
%   alpha = alpha*0.95;
end
%fprintf('iteration is %d\n',i);

end