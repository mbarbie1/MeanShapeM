function u_smooth = diff_smooth_gamma( u, w, min_u, max_u )
% diff_smooth_gamma Computes the discrete gauss (or nearest neighbour) 
%   like smoothing of a 1D function with periodic boundary
%   conditions and with w a vector or a number, points should be always
%   inside the boundaries and they should be ordered according value
    u_smooth = ( w * circshift( u, -1 ) + w .* circshift( u, 1 ) + 2 * ( 2 - w ) .* u ) / 4;
    % find the points closest to min_u and max_u and apply periodic BCs for
    % them
    [~, i_1] = min( u );
    [~, i_end] = max( u );
    i_1_plus = mod(i_1 + 1, length(u));
    i_end_min = i_end - 1;
    if i_end_min < 1
        i_end_min = length(u);
    end
    u_smooth( i_1 ) = ( w * u( i_1_plus ) + 2 * ( 2 - w ) * u( i_1 ) + w * ( min_u - max_u + u( i_end ) ) ) / 4;
    u_smooth( i_end ) = ( w * ( u( i_1 ) - min_u + max_u ) + 2 * ( 2 - w ) * u( i_end ) + w * u( i_end_min ) ) / 4;
end
