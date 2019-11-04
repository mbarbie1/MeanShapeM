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

gt_folder = 'D:\STSM\contour_average\data\winnok\roi';
mask_folder = 'D:\STSM\contour_average\data\winnok';
output_folder = 'D:\STSM\contour_average\data\winnok\output';
smooth_factor = 0.9;
n_points = 1000;
prefix = 'error_table_meanshape';
name_pattern = '*.csv';
methods = { 'meanshape' };

    % find all unique IDs
    image_files = dir( fullfile( mask_folder, '*.tif' ) );
    roi_files = dir( fullfile( gt_folder, name_pattern ) );
    n_images = length( image_files );
    n_masks = length( roi_files );
    colTypes = {'string','string','uint32','uint32','string','string','string'};
    colNames = {'image_id','mask_id','cell_nr','time_id','file_name','file_path','file_path_ori_roi'};
    sz = [n_masks length(colTypes)];
    mask_table = table('Size',sz,'VariableTypes',colTypes,'VariableNames',colNames);

    for i = 1:n_masks
        file_name = roi_files(i).name;
        %[ ~, image_id, ~ ] = fileparts( file_name );
        %name_pattern = [image_id '_imagej_*.roi'];
        %roi_files_image = dir( fullfile( gt_folder, name_pattern ) );
        file_path = fullfile( roi_files(i).folder, file_name );
        s = regexp( file_name, '^(?<id>.*)_meanshape_(?<mask_id>\d+).csv', 'names' );
        cell_id = 1;
        file_path_ori_roi = fullfile( mask_folder, [s.id ' roiSet.zip'] );
        mask_table(i,:) = { s.id, [s.id '_' s.mask_id], cell_id, str2double(s.mask_id), file_name, file_path, file_path_ori_roi };
    end

    writetable( mask_table, fullfile( output_folder, 'mask_table_meanshape.csv' ) );
    
%     [C,IA,IC] = unique(mask_table.mask_id);
%     id_list = mask_table( IA, 'mask_id' );
%     %n_cell = height(id_list);
% 
    mask_size = size( imread( fullfile( mask_folder, image_files(1).name ) ) );

    colTypes = {'string','string','string','double'};
    colNames = {'mask_id','method','error_type','value'};
    n_methods = length(methods);
    n_error_types = 18;
    sz = [n_masks*n_methods*n_error_types length(colTypes)];
    error_table = table('Size',sz,'VariableTypes',colTypes,'VariableNames',colNames);

    for i = 1:n_masks
        % compute the overlap of the different gt_masks
        mask_id = mask_table{i,'mask_id'};
        p = csvread( mask_table{i,'file_path'} );
        p = p';

        rois_ori = ReadImageJROI( mask_table{i,'file_path_ori_roi'} );
        roi_ori = rois_ori{mask_table{i,'time_id'}+1};

        roi_ori_back = rois_ori{mask_table{i,'time_id'}};
        p_ori_back = roi_ori_back.mnCoordinates';

        roi_ori_forward = rois_ori{mask_table{i,'time_id'}+2};
        p_ori_forward = roi_ori_forward.mnCoordinates';

        p_ori = roi_ori.mnCoordinates';

        %ru = polygon_interpolation( p, n_points );
        %t = linspace( 0, 1, n_points+1 );
        %ru = interparc( t, p(1,:), p(2,:) )';

        t_points = length( p(1,:) );
        t = linspace( 0, t_points, t_points);
        tt = linspace( 0, t_points, n_points );
        pp = spcsp( t, p, smooth_factor );
        ru = ppval(pp,tt);

        t_points = length( p_ori_forward(1,:) );
        t = linspace( 0, t_points, t_points);
        tt = linspace( 0, t_points, n_points );
        pp = spcsp( t, p_ori_forward, smooth_factor );
        ru_ori_forward = ppval(pp,tt);

        t_points = length( p_ori(1,:) );
        t = linspace( 0, t_points, t_points);
        tt = linspace( 0, t_points, n_points );
        pp = spcsp( t, p_ori, smooth_factor );
        ru_ori = ppval(pp,tt);

        t_points = length( p_ori_back(1,:) );
        t = linspace( 0, t_points, t_points);
        tt = linspace( 0, t_points, n_points );
        pp = spcsp( t, p_ori_back, smooth_factor );
        ru_ori_back = ppval(pp,tt);

%         %fnplt( pp );
%         plot(ru(1,:), -ru(2,:),'g');
%         axis equal;
%         hold on;
%         plot(ru_ori_forward(1,:), -ru_ori_forward(2,:),'m');
%         hold on;
%         plot(ru_ori(1,:), -ru_ori(2,:),'r');
%         hold on;
%         plot(ru_ori_back(1,:), -ru_ori_back(2,:),'b');
%         hold off;

%         hold on;
%         plot(p(1,:), -p(2,:),'r');
%         hold on;
%         plot(p_ori(1,:), -p_ori(2,:),'g');
%         hold on;
%         plot(p_ori_forward(1,:), -p_ori_forward(2,:),'b');
%         hold on;
%         plot(p_ori_back(1,:), -p_ori_back(2,:),'m');
        
