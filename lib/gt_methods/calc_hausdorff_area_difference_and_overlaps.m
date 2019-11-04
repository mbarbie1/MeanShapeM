%%function calc_hausdorff_area_difference_and_overlaps( gt_folder, mask_folder, output_folder, sub_folder, do_save, smooth_factor_mask, n_points, prefix )
% Calculation of various metrics to compare the difference between masks
% and the resulting ground truth estimation mask

%   do_save
%               .fig_methods
%               .fig_mask
%               .poly
%               .gt_mask
%               .gt_poly
%   sub_folder
%               .fig_methods
%               .fig_mask
%               .poly
%               .gt_mask
%               .gt_poly
%
% --> e.g. fig_methods_folder = fullfile( output_folder, sub_folder.fig_methods )

%%% Clean and start the clock
close all;
clear all;
tic;

%%% Add lib path
addpath(genpath('../../lib') );
addpath(genpath('../../lib_external') );
addpath(genpath('../../../other_implementation/agreement'));

gt_folder = 'D:\STSM\contour_average\data\bleb_data_marlies\output\gt_mask';
mask_folder = 'D:\STSM\contour_average\data\bleb_data_marlies\mask';
output_folder = 'D:\STSM\contour_average\data\bleb_data_marlies\output';
smooth_factor = 0.9;
n_points = 1000;
prefix = 'error_table';
name_pattern = 'NCP-*';
%methods = { 'staple', '05', 'excl_05', 'lsml', 'simple', 'meanshape_mask' };
methods = { 'staple', '05', 'excl_05', 'lsml', 'simple', 'meanshape_mask' };

    % find all unique IDs
    files = dir( fullfile( mask_folder, name_pattern ) );
    n_masks = length( files );
    colTypes = {'string','string','uint32','uint32','string','string'};
    colNames = {'image_id','cell_id','cell_nr','annotator_id','file_name','file_path'};
    sz = [n_masks length(colTypes)];
    mask_table = table('Size',sz,'VariableTypes',colTypes,'VariableNames',colNames);

    for i = 1:n_masks
        file_name = files(i).name;
        file_path = fullfile( files(i).folder, file_name );
        s = regexp( file_name, '^(?<id>NCP-\d+)_(?<cell_id>\d+)_(?<mask_id>\d+)_.*', 'names' );
        mask_table(i,:) = { s.id, [s.id '_' s.cell_id], str2double(s.cell_id), str2double(s.mask_id), file_name, file_path };
    end
    
    [C,IA,IC] = unique(mask_table.cell_id);
    id_list = mask_table( IA, 'cell_id' );
    n_cell = height(id_list);
    
    mask_size = size( imread( fullfile( mask_folder, files(1).name ) ) );

    colTypes = {'string','string','string','string','double','double'};
    colNames = {'cell_id','method','error_type','values','mean','sd'};
    n_methods = length(methods);
    n_error_types = 5;
    sz = [n_cell*n_methods*n_error_types length(colTypes)];
    error_table = table('Size',sz,'VariableTypes',colTypes,'VariableNames',colNames);

    for i = 1:n_cell
        % compute the overlap of the different gt_masks
        cell_id = id_list{i,'cell_id'};
        % read in the mask files
        rows = mask_table.cell_id == cell_id;
        subtable = mask_table(rows,:);
        n_masks = height(subtable);
        annotations = zeros( mask_size(1), mask_size(2), n_masks );
        for k = 1:n_masks
            mask = imread( subtable{ k, 'file_path' } );
            annotations(:,:,k) = mask;
            [p_val, tt, pp, p] = mask_to_roi( mask, smooth_factor, n_points );
            P{k} = p_val';
        end
        % loop over the different gt_masks
        for j = 1:n_methods
            table_index = (i-1)*n_methods*n_error_types + (j-1)*n_error_types;
            method = methods{j};
            file_name = [char(cell_id) '_mask_' method '.png'];
            file_method = fullfile( gt_folder, file_name );
            mask = imread( file_method );
            [p_val, tt, pp, p] = mask_to_roi( mask, smooth_factor, n_points );
            Q = p_val';
            hds = zeros(n_masks,1);
            ahds = zeros(n_masks,1);
            os = zeros(n_masks,1);
            osj = zeros(n_masks,1);
            for k = 1:n_masks
                %[percentages] = agreement_percentage(annotations);
                [hd ahd ~] = HausdorffDist(P{k},Q);
                hds(k) = hd;
                ahds(k) = ahd;
                os(k) = overlap( mask, annotations(:,:,k));
                osj(k) = overlap_jaccard( mask, annotations(:,:,k));
            end
            error_table( table_index+1, :) = { cell_id, method, 'avg_hausdorff', sprintf('%d, ', ahds), mean(ahds), std(ahds)};
            error_table( table_index+2, :) = { cell_id, method, 'max_hausdorff', sprintf('%d, ', hds), mean(hds), std(hds)};
            error_table( table_index+3, :) = { cell_id, method, 'dice_overlap', sprintf('%d, ', os), mean(os), std(os)};
            error_table( table_index+4, :) = { cell_id, method, 'jaccard_overlap', sprintf('%d, ', osj), mean(osj), std(osj)};
            error_table( table_index+5, :) = { cell_id, method, 'jaccard_error', sprintf('%d, ', 1-osj), mean(1-osj), std(1-osj)};
        end
    end
    
    writetable( error_table, fullfile( output_folder, 'error_table.csv' ) );

