function [ name_list, path_list ] = list_file_names( image_folder, name_pattern )
    % list all files
    files = dir( fullfile(image_folder, name_pattern ) );
    nFiles = length(files);
    %fprintf('Number of image files: %i\n',nFiles);
    name_list = {};
    path_list = {};
    for j = 1:nFiles
        %fprintf('Mask image %i out of %i\n', j, nFiles);
        file_name = files(j).name;
        image_path = fullfile( image_folder, file_name);
        path_list{j} = image_path;
        name_list{j} = file_name;
    end
end
