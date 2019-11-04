function image_table = get_name_sets( masks_folder, ext, var_pattern )
% GET_NAME_SETS Obtains for each image set: the pattern to get the whole
% set, the list of file names of the set, the different attributes like:
% image_id, object_id, annotator_id, repeat_id, ...

    image_files = dir( fullfile( masks_folder, [ '*.' ext ] ) );
    n_images = length(image_files);

    varNames = { 'image_name', 'image_folder', 'name_pattern', 'name_prefix', 'image_id', 'region_id', 'annotator_id', 'repeat_id' };
    varTypes = { 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string' };
    sz = [ n_images, length(varTypes) ];
    t = table( 'Size', sz, 'VariableTypes', varTypes, 'VariableNames', varNames );
    for i_image = 1:n_images
        image_name = image_files( i_image ).name;
        t.image_name( i_image ) = image_name;
        t.image_folder( i_image ) = image_files( i_image ).folder;
        split_char = '_';
        [ ~, base_name, ~ ] = fileparts( image_name );
        C = strsplit( base_name, split_char );
        image_id = C{1};
        region_id = C{2};
        annotator_id = C{3};
        repeat_id = C{4};
        for i_concat = 5:length(C)
            repeat_id = [ repeat_id split_char C{i_concat} ];
        end
        t.image_id( i_image ) = image_id;
        t.region_id( i_image ) = region_id;
        t.annotator_id( i_image ) = annotator_id;
        t.repeat_id( i_image ) = repeat_id;
        switch var_pattern
            case 'annotator'
                t.name_pattern( i_image ) = [ image_id split_char region_id split_char '*' repeat_id '.' ext ];
                t.name_prefix( i_image ) = [ image_id split_char region_id split_char repeat_id ];
            case 'repeat'
                t.name_pattern( i_image ) = [ image_id split_char region_id split_char annotator_id split_char '*.' ext ];
                tmp = [ image_id split_char region_id split_char annotator_id ];
                t.name_prefix( i_image ) = tmp;
            case 'annotator_repeat'
                t.name_pattern( i_image ) = [ image_id split_char region_id '*.' ext ];
                t.name_prefix( i_image ) = [ image_id split_char region_id ];
        end
    end
    image_table = t;
    %image_info_list( i_set );

end

