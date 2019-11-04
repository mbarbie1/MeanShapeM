function du = dd_gamma( u, dt, min_u, max_u )
% d_periodic_1d Computes the derivative of a 1D function with periodic boundary
%   conditions and with dt a vector or a number,  points should be always
%   inside the boundaries and they should be ordered according value

    u_diff = ( circshift(u,-1) + circshift(u,+1) - 2 .* u );
    % find the points closest to min_u and max_u and apply periodic BCs for
    % them
    [~, i_1] = min( u );
    [~, i_end] = max( u );
    i_1_plus = mod(i_1 + 1, length(u));
    i_end_min = i_end - 1;
    if i_end_min < 1
        i_end_min = length(u);
    end
    u_diff( i_1 ) = ( u( i_1_plus ) - u( i_1 ) ) - ( u( i_1 ) - min_u + max_u - u( i_end ) );
    u_diff( i_end ) = ( u( i_1 ) - min_u + max_u - u( i_end ) ) - ( u( i_end ) - u( i_end_min ) );
    du = u_diff ./ dt.^2;

    
end

