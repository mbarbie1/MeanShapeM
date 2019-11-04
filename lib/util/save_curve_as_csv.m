function save_path = save_curve_as_csv( curve, prefix, output_folder, fmt )
%SAVE_CURVES_AS_CSV Save a curve as a csv file
    output_name = [ prefix '.' fmt ];
    save_path = fullfile( output_folder, output_name );
    csvwrite( save_path, curve );
end
