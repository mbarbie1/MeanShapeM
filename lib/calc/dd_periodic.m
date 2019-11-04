function du = dd_periodic( u, dt, min_u, max_u )
% d_periodic_1d Computes the derivative of a 1D function with periodic boundary
%   conditions and with dt a vector or a number 
    u_diff = ( circshift(u,-1) + circshift(u,+1) - 2 .* u );
    u_diff(1) = ( u(2) - u(1) ) - ( u(1) - min_u + max_u - u(end) );
    u_diff(end) = ( u(1) - min_u + max_u - u(end) ) - ( u(end) - u(end-1) );
    du = u_diff ./ dt.^2;
end

