
function cost = to_be_minimized(PX,SOCX,TX,func,test_points)

my_quad = func_solve_quad_eq(PX,SOCX,TX,func,0);
test_points.F = griddedInterpolant(PX,SOCX,TX,my_quad.t_EOL_h);

test_points_interpolated = test_points.F(test_points.PX,test_points.SOCX,test_points.TX);

cost = mean(abs(test_points_interpolated(:) - test_points.quad.t_EOL_h(:) ));

end