function generate_log_file( output_folder, file_name, processing, times, options )
%GENERATE_LOG_FILE Generate the log file: contains the processing times
%and the options (in csv format? or mat?)
    file_path = fullfile( output_folder, file_name );
    fields_options = fieldnames(options);
    fields_times = fieldnames(times);
    fields_processing = fieldnames(processing);
    n_fields_options = length( fields_options );
    n_fields_times = length( fields_times );
    n_fields_processing = length( fields_processing );
    for j = 1:n_fields_options
        value = getfield( options, fields_options{j});
        values_options{j} = value;
    end
    for j = 1:n_fields_times
        value = getfield( times, fields_times{j});
        values_times{j} = value;
    end
    for j = 1:n_fields_processing
        value = getfield( processing, fields_processing{j});
        values_processing{j} = value;
    end
    label_fields_processing = cellfun( @(c)[ 'process_' c ], fields_processing, 'uni', false );
    table_processing = table( label_fields_processing, values_processing', 'VariableNames', {'Parameter','value'} );
    label_fields_options = cellfun( @(c)[ 'parameter_' c ], fields_options, 'uni', false );
    table_options = table( label_fields_options, values_options', 'VariableNames', {'Parameter','value'} );
    label_fields_times = cellfun( @(c)[ 'time_' c ], fields_times, 'uni', false );
    table_times = table( label_fields_times, values_times', 'VariableNames', {'Parameter','value'} );

    table_total = [ table_options; table_times; table_processing ];
    writetable( table_total, file_path );
end
