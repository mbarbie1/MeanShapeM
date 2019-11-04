function [p_val, t, pp, p] = shape_circle_intrusion( r1, r2, depth, width, intrusion_angle, rot, shift, smooth_factor, n_points )
%SHAPE_ELLIPSE Calculates a polygon approximating an ellipse
    t = linspace( 0, n_points, n_points + 1 );
    tt = 2 * pi * (t ./ max(t) + shift);
    %tt = shift(tt, shift );
    r = 1 - depth * exp( - ( tt - intrusion_angle ).^2 / width^2 );
    yy = r .* r1 .* sin( tt );
    xx = r .* r2 .* cos( tt );
    p = [xx; yy];
    smooth_factor = 1;
    pp = spcsp( t, p, smooth_factor);
    p_val = ppval( pp, t );
end
