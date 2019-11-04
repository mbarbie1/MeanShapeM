function calc_comparison_gts( mask_list, image, output_folder, sub_folder, do_save, line_color_mask_list, line_color_method_list, smooth_factor_mask, n_points, rescale_ratio, prefix )
%CALC_COMPARISON_GTS Summary of this function goes here

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

    % method SIMPLE is added here actually not one of the lampert methods
    methods_lampert = { 'staple', 'any', '05', '075', 'exclude', 'excl_05', 'lsml', 'simple' };
    simple_alpha = 0.5;

    % Check the size of the image vs the mask
    n_masks = length( mask_list );
    mask_size = size( mask_list{1} );
    if (size(image) ~= rescale_ratio * mask_size)
        image = imresize( image, rescale_ratio * mask_size );
    end
    image = imadjust( image, stretchlim( image, 0.001) );

    % save the masks as polylines
    fig = imshow(image);
    hold on;
    for j = 1:n_masks

        mask = mask_list{j};
        [p_val, tt, pp, p] = mask_to_roi( mask, smooth_factor_mask, n_points );
        rr = p_val(:,1:end-1);

        i1 = 2;
        i2 = 1;
        p = rescale_ratio * p';
        r = rescale_ratio * rr;
        % plot( p(i1,:),p(i2,:),'Color',line_color_mask_list{j},'LineWidth',2);
        % hold on;
        plot( r(i1,:),r(i2,:),'Color',line_color_mask_list{j},'LineWidth',1);
        hold on;
        % c = linspace( 1, 10, length( rr ) );
        % scatter( r(i1,:),r(i2,:), 5, c );
        axis equal;
        if do_save.poly
            csvwrite( fullfile( output_folder, sub_folder.poly, [ prefix '_' num2str(j) '.csv'] ), rr');
        end
    end

    if do_save.fig_mask
        saveas( fig, fullfile( output_folder, sub_folder.fig_mask, [ prefix '.fig'] ) );
    end

    if ( do_save.gt_mask || do_save.gt_poly || do_save.fig_methods )

        if do_save.fig_methods
            figure();
            fig = imshow(image);
            hold on;
        end

        annotations = zeros( mask_size(1), mask_size(2), n_masks);
        c_min = mask_size;
        c_max = [1, 1];
        for j = 1:n_masks
            mask = mask_list{j};
            annotations( :, : , j ) = mask;
            [ temp_min, temp_max ] = get_bounding_box( mask );
            c_min = min( c_min, temp_min );
            c_max = max( c_max, temp_max );
        end
        c_min = max( c_min-[1,1], [1,1] );
        c_max = min( c_max+[1,1], mask_size );

        annotations_sub = annotations( c_min(1):c_max(1), c_min(2):c_max(2), : );
        [gts_sub, gt_labels] = calculate_GTs( annotations_sub );
        gts_sub_simple = simple( annotations_sub, simple_alpha );
        gts = zeros( mask_size(1), mask_size(2), size( gts_sub, 3) + 1 );
        gts( c_min(1):c_max(1), c_min(2):c_max(2), 1:end-1 ) = gts_sub;
        gts( c_min(1):c_max(1), c_min(2):c_max(2), end ) = gts_sub_simple;
        
                
        for method_id = 1:numel( methods_lampert )
            method = methods_lampert{method_id};
            if do_save.gt_mask
                output_name = [ prefix '_' method '.png' ];
                output_path = fullfile( output_folder, sub_folder.gt_mask, output_name );
                imwrite( gts(:,:,method_id), output_path );
            end

            %%% save the masks as polylines
            mask = gts(:,:,method_id);
            [p_val, tt, pp, p] = mask_to_roi( mask, smooth_factor_mask, n_points );
            rr = p_val(:,1:end-1);

            if ((method_id == 1) || (method_id == 7) || (method_id == 8))
                p = rescale_ratio * p';
                r = rescale_ratio * rr;
                i1 = 2;
                i2 = 1;
                plot( r(i1,:), r(i2,:), 'Color', line_color_method_list{method_id}, 'LineWidth', 1);
                hold on;
                %c = linspace( 1, 10, length( rr ) );
                %scatter( r(i1,:),r(i2,:), 5, c );
            end
            if do_save.gt_poly
                csvwrite( fullfile( output_folder, sub_folder.gt_poly, [ prefix '_' method '.csv'] ), rr');
            end
        end
        if do_save.fig_methods
            saveas( fig, fullfile( output_folder, sub_folder.fig_methods, [ prefix '.fig'] ) );
        end
    end

end

