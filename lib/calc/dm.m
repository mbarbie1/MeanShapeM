function dp = dm( p, dt )
%D Computes the derivative of the 2D curves described by p1 and p2 with the
%   dt a vector or a number
    dp = 0.5 .* ( circshift(p,-1,2) - circshift(p,+1,2) ) ./ dt;
end

