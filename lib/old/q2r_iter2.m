function [ r, rs, sum_step_sizes ] = q2r( r_init, q, t, step_factor, b_reg, max_iter )
%Q2R converts a curve from q-space to r-space, a initial guess for r should
% be given.

%    initial_r()
    dt = 1.0;
    n = length(t);
    cur_r = normv( r_init );
    prev_r = cur_r;

    precision = 0.0000001;
    previous_step_size = ones( 1, n );
    rs = {};
    sum_step_sizes = [];
    ens = [];
    
    c = q;
    c_abs = normv( c );
    q_abs = normv( q );
    nvec = q ./ q_abs;

    r = cur_r .* nvec;
    rs{1} = r;

    iter = 0;
    while ( ( sum( previous_step_size ) > precision ) && ( iter < max_iter ) )
        
        r = cur_r .* nvec;
        v = dw( r, dt );
        norm_r = cur_r;
        reg_diff = dm( norm_r, dt );
        reg_diff_order2 = dm( reg_diff, dt );
        f = cur_r .* sqrt( normv(v) ) - c_abs;
        prev_r = cur_r;
        cur_r = cur_r - ( step_factor * f ) + b_reg .* reg_diff_order2;
        previous_step_size = abs( cur_r - prev_r );
        sum_step_size = sum(previous_step_size);

        iter = iter + 1;
        rs{end+1} = r;
        sum_step_sizes(end+1) = sum_step_size;
%        ens(end+1) = en;
    end

end

