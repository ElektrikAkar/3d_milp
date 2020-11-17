
test.ag1  = norm(sol.sdpv.bat.CalAging.tot,2)*sqrt(arbj.dth)

test.t1   = 12*30*24;  % 1 month 
test.f1   = func.k_cal(0.1,KELVIN+18); 

test.ag2  = sqrt(arbj.dth)*norm([sqrt(test.t1/arbj.dth)*test.f1;sol.sdpv.bat.CalAging.tot],2)

test.ag22 = test.ag2 - sqrt(test.t1)*test.f1 %#ok<*NOPTS>


test.times_t1 =  (0:0.02:48);
test.times_ag22 = zeros(length(test.times_t1),1); 

for i=1:length(test.times_t1)
    test.t1 = test.times_t1(i)*30*24; 
    test.ag2  = sqrt(arbj.dth)*norm([sqrt(test.t1/arbj.dth)*test.f1;sol.sdpv.bat.CalAging.tot],2);

    test.times_ag22(i) = test.ag2 - sqrt(test.t1)*test.f1;
    
end
%%
close all;
figure;
semilogy(test.times_t1,test.times_ag22); grid on;

ylabel('Cal aging [pu]');
xlabel('waiting time before first use [mo]');
xlim([-1,50])


figure;
plot(test.times_t1,test.times_ag22(1)./test.times_ag22); grid on;

ylabel('Cal aging without waiting / Cal aging with waiting ');
xlabel('waiting time before first use [mo]');

figure;
plot(test.times_t1,arbj.bat.Cost_pu*test.times_ag22); grid on; hold on; 
plot(test.times_t1,repmat(-sum(sol.Jstep.AC_power),1,length(test.times_t1)),'--');
legend('Cal. aging cost','Profit w/o cal aging');

ylabel('Profit/cost [EUR]');
xlabel('waiting time before first use [mo]');
xlim([-1,50])