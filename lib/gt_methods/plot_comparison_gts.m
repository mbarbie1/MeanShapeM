function plot_comparison_gts( input_mask_list, input_gt_list, image, output_folder, line_color_mask_list, line_color_method_list, smooth_factor, n_points, rescale_ratio, prefix, n_border )
% PLOT_COMPARISON_GTS Summary of this function goes here

    % method SIMPLE is added here actually not one of the lampert methods
    methods_lampert = { 'staple', 'any', '05', '075', 'exclude', 'excl_05', 'lsml', 'simple' };

    n_masks = length( input_mask_list );
    n_gts = length( input_gt_list );

    [ curve_list, ~ ] = input_to_curves( input_mask_list, n_points, smooth_factor );
    [ mask_list, mask_size ] = input_to_masks( input_mask_list, n_points );
    [ curve_gt_list, image_size ] = input_to_curves( input_gt_list, n_points, smooth_factor );

    % Check the size of the image vs the mask
    image = imresize( image, rescale_ratio * mask_size );
    image = imadjust( image, stretchlim( image, 0.001) );

    c_min = mask_size;
    c_max = [1, 1];
    prob = zeros( mask_size );
    for j = 1:n_masks
        mask = mask_list{j};
        prob = prob + double(mask);
        [ temp_min, temp_max ] = get_bounding_box( mask );
        c_min = min( c_min, temp_min );
        c_max = max( c_max, temp_max );
    end
    %prob = uint( prob );
    %prob = imadjust( prob, stretchlim( prob, 0.0) ); 

    c_min = max( c_min-[n_border,n_border], [1,1] );
    c_max = min( c_max+[n_border,n_border], mask_size );
    prob_sub = prob( c_min(1):c_max(1), c_min(2):c_max(2) );
    image_sub = image( c_min(1):c_max(1), c_min(2):c_max(2) );

    
    % save the masks as polylines
    fig = imshow(image_sub);
    hold on;
    for j = 1:n_masks
        
        rr = curve_list{j};
        i1 = 2;
        i2 = 1;
        r = rescale_ratio * rr;
        % plot( p(i1,:),p(i2,:),'Color',line_color_mask_list{j},'LineWidth',2);
        % hold on;
        plot( r(i1,:)-c_min(i1),r(i2,:)-c_min(i2),'Color',line_color_mask_list{j},'LineWidth',1);
        hold on;
        % c = linspace( 1, 10, length( rr ) );
        % scatter( r(i1,:),r(i2,:), 5, c );
    end

%     if do_save.fig_mask
%         saveas( fig, fullfile( output_folder, sub_folder.fig_mask, [ prefix '.fig'] ) );
%     end
% 

    figure();
    imagesc(prob_sub);
    colormap(gray);
    hold on;
    for j = 1:n_gts
        
        rr = curve_gt_list{j};
        i1 = 2;
        i2 = 1;
        r = rescale_ratio * rr;
        % plot( p(i1,:),p(i2,:),'Color',line_color_mask_list{j},'LineWidth',2);
        % hold on;
        plot( r(i1,:)-c_min(i1),r(i2,:)-c_min(i2),'Color',line_color_method_list{j},'LineWidth',1);
        hold on;
        % c = linspace( 1, 10, length( rr ) );
        % scatter( r(i1,:),r(i2,:), 5, c );
    end


%     if ( do_save.gt_mask || do_save.gt_poly || do_save.fig_methods )
% 
%         if do_save.fig_methods
%             figure();
%             fig = imshow(image);
%             hold on;
%         end
% 
%         annotations = zeros( mask_size(1), mask_size(2), n_masks);
%         c_min = mask_size;
%         c_max = [1, 1];
%         for j = 1:n_masks
%             mask = mask_list{j};
%             annotations( :, : , j ) = mask;
%             [ temp_min, temp_max ] = get_bounding_box( mask );
%             c_min = min( c_min, temp_min );
%             c_max = max( c_max, temp_max );
%         end
%         c_min = max( c_min-[1,1], [1,1] );
%         c_max = min( c_max+[1,1], mask_size );
% 
%         annotations_sub = annotations( c_min(1):c_max(1), c_min(2):c_max(2), : );
%         [gts_sub, gt_labels] = calculate_GTs( annotations_sub );
%         gts_sub_simple = simple( annotations_sub, simple_alpha );
%         gts = zeros( mask_size(1), mask_size(2), size( gts_sub, 3) + 1 );
%         gts( c_min(1):c_max(1), c_min(2):c_max(2), 1:end-1 ) = gts_sub;
%         gts( c_min(1):c_max(1), c_min(2):c_max(2), end ) = gts_sub_simple;
% 
%         for method_id = 1:numel( methods_lampert )
%             method = methods_lampert{method_id};
%             if do_save.gt_mask
%                 output_name = [ prefix '_' method '.png' ];
%                 output_path = fullfile( output_folder, sub_folder.gt_mask, output_name );
%                 imwrite( gts(:,:,method_id), output_path );
%             end
% 
%             %%% save the masks as polylines
%             mask = gts(:,:,method_id);
%             [p_val, tt, pp, p] = mask_to_roi( mask, smooth_factor_mask, n_points );
%             rr = p_val(:,1:end-1);
% 
%             if ((method_id == 1) || (method_id == 7) || (method_id == 8))
%                 p = rescale_ratio * p';
%                 r = rescale_ratio * rr;
%                 i1 = 2;
%                 i2 = 1;
%                 plot( r(i1,:), r(i2,:), 'Color', line_color_method_list{method_id}, 'LineWidth', 1);
%                 hold on;
%                 %c = linspace( 1, 10, length( rr ) );
%                 %scatter( r(i1,:),r(i2,:), 5, c );
%             end
%             if do_save.gt_poly
%                 csvwrite( fullfile( output_folder, sub_folder.gt_poly, [ prefix '_' method '.csv'] ), rr');
%             end
%         end
%         if do_save.fig_methods
%             saveas( fig, fullfile( output_folder, sub_folder.fig_methods, [ prefix '.fig'] ) );
%         end
%     end

end

