function save_output_curves( curves, image_size, prefix, output_folder, fmt )
% SAVE_OUTPUT_CURVES 

    n_curves = length(curves);
    switch fmt
        case 'png'
            if n_curves == 1
                save_as_mask( curves{1}, image_size, prefix, output_folder, fmt );
            else
                for j = 1:length(curves)
                    save_as_mask( curves{j}, image_size, [prefix '_' int2str(j)], output_folder, fmt );
                end
            end
                
        case 'csv'
            if n_curves == 1
                % Transpose if necessary
                if ( size(curves{1},2) > 2 )
                    save_curve_as_csv( curves{1}', prefix, output_folder, fmt );
                else
                    save_curve_as_csv( curves{1}, prefix, output_folder, fmt );
                end
            else
                for j = 1:length(curves)
                    save_curve_as_csv( curves{j}, [prefix '_' int2str(j)], output_folder, fmt );
                end
            end
        case 'roi'
            if n_curves == 1
                save_curve_as_roi( curves{1}, image_size, prefix, output_folder, fmt );
            else
                for j = 1:length(curves)
                    save_curve_as_roi( curves{j}, image_size, [prefix '_' int2str(j)], output_folder, fmt );
                end
            end
%         case 'zip'
%             save_curves_as_roiset( curves, image_size, prefix, output_folder, fmt );
        otherwise
            warning( [ 'Not saving output: unknown output format: ' fmt ] );
    end
end
