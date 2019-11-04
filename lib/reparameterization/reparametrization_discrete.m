function [g, ens] = reparametrization_discrete( n_iter, init_g, grad_factor, precision, local_smoothing, normalization_method, min_t, max_t, ru, vu, au, rr_table, centroid )
% REPARAMETRIZATION_DISCRETE this is the discrete version of the
%   reparametrization function which uses a lookup table instead of to
%   calculate the positions

    C = Constants;

    % Defines the resolution of the hyper-resolution-table, we use this to
    % avoid taking to small steps (two points ending up within the
    % resolution.
    min_resolution = ( max_t - min_t ) / length( rr_table );

    % The ~stepsize is made smaller by the distance restriction, it is also
    % enlarged if the minimal distance is larger than the average, this is
    % the maximal enlargement
    max_enlarge_step_ratio = 2;
    
    % The minimum ratio of points for the (smart) smoothing to activate
    % during that iteration
    min_ratio_close_or_far_points = 0.005;
    
    % Energy values
    ens = zeros(n_iter + 1, 1);
    % Initial gamma function
    g = init_g;
    min_g = min_t;
    max_g = max_t;
    dt = 1.0;
    n_points = length(ru);
    
    % calculate q for energy calculation
    q = sqrt( normv(vu) ) .* ru;
    % calculate first qq for energy calculation
    n_table = length(rr_table);
    rr = p_lookup( rr_table, n_table, g, min_g, max_g, centroid );
    vv = dw( rr, dt );
    old_vv = vv;
    qq = sqrt( normv(vv) ) .* rr;
    ens(1) = sum( normv( q - qq ).^2 );
    dt = 1;
    min_energy_difference = precision * ens(1);
    den = ens(1);
    
    iter = 0;
    stop_criterium = false;
    while ( iter <= n_iter ) && ( stop_criterium == false )

        iter = iter + 1;
        rr = p_lookup( rr_table, n_table, g, min_g, max_g, centroid );
        old_vv = vv;
        vv = dw( rr, dt );
        aa = dw( vv, dt );

        [ der, ~, ~, ~] = rhs( ru, rr, vu, vv, au, aa );

        dg_prop = - grad_factor * der;

        % Limit dg so dg_prop is maximal 0.24 of the minimal difference
        % between the points, this is similar but not the same as scaling
        % the step-size. (0.24 = REPARAMETERIZATION_NORMALIZATION_FACTOR)
        % We have three strategies for this (not sure whether the ..JOZSEF
        % strategy works.
        normalization_factor = C.REPARAMETERIZATION_NORMALIZATION_FACTOR;
        switch normalization_method
            case C.REPARAMETERIZATION_NORMALIZATION_LOCAL
                g_diff = d_periodic( g, 1.0, min_g, max_g );
                min_combination = min( ( abs(g_diff(1:end)) - min_resolution ) ./ abs( dg_prop(1:end) ) );
                dg_normalization = normalization_factor * min_combination;
            case C.REPARAMETERIZATION_NORMALIZATION_GLOBAL
                g_diff = d_periodic( g, 1.0, min_g, max_g );
                dg_normalization = normalization_factor * min( abs(g_diff) ) / max( abs( dg_prop ) );
            case C.REPARAMETERIZATION_NORMALIZATION_JOZSEF
                dg_normalization = normalization_factor / max( abs( dg_prop ) );
            otherwise
                error('unknown normalization strategy');
        end
        dg_prop = min( dg_normalization, max_enlarge_step_ratio ) * dg_prop;

        g_prop = g + dg_prop;

        % Smoothing term (Jozsef) between [ 0, 2] 0 means no smoothing, 1
        % means smoothing as a Gaussian approx, 2 means the points are
        % taken as the average of the neighboring points. "Smart smoothing"
        % is used: only smooths during iterations where there are at least
        %  points too close to eachother or n_high points too far
        norm_vv = normv(vv);
        norm_vv = norm_vv / mean( norm_vv );
        n_low = sum( norm_vv < 0.25 );
        n_high = sum( norm_vv > 4 );
        if ( local_smoothing > 0 ) && ( ( n_low + n_high ) > 1 ) %min_ratio_close_or_far_points * n_points )
            w = local_smoothing;
            g_prop = diff_smooth_gamma( g_prop, w, min_g, max_g );
        end

        % Make the new gamma ( = g) equal to the proposed gamma (= g_prop)
        g = g_prop;

        % Calculate the energy
        qq = sqrt( normv(vv) ) .* rr;
        ens( iter + 1 ) = sum( normv( q - qq ).^2 );
        den = abs( ens( iter + 1 ) - ens( iter ) );
        dcurvature = mean( abs( normv(vv) - norm(old_vv) ) );
        
        % The stopping criterium other than the maximum iterations
        if dcurvature < precision
            stop_criterium = true;
        end
        
    end
end

