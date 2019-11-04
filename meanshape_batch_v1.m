% ------------------------------------------------------------------------
% MEANSHAPE MAIN SCRIPT FOR BATCH ANALYSIS
% ------------------------------------------------------------------------
% This script is meant as main file (without gui) for the meanshape
% algorithm. The meanshape algorithm computes an average curve from
% multiple curves. this main file calls the meanshape function with
% parameters, the meanshape function starts from the poly-lines the curves
% and outputs the average curve as a poly-line. This script allows either
% masks or generated curves as input to the meanshape function. 
%
% This is the batch processing script for testing multiple curve sets.
%
% ------------------------------------------------------------------------

%% Clean
close all;
clear all;
tic;

%% Add lib path
addpath(genpath('D:/STSM/contour_average/other_implementation/agreement'));
addpath(genpath('./lib') );
addpath(genpath('../lib_external') );

%% Read the data

options_file_path = 'D:/STSM/contour_average/meanshapem/tests/input/options.json';
%base_input_folder = 'D:/STSM/contour_average/data/B38/mask';
%output_folder = 'D:/STSM/contour_average/meanshapem/contour_algo/output/batch_1';
%output_process_folder = 'D:/STSM/contour_average/meanshapem/contour_algo/output/batch_1/processed';
%image_table = get_name_sets( base_input_folder, 'png', 'repeat' );
base_input_folder = 'D:/STSM/contour_average/data/bleb_data_marlies/mask';
output_folder = 'D:/STSM/contour_average/meanshapem/contour_algo/output/blebbed';
output_process_folder = 'D:/STSM/contour_average/meanshapem/contour_algo/output/blebbed/processed';
image_table = get_name_sets( base_input_folder, 'png', 'annotator' );

image_ids = unique( image_table.image_id );
region_ids = unique( image_table.region_id );
annotator_ids = unique( image_table.annotator_id );
repeat_ids = unique( image_table.repeat_id );
image_info_list = struct([]);
n_image_id = length( image_ids );
n_region_id = length( region_ids );
n_annotator_id = length( annotator_ids );

name_patterns = unique( image_table.name_pattern );
output_prefixes = unique( image_table.name_prefix );
n_sets = length( name_patterns );


%% Constants
C = Constants;


%% Parameters
options = struct;

options.input_type = 'png';
options.output_type = options.input_type;
options.plot_fmt = 'png';
options.table_fmt = 'csv';

options.curve_type = C.METHOD_REPARAMETERIZATION_DISCRETE;
options.curve_n_points = 2000;
options.curve_n_table_sub = 10000;
options.curve_n_table = options.curve_n_table_sub * options.curve_n_points;

options.reparametrization_n_iter_max = 100000;
options.reparametrization_precision = 0.00001;
options.reparametrization_n_iter_per_point = 100;
options.reparametrization_n_iter = max( options.reparametrization_n_iter_per_point * options.curve_n_points, options.reparametrization_n_iter_max );
options.reparametrization_step_size = 0.01 / options.curve_n_points;
options.reparametrization_smoothing = 1;
options.reparametrization_radius = 0.1;
options.reparametrization_max_a = 1;
options.reparametrization_distance_force_radius_slope = 0;
options.reparametrization_distance_force_strength = 0;
options.reparametrization_distance_force_strength_slope = 0;
options.reparametrization_normalization_method = C.REPARAMETERIZATION_NORMALIZATION_LOCAL;

options.reconstruction_method = C.METHOD_RECONSTRUCTION_ITERATIVE;
options.reconstruction_n_iter_per_point = 10;
options.reconstruction_n_iter = options.reconstruction_n_iter_per_point * options.curve_n_points;
options.reconstruction_step_size = 0.1 / options.curve_n_points;
options.reconstruction_precision = 0.0001 * options.reconstruction_step_size;
options.reconstruction_reg_b = 0.0;

options.average_weights = {};
options.average_is_weighted = false;
if ~options.average_is_weighted
    options.n_interpolation = 1;
else
    options.n_interpolation = length( options.average_weights );
end
options.centroid_step_size = 0.5;
options.centroid_precision = 0.5;
options.centroid_n_iter = 20;

%options = load_options( options_file_path );
plot_list = {...
    'average_curve_r',...
    'average_curve_r_lines',...
    'average_curve_r_color',...
    'average_curve_q',...
    'average_curve_q_lines',...
    'reparameterization_gamma',...
    'reparameterization_energies',...
    'reconstruction_step_sizes',...
    'reconstruction_r_curves',...
    'reconstruction_r_init'...
};

% f = figure();
% ax = axes('Parent',f);
% curve_plot_list = {};
% avg_list = {};
% scatter_plot_list = {};
% 
% objarray = gobjects(1,5);
% objarray(1) = figure();
% objarray(2) = ax;
% objarray(3) = [];
% objarray(4) = [];
% objarray(5) = [];
% objarray


for i_set = 90:90%n_sets

    % prepare inputs
    input_folder = base_input_folder;
    name_pattern = name_patterns{ i_set };
    prefix = output_prefixes{ i_set };
    input_list = list_files( input_folder, name_pattern );

%    try
        disp('--------------------------------------------------------------');
        str = sprintf( 'Start processing files %s, contour set %i / %i', name_pattern, i_set, n_sets );
        disp( str );
        start_time = toc;

        % Actual algorithm
        [ curve_interpolation, debug ] = meanshape( input_list, options );

        end_time = toc;
        processed_time = end_time - start_time;
        debug.processing_times.sample = processed_time;
        processed_time_str = sprintf( 'Processed time files %s: %f', name_pattern, processed_time );
        disp(processed_time_str);
        disp('--------------------------------------------------------------');
        debug.processing.status = 'succes';
%     catch
%         warning_str = sprintf( 'Failed processing %s', name_pattern );
%         disp( warning_str );
%         debug = struct;
%         debug.processing.status = 'failed';
%     end

    % Save the outcome curves
    save_output_curves( curve_interpolation, debug.image_size, prefix, output_folder, options.output_type );
    
    % Generate plot output
    try
        plot_str = [ prefix '_' 'contour_average'];
        name = [ plot_str '.' options.plot_fmt ];
        file_path = fullfile( output_process_folder, name );
        saveas( debug.plot, file_path, options.plot_fmt );
    catch
        warning('No plot could be generated generated');
    end

    % Generate log file with options and processing times
    try
        table_str = [ 'processing_' prefix ];
        name = [ table_str '.' options.table_fmt ];
        file_path = fullfile( output_process_folder, name );
        generate_log_file( output_process_folder, name, debug.processing, debug.processing_times, options );
    catch
        warning('No log-file could be generated generated');
    end

%     % Generate outputs
%     figs = plot_results( debug, plot_list );
%     %show_results( figs );
%     output_folder_debug = fullfile(output_folder, 'debug');
%     if ~exist( output_folder_debug , 'dir')
%         mkdir( output_folder_debug );
%     end
%     save_plots( figs, prefix, plot_list, output_folder_debug, 'png' );
%     save_as_mask( avg_curve, image_size, prefix, output_folder, 'png' );
%     %save_results( debug, data_list );

end
