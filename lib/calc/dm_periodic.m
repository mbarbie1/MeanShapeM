function du = dm_periodic( u, dt, min_u, max_u )
% d_periodic_1d Computes the derivative of a 1D function with periodic boundary
%   conditions and with dt a vector or a number 
    u_diff = ( circshift(u,-1) - circshift(u,+1) ) / 2;
    u_diff(1) = ( u(2) - min_u + max_u - u(end) ) / 2;
    u_diff(end) = ( u(1) - min_u + max_u - u(end-1) ) / 2;
    du = u_diff ./ dt;
end

