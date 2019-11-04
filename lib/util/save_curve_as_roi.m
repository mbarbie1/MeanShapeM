function save_path = save_curve_as_roi( curve, prefix, output_folder, fmt )
%SAVE_CURVES_AS_ROI Summary of this function goes here
%   Detailed explanation goes here
    output_name = [ prefix '.' fmt ];
    save_path = fullfile( output_folder, output_name );
    
    %% TODO there is no such thing as ReadImageJROI for writing ROIs?

end

