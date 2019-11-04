function path_list = list_files( image_folder, name_pattern )
    % list all files
    files = dir( fullfile(image_folder, name_pattern ) );
    nFiles = length(files);
    %fprintf('Number of image files: %i\n',nFiles);
    path_list = {};
    for j = 1:nFiles
        %fprintf('Mask image %i out of %i\n', j, nFiles);
        image_path = fullfile( image_folder, files(j).name);
        path_list{j} = image_path;
    end
end
