function [ r, rs, mean_step_sizes ] = q2r_iter( r_init, q, t, step_factor, b_reg, max_iter, precision )
%Q2R converts a curve from q-space to r-space, a initial guess for r should
% be given.

    dt = 1.0;
    n = length(t);
    cur_r = r_init;
    prev_r = cur_r;

    precision = 0.00000001;
    previous_step_size = ones( 1, n );
    rs = {};
    mean_step_sizes = [];
    
    c = q;
    r = cur_r;
    rs{1} = r;

    iter = 0;
    while ( ( mean( previous_step_size ) > precision ) && ( iter < max_iter ) )
        
        r = cur_r;
%%        
        %norm_r = normv(cur_r);
        reg_diff = dm( cur_r, dt );
        reg_diff_order2 = dm( reg_diff, dt );
%%        
        v = dw( r, dt );
        f = sqrt( normv(v) );
        prev_r = cur_r;
        %cur_r = ( step_factor * ( c./f - cur_r ) + cur_r ) + b_reg .* reg_diff_order2;
        cur_r = b_reg .* reg_diff_order2  + cur_r;
        previous_step_size = normv( cur_r - prev_r );
        mean_step_size = mean(previous_step_size);

        iter = iter + 1;
        rs{end+1} = r;
        mean_step_sizes(end+1) = mean_step_size;
%        ens(end+1) = en;
    end

end

