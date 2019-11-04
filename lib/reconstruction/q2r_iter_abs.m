function [ r, rs, mean_step_sizes ] = q2r_iter_abs( r_init, q, t, step_factor, b_reg, max_iter, precision_factor )
%Q2R converts a curve from q-space to r-space, an initial guess for r 
% should be given. This function uses the approximate iterative formula.

%    initial_r()
    eps = 0.0000000000001;
    dt = 1.0;
    n = length(t);
    cur_r = normv( r_init );
    precision = precision_factor * mean( cur_r );

    previous_step_size = ones( 1, n );
    rs = {};
    mean_step_sizes = [];
    
    c = q;
    c_abs = normv( c );
    q_abs = normv( q );
    nvec = q ./ q_abs;

    r = cur_r .* nvec;
    rs{1} = r;

    iter = 0;
    while ( ( mean( previous_step_size ) > precision ) && ( iter < max_iter ) )

        r = cur_r .* nvec;
        v = dw( r, dt );
        norm_r = cur_r;
        %reg_diff = dm( norm_r, dt );
        %reg_diff_order2 = dm( reg_diff, dt );
        prev_r = cur_r;
        cur_dr = ( c_abs ./ sqrt(normv(v)) - cur_r ); % + b_reg .* reg_diff_order2;

        max_dr = max( abs( cur_dr ) );
        if ( max_dr < eps)
            return;
        end
		inv_max_dr = 1.0 / max_dr;
        cur_dr = cur_dr * inv_max_dr;
        cur_r = cur_r + step_factor .* cur_dr;
        
        previous_step_size = abs( cur_r - prev_r );
        mean_step_size = mean(previous_step_size);

        iter = iter + 1;
        precision = precision_factor * mean( cur_r );
        rs{end+1} = r;
        mean_step_sizes(end+1) = mean_step_size;
    end

end

