function [ g_list, debug ] = meanshape_single_iter_centroid( ru_list, g_list, r_tables, centroid, options )

    C = Constants;
    dt = 1;
    t = g_list{1};
    n_curves = length( ru_list );
    n_table = options.curve_n_table;
    min_t = 0;
    max_t = 1;
    % position, velocity and acceleration of the reference curve (first curve)
    ru = ru_list{1} - centroid;
    vu = dw( ru, dt );
    au = dw( vu, dt );
    r_curves{1} = ru;
    q_curves{1} = sqrt( normv(vu) ) .* ru;

    reparam_n_iter = options.reparametrization_n_iter;
    reparam_step_size = options.reparametrization_step_size;
    reparam_precision = options.reparametrization_precision;
    reparam_local_smoothing = options.reparametrization_smoothing;
    reparam_normalization_method = options.reparametrization_normalization_method;

    start_time = toc;
    
    for i_curve = 2:n_curves

        g_init = g_list{i_curve};
        [g, ens ] = reparametrization_discrete( reparam_n_iter, g_init, reparam_step_size, reparam_precision, reparam_local_smoothing, reparam_normalization_method, min_t, max_t, ru, vu, au, r_tables{i_curve}, centroid );
        %[g, ens ] = reparametrization_discrete_fast( options.reparametrization_n_iter, g_init, step_size, local_smoothing, min_dg, max_a, slope_ratio, reg_g, slope_ratio_reg_g, min_t, max_t, ru, vu, au, r_tables{i_curve} );
        g_list{ i_curve } = g;
        en_curves = ens;

        %[g, gs, prefactors, ens, g_props] = reparametrization_discrete( t, options.reparametrization_n_iter, t, options.reparametrization_step_size, options.reparametrization_beta, min_dg, options.reparametrization_gamma, min_t, max_t, ru, vu, au, r_tables{i_curve} );
        %g_list{i_curve} = g;
        %gs_list{end+1} = gs;

    end

    end_time = toc;
    processed_time = end_time - start_time;
    debug.processing_times.reparameterization =+ processed_time;
    processed_time_str = sprintf( 'Processed time reparameterization: %f', processed_time );
    disp(processed_time_str);

    %%% -------------------------------------------------------------------
    %% Average in the representation space (q-space)
    %%% -------------------------------------------------------------------

    start_time = toc;
    
    q = sqrt( normv(vu) ) .* ru;
    for i_weight = 1:options.n_interpolation

        weights = options.average_weights{i_weight};
        q_curves{1} = q;
        q_avg = weights(1) .* q;

        for i_curve = 2:n_curves
            rr = p_lookup( r_tables{i_curve}, n_table, g_list{ i_curve }, 0, 1, centroid );
            vv = dw( rr, dt );
            qq = sqrt( normv(vv) ) .* rr;
            q_avg = q_avg +  weights(i_curve) .* qq;
            r_curves{i_curve} = rr;
            q_curves{i_curve} = qq;
        end

        q_avg = q_avg / sum( weights );
        q_inter{i_weight} = q_avg;

        %%% ----------------------------------------------------------------------- 
        %% Reconstruction
        %%% ----------------------------------------------------------------------- 

        % Reconstruction of the average to the contour space (r-space)
        %   first make initial guess for average curve
        r_init = weights(1) .* ru;
        for i_curve = 2:n_curves
            rr = p_lookup( r_tables{i_curve}, n_table, g_list{ i_curve }, 0, 1, centroid );
            r_init = r_init +  weights(i_curve) .* rr;
        end
        r_init = r_init / sum( weights );
        %

        switch options.reconstruction_method
            case C.METHOD_RECONSTRUCTION_GRAD
                [ r_avg, rs_avg, mean_step_sizes ] = q2r( r_init, q_inter{i_weight}, g_list{1}, options.reconstruction_step_size, options.reconstruction_reg_b, options.reconstruction_n_iter );
            case C.METHOD_RECONSTRUCTION_ITERATIVE_VECTOR
                [ r_avg, rs_avg, mean_step_sizes, ~ ] = q2r_iter_vec( r_init, q_inter{i_weight}, options.reconstruction_step_size, options.reconstruction_n_iter );
            case C.METHOD_RECONSTRUCTION_ITERATIVE
                [ r_avg, rs_avg, mean_step_sizes ] = q2r_iter_abs( r_init, q_inter{i_weight}, g_list{1}, options.reconstruction_step_size, options.reconstruction_reg_b, options.reconstruction_n_iter, options.reconstruction_precision );
            case C.METHOD_RECONSTRUCTION_NEWTON
                [ r_avg, rs_avg, mean_step_sizes ] = q2r_newton( r_init, q_inter{i_weight}, options.reconstruction_n_iter, options.reconstruction_step_size, options.reconstruction_precision );
        end

        r_inter{i_weight} = r_avg;
        r_inits{i_weight} = r_init;
        rs_inter{i_weight} = rs_avg;
        mean_step_sizes_list = mean_step_sizes;

    end
    
    end_time = toc;
    processed_time = end_time - start_time;
    debug.processing_times.reconstruction =+ processed_time;
    processed_time_str = sprintf( 'Processed time reconstruction: %f', processed_time );
    disp(processed_time_str);    
    
    i_average = ceil( options.n_interpolation / 2 );
    curves_interpolation = r_inter;
    %debug.processing_times = processing_times;
    debug.q_curves = q_curves;
    debug.r_curves = r_curves;
    debug.g_list = g_list;
    %debug.gs_list = gs_list;
    debug.q_avg = q_avg;
    debug.r_init = r_init;
    debug.r_avg = r_inter{ i_average };
    debug.r_inter = r_inter;
    debug.rs_avg = rs_avg;
    debug.averaging_steps = mean_step_sizes;
    
end

