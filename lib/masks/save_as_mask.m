function save_path = save_as_mask( avg_curve, image_size, prefix, output_folder, fmt )
% SAVE_AS_MASK Saves the average curve as a mask to the output folder with a
%   certain prefix

    avg_curve = double( avg_curve );
    output_name = [ prefix '_' 'mask' '.' fmt ];
    save_path = fullfile( output_folder, output_name );
    bw = poly2mask( avg_curve(2,:), avg_curve(1,:), image_size(1), image_size(2) );
    imwrite( bw, save_path );

end
