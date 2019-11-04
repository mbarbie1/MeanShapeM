function [p_val, t, pp, p] = shape_manual_intrusion( ry, rx, depth, width, smooth_factor, n_points )
%SHAPE_MANUAL_INTRUSION Calculates a polygon approximating an ellipse
    n1 = n_points / 4;
    n2 = n_points / 4;
    n3 = n_points - n1 - 2*n2 + 4;

    t = linspace(0, 2*pi, n_points);
    ry_inner_ratio = width/ry;

    r1 = ry;
    t1 = linspace(0, pi, n1) - pi/2;
    r2 = (1-ry_inner_ratio) * ry / 2;
    t2 = -linspace(0, pi, n2) - pi/2;
    r3 = r1-2*r2;
    t3 = linspace(0, pi, n3) - pi/2;

    y1 = r1 .* sin( t1 );
    x1 = rx .* cos( t1 );

    y2 = (r1-r2) + r2 .* sin( -t2 );
    x2 = depth * rx .* cos( -t2 );

    y3 = (-r1+r2) + r2 .* sin( -t2 );
    x3 = depth * rx .* cos( -t2 );

    y4 = r3 .* sin( -t3 );
    x4 = depth .* rx .* cos( -t3 );

    xx = [ x1(1:(end-1)), x2(1:(end-1)), x4(1:(end-1)), x3(1:(end-1)) ];
    yy = [ y1(1:(end-1)), y2(1:(end-1)), y4(1:(end-1)), y3(1:(end-1)) ];
    c = linspace( 1, 10, length( xx ) );
    figure();
    scatter( xx, yy, 5, c );
    axis equal;

    y0 = ry .* sin( t );
    x0 = rx .* cos( t );

    p = circshift([xx; yy], -round(n_points / 8) + 1, 2);
    
    figure();
    scatter( p(1,:), p(2,:), 5, c );
    axis equal;

    smooth_factor = 1;
    pp = spcsp( t, p, smooth_factor);
    p_val = ppval( pp, t );

end
