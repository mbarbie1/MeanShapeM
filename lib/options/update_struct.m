function options_new = update_struct( options, update )
% UPDATE_STRUCT Add or overwrite the options struct with the fields of the
% update struct

    options_new = options;
    fields_update = fieldnames( update );
    %fields_options = fieldnames( options );
    for i_field_update = 1:length(fields_update)
        field_update = fields_update{ i_field_update };
        options_new.(field_update) = update.(field_update);
    end
    
end

