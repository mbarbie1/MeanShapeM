function options = load_options( file_path )
%LOAD_OPTIONS load the options struct from a file
    options = loadjson( file_path );
end

