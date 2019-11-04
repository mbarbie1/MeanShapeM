function [ curves_interpolation, debug ] = meanshape( input_list, options )
% -------------------------------------------------------------------------
% MEANSHAPE Computes the average curve of multiple curves.
% -------------------------------------------------------------------------
%   This function computes the average curve of multiple curves where the
%   input curves are given by poly-lines and the output curves are given by 
%   poly-lines. The average is computed according to the algorithm of 
%   Jozsef Molnar [1].
%
%   [1] Preprint: arXiv ...
%
%   INPUT
%
%       curve_list                           : cell of curves (2 x
%                                               X_points),or paths to masks
%                                               or curves
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
%   Version: v2 (March 4, 2019)
% -------------------------------------------------------------------------

    % Constants
    C = Constants;

    % Default options
    default = get_default();

    % Check input variables
    if nargin < 2 || isempty( options )
        options_original = [];
        options = default;
    else
        options_original = options;
        options = update_struct( default, options );
    end

    n_points = options.curve_n_points;
    smooth_factor = options.curve_smoothness;
    n_table_sub = options.curve_n_table_sub;
    %options.reconstruction_reg_b = 0.0;
    %options.average_weights = linspace(0,1,options.average_n_weights);
    n_table = options.curve_n_table;

    % Define empty initial output variables
    debug = struct;
    debug.input_options_given = options_original;
    debug.input_options = options;
    curves_interpolation = {};

    % If there is no input curves return
    if isempty(input_list)
        warning('No input masks/curves found, return empty average curve');
        return
    end
    
    % Number of inputs (should equal the amount of curves: n_curves)
    n_curves = length( input_list );

    % Convert the inputs to curves with n_points
    [ curve_list, image_size ] = input_to_curves( input_list, n_points, smooth_factor );

    % If there is only one curve as input, it is also the average curve.
    if n_curves < 2
        warning('Only one input curve, returning its smoothed with n_points version as the average curve');
        curves_interpolation{1} = curve_list{1};
        return
    end

    % If the curves should be weighted, generate the default weights if not
    % provided
    if ~options.average_is_weighted
        options.average_weights = { ones(n_curves,1) };
    end

    switch( options.curve_type )

        case C.METHOD_REPARAMETERIZATION_DISCRETE

            fig_h = figure();
            axes_h = axes('Parent',fig_h);
            [ curves_interpolation, debug ] = meanshape_discrete( curve_list, options, fig_h );
            debug.plot = fig_h;

        otherwise
            error('No valid method for the curve positions defined: exiting, options.curve.type = [discrete, spline]');
    end
    debug.input_options_given = options_original;
    debug.image_size = image_size;
    
end
