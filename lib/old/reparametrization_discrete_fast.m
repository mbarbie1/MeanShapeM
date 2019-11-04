function [g, ens] = reparametrization_discrete_fast( n_iter, init_g, grad_factor, local_smoothing, min_dg, max_a, slope_ratio, reg_g, slope_ratio_reg, min_t, max_t, ru, vu, au, rr_table )
% REPARAMETRIZATION_DISCRETE this is the discrete version of the
%   reparametrization function which uses a lookup table instead of to
%   calculate the positions

    % Defines the resolution of the hyper-resolution-table, we use this to
    % avoid taking to small steps (two points ending up within the
    % resolution.
    min_resolution = ( max_t - min_t ) / length( rr_table );

    % The ~stepsize is made smaller by the distance restriction, it is also
    % enlarged if the minimal distance is larger than the average, this is
    % the maximal enlargement
    max_enlarge_step_ratio = 2;

    % If there is smoothing, make the smoothing start with a high value and
    % then decrease to zero by half of the iterations
    if local_smoothing > 0
        local_smoothing_slope = 0.0 * ones( 1, n_iter );
        local_smoothing_slope( 1:round(n_iter/2) ) = local_smoothing * linspace( 1, 0, round(n_iter/2) );
    end

    do_norm_force_elastic = 0;
    if reg_g > 0
        % If there is a repulsion/attraction force applied, the distance over
        % which it works starts at 1 and goes to the lower value min_dg.
        n_slope = round(slope_ratio * n_iter);
        min_dg_slope = min_dg * ones( 1, n_iter );
        if n_slope > 0
            min_dg_slope( 1:n_slope ) = linspace( 1, min_dg, n_slope );
        end
        
        % If there is a repulsion/attraction force applied, the strenght of
        % it is gradually lowered to the target value, this is supposed to
        % increase the speed of convergence in the beginning
        start_ratio_reg_b = 8;
        n_slope = round(slope_ratio_reg * n_iter);
        reg_g_slope = reg_g * ones( 1, n_iter );
        if n_slope > 0
            reg_g_slope( 1:n_slope ) = linspace( start_ratio_reg_b * reg_g, reg_g, n_slope );
        end
    end
    
    % Energy values
    ens = zeros(n_iter + 1, 1);
    % Initial gamma function
    g = init_g;
    min_g = min_t;
    max_g = max_t;
    dt = 1.0;
    
    % calculate q for energy calculation
    q = sqrt( normv(vu) ) .* ru;
    % calculate first qq for energy calculation
    n_table = length(rr_table);
    rr = p_lookup( rr_table, n_table, g, min_g, max_g );
    vv = dw( rr, dt );
    qq = sqrt( normv(vv) ) .* rr;
    ens(1) = sum( normv( q - qq ).^2 );

    
    for iter = 1:n_iter

        dt = 1;
        rr = p_lookup( rr_table, n_table, g, min_g, max_g );
        vv = dw( rr, dt );
        aa = dw( vv, dt );

        [ der, ~, ~, ~] = rhs( ru, rr, vu, vv, au, aa );

        dg_prop = - grad_factor * der;

        % Limit dg so dg_prop is maximal 0.2 of the minimal difference
        % between the points, this is similar but not the same as scaling
        % the step-size.
        normalization_factor = 0.2;
        g_diff = d_periodic( g, 1.0, min_g, max_g );
        min_combination = min( ( abs(g_diff(1:end)) - min_resolution ) ./ abs( dg_prop(1:end) ) );
        dg_normalization = normalization_factor * min_combination; % min_g_diff / max_dg_prop;
        dg_prop = min( dg_normalization, max_enlarge_step_ratio ) * dg_prop;
        
        % Repulsion/attraction force
        if reg_g > 0
            min_a = 1;
            [repell, attract] = force_distance_points( g, min_g, max_g, min_dg_slope(iter), 1 / min_dg_slope(iter), min_a, max_a );
            force_elastic = repell + attract;
            d_force_elastic = reg_g_slope(iter) * force_elastic;
            if do_norm_force_elastic
                normed_force_elastic = sign(d_force_elastic) .* min( abs(d_force_elastic), 0.2 * min( abs( g_diff ), abs( circshift( g_diff, 1 ) ) ) );
                dg_prop = dg_prop + normed_force_elastic;
            else
                dg_prop = dg_prop + d_force_elastic;
            end
        end
        
        g_prop = g + dg_prop;

        % Smoothing term (Jozsef) between [ 0, 2] 0 means no smoothing, 1
        % means smoothing as a Gaussian approx, 2 means the points are
        % taken as the average of the neighboring points. Something is
        % still wrong with this smoothing, although not the same
        % implementation as Joszef I expected similar results
        if local_smoothing > 0
            w = local_smoothing_slope(iter);
            g_prop = diff_smooth_gamma( g_prop, w, min_g, max_g );
        end
        
        % Make the new gamma ( = g) equal to the proposed gamma (= g_prop)
        g = g_prop;
        
        % Calculate the energy
        qq = sqrt( normv(vv) ) .* rr;
        ens( iter + 1 ) = sum( normv( q - qq ).^2 );
    end
end

