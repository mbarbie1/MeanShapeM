function [ r, rs, mean_step_sizes, ens ] = q2r_iter_vec( r_init, q, step_factor, max_iter )
%Q2R converts a curve from q-space to r-space, an initial guess for r 
% should be given. This function uses the approximate iterative formula.

%    initial_r()
    dt = 1.0;
    rs = {};
    mean_step_sizes = [];
    ens = [];
    
    c = q;
    r = r_init;
    rs{1} = r;
    eps = 0.00000000000000000001;
    
    iter = 0;
    while ( iter < max_iter )
        
        r_old = r;
        v = dw( r_old, dt );
        %test_temp1 = c ./ sqrt(normv(v));
        %test_temp2 = c ./ sqrt(normv(v)) - r;
        %tmp(iter+1) = sum( normv( step_factor .* ( c ./ sqrt(normv(v)) - r ) ) );
        
        %r = r + step_factor .* ( c ./ sqrt(normv(v)) - r );
        %THIS IS A TEST TO SEE THE ENERGY
        f = [ sqrt( normv( v ) ) ; sqrt( normv( v ) ) ];
        r = r_old + step_factor .* ( (c + eps) ./ (f + eps) - r_old );
        qq = f .* r_old;
        iter = iter + 1;
        rs{end+1} = r;
        mean_step_sizes(end+1) = sum( normv( r - r_old ) );
        ens(end+1) = sum( normv( qq - c ) );
    end
end
