function [ r, rs, mean_step_sizes ] = q2r_newton( r_init, q, max_iter, step_factor, precision_factor )
%Q2R_NEWTON converts a curve from q-space to r-space, an initial guess for 
% r should be given. This function uses the newton-raphson approach.

    r = r_init;
    n_points = length(q);
    n = n_points;
    A = speye( n );
    rs = {};
    mean_step_sizes = [];
    rs{end+1} = r;
    r_norm = normv( r );
    u = r ./ normv( r );
    uplus = circshift( u, -1, 2 );
    umin = circshift( u, 1, 2 );
    % Init at large number
    mean_step_size = 1000000000000;
    eps = 0.000000000000001;

    iter = 0;
    while (iter <= max_iter) && ( mean_step_size > precision_factor  )
        iter = iter + 1;
        r_old = r;
        r_norm_old = r_norm;
        [A, b] = update_newton( A, r, q, uplus, umin );
        r_norm = (A \ b')';

%         % make the maximum step smaller
%         r_new = [ r_norm; r_norm ] .* u;
%         cur_dr = r_new - r_old;
%         max_dr = max( normv( cur_dr ) );
%         if ( max_dr < eps)
%             return;
%         end
% 		inv_max_dr = 1.0 / max_dr;
%         r_norm = r_norm * inv_max_dr;
        
        % TEST smoothing
        w = 1;
        r_norm = ( w * circshift( r_norm, -1 ) + w .* circshift( r_norm, 1 ) + 2 * ( 2 - w ) .* r_norm ) / 4;
        
        r_new = [ r_norm; r_norm ] .* u;
        
        r = r_old + step_factor * (r_new - r_old);
        rs{end+1} = r;
        mean_step_size = mean( normv( r - r_old ) );
        mean_step_sizes(end+1) = mean_step_size;
    end

end
