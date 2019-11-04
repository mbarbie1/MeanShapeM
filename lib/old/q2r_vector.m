function [ r, rs, sum_step_sizes ] = q2r_vector( r_init, q, t, step_factor, b_reg, max_iter )
%Q2R converts a curve from q-space to r-space, a initial guess for r should
% be given.

%    initial_r()
    dt = 1.0;
    n = length(t);
    cur_r = r_init;
    prev_r = cur_r;

    precision = 0.1;
    previous_step_size = ones( 1, n );
    rs = {};
    sum_step_sizes = [];
    
    c = q;
    rs{1} = cur_r;

    iter = 0;
    while ( ( sum( previous_step_size ) > precision ) && ( iter < max_iter ) )
        
        r = cur_r;
        v = dw( r, dt );
        reg_diff = dw( r, dt );
        reg_diff_order2 = dw( reg_diff, dt );
        f = cur_r .* sqrt( normv(v) ) - c;
        prev_r = cur_r;
        cur_r = cur_r - ( step_factor * f ) + b_reg .* reg_diff_order2;
        previous_step_size = normv( cur_r - prev_r );
        sum_step_size = sum(previous_step_size);

        iter = iter + 1;
        rs{end+1} = r;
        sum_step_sizes(end+1) = sum_step_size;
    end

end