%         %annotations = zeros( mask_size(1), mask_size(2), n_masks );
%         %for k = 1:n_masks
% 
%         mask = imread( subtable{ k, 'file_path' } );
%         annotations(:,:,k) = mask;
%         [p_val, tt, pp, p] = mask_to_roi( mask, smooth_factor, n_points );
%         P{k} = p_val';
%         end
%         % loop over the different gt_masks
         for j = 1:n_methods
             table_index = (i-1)*n_methods*n_error_types + (j-1)*n_error_types;
             method = methods{j};
%              file_name = [char(mask_id) '_mask_' method '.png'];
%              file_method = fullfile( gt_folder, file_name );
%              mask = imread( file_method );
%              [p_val, tt, pp, p] = mask_to_roi( mask, smooth_factor, n_points );
             P = ru;%p_val';
             mask = poly2mask( ru(2,:), ru(1,:), mask_size(1), mask_size(2) );
             mask_ori = poly2mask( ru_ori(2,:), ru_ori(1,:), mask_size(1), mask_size(2) );
             mask_ori_forward = poly2mask( ru_ori_forward(2,:), ru_ori_forward(1,:), mask_size(1), mask_size(2) );
             mask_ori_back = poly2mask( ru_ori_back(2,:), ru_ori_back(1,:), mask_size(1), mask_size(2) );

             stats = regionprops( mask );
             c = stats.Centroid;
             stats_ori = regionprops( mask_ori );
             c_ori = stats_ori.Centroid;
             stats_ori_forward = regionprops( mask_ori_forward );
             c_next = stats_ori_forward.Centroid;
             stats_ori_back = regionprops( mask_ori_back );
             c_prev = stats_ori_back.Centroid;
             u = c_next - c_ori;
             v = c_ori - c_prev;
             if (norm(u)*norm(v)) ~= 0
                cosAngle = dot( u, v ) / (norm(u)*norm(v));
                c_ori_angle = acos(cosAngle);
             else
                c_ori_angle = 0;
             end
             u = c_next - c;
             v = c - c_prev;
             if (norm(u)*norm(v)) ~= 0
                cosAngle = dot( u, v ) / (norm(u)*norm(v));
                c_angle = acos(cosAngle);
             else
                c_angle = 0;
             end
             %figure();
             %imshow(mask);
             %figure();
             %imshow(mask_ori);

             [hd ahd ~] = HausdorffDist( ru_ori', P');
             [hd_centered ahd_centered ~] = HausdorffDist( ru_ori', P' - (c-c_ori) );
             os = overlap( mask, mask_ori);
             osj = overlap_jaccard( mask, mask_ori);
             osj_prev = overlap_jaccard( mask, mask_ori_back);
             osj_next = overlap_jaccard( mask, mask_ori_forward);
             osj_next_prev = overlap_jaccard( mask_ori_forward, mask_ori_back);
             osj_ori_prev = overlap_jaccard( mask_ori, mask_ori_back);
             osj_ori_next = overlap_jaccard( mask_ori, mask_ori_forward);
             osj_centered = overlap_jaccard( imtranslate( mask, -round(c-c_ori) ), mask_ori );
             error_table( table_index+1, :) = { mask_id, method, 'avg_hausdorff', ahd };
             error_table( table_index+2, :) = { mask_id, method, 'max_hausdorff', hd };
             error_table( table_index+3, :) = { mask_id, method, 'dice_overlap', os };
             error_table( table_index+4, :) = { mask_id, method, 'jaccard_overlap', osj };
             error_table( table_index+5, :) = { mask_id, method, 'jaccard_error', (1-osj) };
             error_table( table_index+6, :) = { mask_id, method, 'jaccard_error_with_prev', (1-osj_prev) };
             error_table( table_index+7, :) = { mask_id, method, 'jaccard_error_with_next', (1-osj_next) };
             error_table( table_index+8, :) = { mask_id, method, 'jaccard_error_next_prev', (1-osj_next_prev) };
             error_table( table_index+9, :) = { mask_id, method, 'jaccard_error_ori_with_prev', (1-osj_ori_prev) };
             error_table( table_index+10, :) = { mask_id, method, 'jaccard_error_ori_with_next', (1-osj_ori_next) };
             error_table( table_index+11, :) = { mask_id, method, 'centroid_diff_ori_next', norm(c_next-c_ori) };
             error_table( table_index+12, :) = { mask_id, method, 'centroid_diff_ori_prev', norm(c_ori-c_prev) };
             error_table( table_index+13, :) = { mask_id, method, 'centroid_diff_next_prev', norm(c_next-c_prev) };
             error_table( table_index+14, :) = { mask_id, method, 'centroid_diff_with_ori', norm(c-c_ori) };
             error_table( table_index+15, :) = { mask_id, method, 'centered_max_hausdorff', hd_centered };
             error_table( table_index+16, :) = { mask_id, method, 'centered_jaccard_error', (1-osj_centered) };
             error_table( table_index+17, :) = { mask_id, method, 'centroid_angle', c_angle };
             error_table( table_index+18, :) = { mask_id, method, 'centroid_ori_angle', c_ori_angle };
         end
    end
    
    writetable( error_table, fullfile( output_folder, 'error_table_meanshape.csv' ) );

