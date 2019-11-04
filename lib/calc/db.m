function dp = db( p, dt )
%D Computes the derivative of the 2D curves described by p1 and p2 with the
%   dt a vector or a number
p_diff = p - circshift(p,1,2);
dp = p_diff ./ dt;
end

