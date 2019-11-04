% ------------------------------------------------------------------------
% MEANSHAPE TEST SCRIPT
% ------------------------------------------------------------------------
% This script is the test of the reparametrization algorithm.
%
% ------------------------------------------------------------------------

%% Clean and start the clock
close all;
clear all;
tic;

%% Add lib path
addpath(genpath('./lib') );
addpath(genpath('../lib_external') );

%% Read the data
%file_curve_1 = 'D:/STSM/contour_average/data/test_data/runman_1.csv';
%file_curve_2 = 'D:/STSM/contour_average/data/test_data/runman_2.csv';
%file_curve_1 = 'D:/STSM/contour_average/data/test_data/ellipses/polyline/poly_2.csv';
%file_curve_2 = 'D:/STSM/contour_average/data/test_data/ellipses/polyline/poly_1.csv';
%file_curve_1 = 'D:/STSM/contour_average/data/test_data/ellipses_2/polyline/poly_2.csv';
%file_curve_2 = 'D:/STSM/contour_average/data/test_data/ellipses_2/polyline/poly_1.csv';
%file_curve_1 = 'D:/STSM/contour_average/data/test_data/test_data_stickmen/polyline/poly_runner_starting_point_2.csv';
%file_curve_2 = 'D:/STSM/contour_average/data/test_data/test_data_stickmen/polyline/poly_runner_starting_point_1.csv';
file_curve_1 = 'D:/STSM/contour_average/data/test_data/deep_cut_simulation/poly_2.csv';
file_curve_2 = 'D:/STSM/contour_average/data/test_data/deep_cut_simulation/poly_1.csv';
%file_curve_1 = 'D:/STSM/contour_average/data/test_data/deep_cut_starting_point/polyline/poly_2.csv';
%file_curve_2 = 'D:/STSM/contour_average/data/test_data/deep_cut_starting_point/polyline/poly_1.csv';
curve_files = { file_curve_1, file_curve_2 };
output_folder = 'D:/STSM/contour_average/meanshapem/contour_algo/output';

%% Constants
C = Constants;

%% Parameters

%%% General parameters
%%% ----------------------------------------------------------------------- 
options = struct;
options.curve_type = C.METHOD_REPARAMETERIZATION_DISCRETE;
options.curve_n_points = 300;
options.curve_n_table_sub = 10000;
options.curve_n_table = options.curve_n_table_sub * options.curve_n_points;

options.reparametrization_n_iter_max = 100000;
options.reparametrization_precision = 0.00001;
options.reparametrization_n_iter_per_point = 100;
options.reparametrization_n_iter = max( options.reparametrization_n_iter_per_point * options.curve_n_points, options.reparametrization_n_iter_max );
options.reparametrization_step_size = 0.1 / options.curve_n_points;
options.reparametrization_smoothing = 1;
options.reparametrization_radius = 0.1;
options.reparametrization_max_a = 1;
options.reparametrization_distance_force_radius_slope = 0;
options.reparametrization_distance_force_strength = 0;
options.reparametrization_distance_force_strength_slope = 0;
options.reparametrization_normalization_method = C.REPARAMETERIZATION_NORMALIZATION_LOCAL;

options.reconstruction_method = C.METHOD_RECONSTRUCTION_ITERATIVE_VECTOR;
%C.METHOD_RECONSTRUCTION_NEWTON;
%C.METHOD_RECONSTRUCTION_ITERATIVE;
options.reconstruction_n_iter_per_point = 10;
options.reconstruction_n_iter = options.reconstruction_n_iter_per_point * options.curve_n_points;
options.reconstruction_step_size = 1 / options.curve_n_points;
options.reconstruction_precision = 0.001 * options.reconstruction_step_size;
options.reconstruction_reg_b = 0.0;

%options.average_weights = { [0.75,0.25],[0.5,0.5],[0.25,0.75] };
n_weights = 5;
options.average_weights = {};
weights = linspace(0,1,n_weights);
for i_weight = 1:n_weights
    options.average_weights{i_weight} = [ weights(i_weight), 1-weights(i_weight)];
end
options.average_is_weighted = true;
options.n_interpolation = length( options.average_weights );

options.centroid_step_size = 0.5;
options.centroid_precision = 1;
options.centroid_n_iter = 20;

plot_list = {...
    'interpolation_curve_r',...
    'interpolation_curve_r_lines',...
    'average_curve_r',...
    'average_curve_r_lines',...
    'average_curve_r_color',... 
    'average_curve_q',...
    'average_curve_q_lines',...
    'reparameterization_gamma',...
    'reconstruction_step_sizes',...
    'reconstruction_r_curves',...
    'reconstruction_r_init'...
};
%    'reparameterization_gammas',...
%    'reparameterization_energies',...


%%% -----------------------------------------------------------------------
%% Load the curves?
%%% -----------------------------------------------------------------------
% 

%%% ----------------------------------------------------------------------- 
%% Reparameterization & Reconstruction
%%% ----------------------------------------------------------------------- 

% Test with the files as a list of 
input_list = curve_files;
[ curves_interpolation, debug ] = meanshape( input_list, options );

%%% ----------------------------------------------------------------------- 
%% Visualization
%%% ----------------------------------------------------------------------- 

% i1 = 2;
% i2 = 1;
% visible = 'on';
% fig = plot_curves_average( debug.r_curves, debug.r_init, 1, 1, 'Inits', visible );
% hold on;
% rr = debug.r_avg;
% plot( rr(i1,:),-rr(i2,:),'LineWidth',1);
% axis equal;
% 
% fig = plot_curves_average( debug.q_curves, debug.q_avg, 1, 1, 'Inits', visible );
% 

% % Generate outputs
% prefix = 'test1'; 
% figs = plot_results( debug, plot_list );
% output_folder_debug = fullfile(output_folder, 'debug');
% if ~exist( output_folder_debug , 'dir')
%     mkdir( output_folder_debug );
% end
% save_plots( figs, prefix, plot_list, output_folder_debug, 'png' );
% %save_as_mask( curves_interpolation{2}, image_size, prefix, output_folder, 'png' );
% %save_results( debug, data_list );
