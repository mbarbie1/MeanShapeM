function [p_val, t, pp, p] = shape_ellipse( r1, r2, rot, shift, smooth_factor, n_points )
%SHAPE_ELLIPSE Calculates a polygon approximating an ellipse
    t = linspace( 0, n_points, n_points + 1 );
    tt = 2 * pi * (t ./ max(t) + shift);
    %tt = shift(tt, shift );
    yy = r1 * sin( tt );
    xx = r2 * cos( tt );
    p = [xx; yy];
    pp = spcsp( t, p, smooth_factor);
    p_val = ppval( pp, t );
end
