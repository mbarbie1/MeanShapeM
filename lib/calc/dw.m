function dp = dw( p, dt )
%D Computes the derivative of the 2D curves described by p1 and p2 with the
%   dt a vector or a number, 
%   TODO: we added a minimal positive constant 100 times the minimum
%   positive value of a single
    p_forward = circshift( p, -1, 2 ) - p;
    p_back = p - circshift( p, 1, 2 );
    norm_forward = normv( p_forward );
    norm_back = normv( p_back );
    dp = (norm_back .* p_forward + norm_forward .* p_back) ./ (norm_back + norm_forward + 100 * realmin('single')) ./ dt;
    %dp = (norm_forward .* p_forward + norm_back .* p_back) ./ (norm_back + norm_forward) ./ dt;
end
