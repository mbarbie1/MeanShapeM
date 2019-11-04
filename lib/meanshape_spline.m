function [ avg_curve, debug ] = meanshape_spline( r_splines, ru_list, u_list, max_u_list, options )
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
%       r_splines                            : cell of splines (pp-form)
%       ru_list                              : cell of curves (2 x n_points)
%       u_list                               : cell of t (n_points)
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
%           .reparametrization.gammas        : (n_points x reparametrization.n_iter)
%
%   Author:             Michael Barbier
%   Creation Date:      November 29, 2018
%
%   Version: v1 (November 29, 2018)
% -------------------------------------------------------------------------

    n_curves = length(r_splines);
    n_points = options.curve_n_points;
    n_table_sub = options.curve_n_table_sub;
    n_table = options.curve_n_table;

    % Define empty initial output variables
    debug = struct;
    debug.input_options = options;
    avg_curve = [];

    g_list = {};
    gs_list = {};
    g_list{1} = u_list{1};
    r_curves = {};
    q_curves = {};

    %%
    
    % Reparametrization of all curves except the first (reference curve)
    ru = ru_list{1};
    r_curves{1} = ru;
    dt = 1.0;
    min_dg = options.reparametrization_min_point_distance;
    vu = dw( ru, dt );
    au = dw( vu, dt );
    for i_curve = 2:n_curves
        uu = u_list{i_curve};
        min_t = 0;
        max_t = max_u_list(i_curve);
        [g, gs, prefactors, ens, g_props] = reparametrization( uu, options.reparametrization_n_iter, uu, options.reparametrization_step_size, options.reparametrization_beta, options.reparametrization_min_point_distance, options.reparametrization_gamma, min_t, max_t, ru, vu, au, r_splines{i_curve} );
        g_list{i_curve} = g;
        gs_list{end+1} = gs;
    end

    % Average in the representation space (q-space)
    q = sqrt( normv(vu) ) .* ru;
    q_curves{1} = q;
    q_avg = options.average_weights(1) .* q;
    for i_curve = 2:n_curves
        rr = ppval( r_splines{i_curve}, g_list{i_curve} );
        vv = dw( rr, dt );
        qq = sqrt( normv(vv) ) .* rr;
        q_avg = q_avg +  options.average_weights(i_curve) .* qq;
        r_curves{i_curve} = rr;
        q_curves{i_curve} = qq;
    end
    q_avg = q_avg / sum( options.average_weights );

    % Reconstruction of the average to the contour space (r-space)
    %   first make initial guess for average curve
    r_init = options.average_weights(1) .* ru;
    for i_curve = 2:n_curves
        rr = ppval( r_splines{i_curve}, g_list{i_curve} );
        r_init = r_init +  options.average_weights(i_curve) .* rr;
    end
    r_init = r_init / sum( options.average_weights );
    %
    [ r_avg, rs_avg, mean_step_sizes ] = q2r_iter_abs( r_init, q_avg, u_list{1}, options.reconstruction_step_size, 0.0, options.reconstruction_n_iter, options.reconstruction_precision );
    % [ r_avg, rs_avg, mean_step_sizes ] = q2r_newton( r_init, q_avg, options.reconstruction_n_iter, options.reconstruction_step_size, options.reconstruction_precision );

    debug.q_curves = q_curves;
    debug.r_curves = r_curves;
    debug.g_list = g_list;
    debug.gs_list = gs_list;
    debug.q_avg = q_avg;
    debug.r_init = r_init;
    debug.r_avg = r_avg;
    debug.rs_avg = rs_avg;
    debug.averaging_steps = mean_step_sizes;
    debug.reparameterization_energies = ens;
    avg_curve = r_avg;

end

