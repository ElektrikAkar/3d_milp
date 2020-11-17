function quad_eq = func_solve_quad_eq(P_t, SOC_pu, Tk, func, extras, given_It, calCyc)
% To solve quadratic equation stemmed from Schimpe's aging equations. 
% Author : VK
% Date   : 
% P_t: cell power 
% func is a function handle.  
% extras: true or false, just to get extra values if needed
% if given_It is true then It is given instead of P_t.

KELVIN      = 273.15; 
quad_eq.EOL = 0.2;    % End of life 20%

p = size(P_t,1);
q = size(SOC_pu,2); % remove these for more generality! Such as all row vectors.
r = size(Tk,3);

quad_eq.P_t  = P_t.*ones(p,q,r);
quad_eq.SOC  = SOC_pu.*ones(p,q,r); 

quad_eq.Tk = Tk.*ones(p,q,r);

if(nargin<6)
    quad_eq.I_t = func.It(quad_eq.P_t,quad_eq.SOC,quad_eq.Tk);
else
    if given_It
    quad_eq.I_t    = P_t;
    quad_eq.P_t(:) = NaN;
    else
        quad_eq.I_t = func.It(quad_eq.P_t,quad_eq.SOC,quad_eq.Tk);
    end
end


if(nargin<7 || calCyc=="both")

quad_eq.func.k_cyc_low_T           = func.k_cyc_low_T(quad_eq.I_t,quad_eq.Tk)   .*ones(size(quad_eq.SOC));
quad_eq.func.k_cyc_high_T          = func.k_cyc_high_T(quad_eq.I_t,quad_eq.Tk)  .*ones(size(quad_eq.SOC)); 
quad_eq.func.k_cal                 = func.k_cal(quad_eq.SOC, quad_eq.Tk)        .*ones(size(quad_eq.I_t));
quad_eq.func.k_cyc_low_T_high_SOC  = func.k_cyc_low_T_high_SOC(quad_eq.I_t,quad_eq.SOC,quad_eq.Tk); 

elseif(calCyc=="cal")
quad_eq.func.k_cyc_low_T           = 0;
quad_eq.func.k_cyc_high_T          = 0; 
quad_eq.func.k_cal                 = func.k_cal(quad_eq.SOC, quad_eq.Tk)        .*ones(size(quad_eq.I_t));
quad_eq.func.k_cyc_low_T_high_SOC  = 0; 
    
    
elseif(calCyc=="cyc")
quad_eq.func.k_cyc_low_T           = func.k_cyc_low_T(quad_eq.I_t,quad_eq.Tk)   .*ones(size(quad_eq.SOC));
quad_eq.func.k_cyc_high_T          = func.k_cyc_high_T(quad_eq.I_t,quad_eq.Tk)  .*ones(size(quad_eq.SOC)); 
quad_eq.func.k_cal                 = 0;
quad_eq.func.k_cyc_low_T_high_SOC  = func.k_cyc_low_T_high_SOC(quad_eq.I_t,quad_eq.SOC,quad_eq.Tk);     
    
end

quad_eq.a = quad_eq.func.k_cyc_low_T_high_SOC.* abs(quad_eq.I_t);
quad_eq.b = quad_eq.func.k_cal +...
            quad_eq.func.k_cyc_high_T.*sqrt(abs(quad_eq.I_t)) +...
            quad_eq.func.k_cyc_low_T.*sqrt(abs(quad_eq.I_t)); 
        
quad_eq.c = repmat(-quad_eq.EOL,size(quad_eq.b));

%tic;
quad_eq.DELTA =  quad_eq.b.^2 - 4*quad_eq.a.*quad_eq.c;

qoad_eq_root1  = (-quad_eq.b + sqrt(quad_eq.DELTA))./(2*quad_eq.a);
%qoad_eq_root2 = (-quad_eq.b - sqrt(quad_eq.DELTA))./(2*quad_eq.a);

quad_eq.root2 = ones(size(quad_eq.a));

quad_eq.a_zero = abs(quad_eq.a)<=eps; %quad_eq.a==0

quad_eq.root2(quad_eq.a_zero) = -quad_eq.c(quad_eq.a_zero)./quad_eq.b(quad_eq.a_zero);
quad_eq.root2(~quad_eq.a_zero) = qoad_eq_root1(~quad_eq.a_zero);
%toc
quad_eq.t_EOL_h = (quad_eq.root2).^2; 
quad_eq.Nsize   = size(quad_eq.t_EOL_h);

% tic; 
% quadroots = zeros(size(quad_eq.a));
% 
% for i =1:numel(quadroots)
%     temp_roots = roots([quad_eq.a(i), quad_eq.b(i), quad_eq.c(i)]);
%     quadroots(i) = max(temp_roots);
% end
% toc


if(extras)
    quad_eq.P_tX = ones(size(quad_eq.root2)).*quad_eq.P_t;
    quad_eq.X = ones(size(quad_eq.root2)).*quad_eq.I_t;
    quad_eq.Y = ones(size(quad_eq.root2)).*quad_eq.SOC;
    quad_eq.Z = ones(size(quad_eq.root2)).*quad_eq.Tk-KELVIN;
    
    quad_eq.V = (quad_eq.root2).^2/(365*24+6);
else
    quad_eq = rmfield(quad_eq, "root2");
    quad_eq = rmfield(quad_eq, "a_zero");
    quad_eq = rmfield(quad_eq, "DELTA");
    quad_eq = rmfield(quad_eq, "a");
    quad_eq = rmfield(quad_eq, "b");
    quad_eq = rmfield(quad_eq, "func");
end



end