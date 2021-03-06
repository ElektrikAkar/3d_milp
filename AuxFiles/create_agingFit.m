function [fitresult, gof] = create_agingFit(time, SOH, is_one)
%CREATEFIT(A,B)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : a
%      Y Output: b
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 04-Aug-2020 06:38:05


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( time, SOH );

% Set up fittype and options.

if(is_one)
    ft = fittype( ['a*sqrt(x)+',num2str(SOH(1))], 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.MaxFunEvals = 600000;
    opts.MaxIter = 400000;
    opts.StartPoint = [0.962289417231341];
else
    ft = fittype( 'a*sqrt(x)+b', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Lower = [-Inf -3];
    opts.MaxFunEvals = 60000;
    opts.MaxIter = 40000;
    opts.StartPoint = [0.298960295647912 100];
end
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% % Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'b vs. a', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% xlabel( 'a', 'Interpreter', 'none' );
% ylabel( 'b', 'Interpreter', 'none' );
% grid on

end
