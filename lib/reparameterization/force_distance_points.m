function [repell, attract] = force_distance_points( u, min_u, max_u, min_ratio, max_ratio, min_a, max_a )
%FORCE_REPELL gives the force due to repelling close points ( close is 
%   smaller than reg_a * length of the curve / n_points

    du = d_periodic( u, 1.0, min_u, max_u );
    n_points = length( u );
    mean_du = 1.0 / n_points;
    min_du = mean_du * min_ratio;
    max_du = mean_du * max_ratio;

    du_forward = sign(du) .* abs(du);
    du_backward = - sign( -circshift( du, 1 ) ) .* abs( -circshift( du, 1 ) );
    repell_forward = -exp( - min_a * ( du_forward - min_du ) / min_du );
    repell_backward = exp( - min_a * ( du_backward - min_du ) / min_du );
    repell = repell_forward + repell_backward;

    attract_forward = exp( max_a * ( du_forward - max_du ) / mean_du );
    attract_backward = -exp( max_a * ( du_backward - max_du ) / mean_du );
    attract = attract_forward + attract_backward;

end

