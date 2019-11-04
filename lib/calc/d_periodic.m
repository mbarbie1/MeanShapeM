function du = d_periodic( u, dt, min_u, max_u )
% d_periodic_1d Computes the derivative of a 1D function with periodic boundary
%   conditions and with dt a vector or a number
    u_diff = circshift(u,-1) - u;
    u_diff(end) = u(1) - min_u + max_u - u(end);
    du = u_diff ./ dt;
end

