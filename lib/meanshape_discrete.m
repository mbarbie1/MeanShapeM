function [ curves_interpolation, debug ] = meanshape_discrete( curve_list, options, h_fig )
% -------------------------------------------------------------------------
% MEANSHAPE Computes the average curve of multiple curves.
% -------------------------------------------------------------------------
%   This function computes the average curve of multiple curves where the
%   input curves and the output curves are given by poly-lines. The average
%   is computed according to the algorithm of Jozsef Molnar [1].
%
%   [1] Preprint: arXiv ...
%
%   INPUT
%
%       curve_list                           : cell of curves (2 x X_points)
%
%       options:
%           .curve.type                      : ['discrete', 'spline']
%           .curve.smoothness                : 0 < scalar < 1
%           .curve.n_points                  : integer >> 2
%           .reparametrization.step_size     : scalar > 0
%           .reparametrization.n_iter        : integer >> 0
%           .reparametrization.beta          : scalar >= 0
%           .reconstruction.step_size        : scalar > 0
%           .reconstruction.n_iter           : integer >> 0
%
%   OUTPUT
%
%       avg_curve                            : (2 x n_points)
%
%       debug:
%           .reparametrization.gamma         : (n_points)
%           .reparametrization.gammas        : (n_points)
%
%   Author:             Michael Barbier
%   Creation Date:      November 29, 2018
%
%   Version: v1 (November 29, 2018)
% -------------------------------------------------------------------------

    % Constants
    C = Constants;

    % check whether a figure handle is provide to plot the updated points
    % and connections plus centroid positions
    do_update_plot = true;
    if nargin < 3 || isempty( h_fig )
        do_update_plot = false;
    end
    
    n_curves = length( curve_list );
    n_points = options.curve_n_points;
    n_table_sub = options.curve_n_table_sub;
    n_table = options.curve_n_table;

    step_size = options.reparametrization_step_size;
    local_smoothing = options.reparametrization_smoothing;
    min_dg = options.reparametrization_radius;
    max_a = options.reparametrization_max_a;
    slope_ratio = options.reparametrization_distance_force_radius_slope;
    reg_g = options.reparametrization_distance_force_strength;
    slope_ratio_reg_g = options.reparametrization_distance_force_strength_slope;
    n_b_iter = options.centroid_n_iter;
    
    % Define empty initial output variables
    debug = struct;
    debug.input_options = options;
    curves_interpolation = {};

    min_t = 0;
    max_t = 1;
    dt = 1.0;
    u_list = {};
    t = linspace( min_t, max_t, n_points+1);
    u_list{1} = linspace( min_t, max_t, n_points+1 );
    u_list{1} = u_list{1}(1:(end-1));
    max_u_list = ones( n_curves, 1 );
    g_list = {};
    gs_list = {};
    g_list{1} = t;
    en_curves = {};
    q_inter = {};
    q_inter = {};
    processed_time = {};
    processing_times = struct();
    r_curves = {};
    q_curves = {};
    r_reparam_curves = {};
    centroid_list = {};
    centroid_inter_list = {};

    %%% -----------------------------------------------------------------------
    %% Initialize centroid
    %%% ----------------------------------------------------------------------- 
    [S_sum, L_sum] = sum_centroids( curve_list );
    R0 = S_sum / L_sum;
    centroid_list{1} = R0;

    %%% ----------------------------------------------------------------------- 
    %% Tables of the curve data
    % Convert the curve data to smooth (2 x n_points) curves and make
    % lookup tables to extract the positions. (parametrization of
    % the curves), also create the initial parametrizations
    %%% -----------------------------------------------------------------------
    start_time = toc;
    r_tables = {};
    for i_curve = 1:n_curves
        tt = linspace(0, 1, n_table_sub+1);
        p_val = curve_list{i_curve};
        ru = interparc( tt, p_val(1,:), p_val(2,:) )';
        ru = ru(:, 1:(end-1));
        %m_points = n_table / n_table_sub;
        r_tables{i_curve} = table_approx( ru, n_table_sub, n_points );
        t = linspace( min_t, max_t, n_points+1 );
        t = t(1:end-1);
        p = p_lookup( r_tables{i_curve}, n_table, t, min_t, max_t, 0.0 );%centroid_list{1}
        u_list{i_curve} = t;
        g_list{i_curve} = u_list{i_curve} / max_u_list(i_curve);
        ru_list{i_curve} = p;
    end
    end_time = toc;
    processed_time = end_time - start_time;
    processing_times_table_generation = processed_time;
    processed_time_str = sprintf( 'Processed time table generations: %f', processed_time );
    disp(processed_time_str);

    
    %%% -----------------------------------------------------------------------
    %% Reparameterization
    %%% ----------------------------------------------------------------------- 
    b_iter = 0;
    stop_criterion = false;
    while (b_iter < n_b_iter) && (stop_criterion == false)

        b_iter = b_iter + 1;

        centroid = centroid_list{b_iter};
        [ g_list, debug ] = meanshape_single_iter_centroid( ru_list, g_list, r_tables, centroid, options );
        curves_interpolation = debug.r_inter;

        r_list = debug.r_curves;
        v_list = {};
        for i_curve = 1:length(r_list)
            v_list{i_curve} = dw( r_list{i_curve}, dt );
        end
        r_avg = debug.r_avg;
        v_avg = dw( r_avg, dt );

        if do_update_plot
            
            do_plot_connections = 1;
            plot_ratio = 0.1;
            plot_title = 'Contour R curve, average and centroid';

            r_plot_list = {};
            for i_curve = 1:length(r_list)
                r_plot_list{i_curve} = r_list{i_curve} + centroid_list{end};
            end
            r_plot_avg = r_avg + centroid_list{end};
            plot_curves_average_update( r_plot_list, r_plot_avg, centroid_list, do_plot_connections, plot_ratio, plot_title, h_fig );
        end
            
        % Compute centroid displacement
        b = get_b( r_list, v_list, r_avg, v_avg, t );
        
        % Check whether difference is small enough to stop, if final
        % iteration readd the centroid displacement
        if ( options.centroid_step_size * b < options.centroid_precision )
            stop_criterion = true;
            for j = 1:length(curves_interpolation)
                curves_interpolation{j} = curves_interpolation{j} + centroid_list{end};
            end
        end

        % New centroid position
        centroid_list{b_iter+1} = centroid_list{b_iter} + options.centroid_step_size * b;

    end
    debug.centroid_list = centroid_list;
    debug.processing_times.table_generation = processing_times_table_generation;
    debug.processing_times.centroid_iterations = length(centroid_list);
    
end

