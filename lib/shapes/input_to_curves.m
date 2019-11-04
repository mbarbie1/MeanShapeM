function [ curve_list, image_size ] = input_to_curves( input_list, n_points, smooth_factor )
%INPUT_TO_CURVES Converts the list of input paths/curves/masks to curves
%   with a specific amount of points

    image_size = [];

    % Number of inputs (should equal the amount of curves: n_curves)
    n_curves = length( input_list );

    % Convert all input types to a list of curve points
    curve_list = {};
    for j = 1:n_curves
        sz = size( input_list{j} );
        n_sz = numel( sz );
        
        % Mask if dimensions are larger than 2
        if ( n_sz > 1 ) & ( min( sz ) > 2 )
            mask = input_list{j};
            image_size = size(mask);
            [p_val, t, pp, p] = mask_to_roi( mask, smooth_factor, n_points );
            t = linspace( 0, 1, n_points+1 );
            ru = interparc( t, p_val(1,:), p_val(2,:) )';
            curve_list{j} = ru(:,1:end-1);
        end
        % Vector of points ( 2 x n_points )
        if ( n_sz == 2 ) & ( sz(1) == 2 )
            p_val = input_list{j};
            %t = linspace( 0, 1, n_points+1 );
            p = p_val;
            t_points = length( p(1,:) );
            t = linspace( 0, t_points, t_points);
            tt = linspace( 0, t_points, n_points );
            pp = spcsp( t, p, smooth_factor );
            ru = ppval(pp,tt);
            %ru = interparc( t, p_val(1,:), p_val(2,:) )';
            %ru = polygon_interpolation( p_val, n_points );
            curve_list{j} = ru(:,1:end);
        end
        % String
        if ( ischar( input_list{j}) )
            file_path = input_list{j};
            [~, ~, ext] = fileparts( file_path );
            switch lower(ext)
                case '.csv'
                    p = csvread( file_path );
                    p = p';
                    ru = polygon_interpolation( p, n_points );
                    %u = linspace( 0, 1, options.curve_n_points + 1 );
                    %ru = interparc( t, p_val(1,:), p_val(2,:) )';
                    curve_list{j} = ru(:,1:end);
                case '.png'
                    mask = imread( file_path );
                    image_size = size(mask);
                    [p_val, t, pp, p] = mask_to_roi( mask, smooth_factor, n_points );
                    t = linspace( 0, 1, n_points+1 );
                    ru = interparc( t, p_val(1,:), p_val(2,:) )';
                    curve_list{j} = ru(:,1:end);
                otherwise
                    error('Curve input by string (file_path), but extension unknown (should be png or csv)');
            end
        end
        
    end
end

