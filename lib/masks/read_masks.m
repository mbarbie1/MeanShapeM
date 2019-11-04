function annotations = read_masks( image_folder, name_pattern )
    % list all files
    files = dir( fullfile(image_folder, name_pattern ) );
    nFiles = length(files);
    fprintf('Number of image files: %i\n',nFiles);
    for j = 1:nFiles
        fprintf('Mask image %i out of %i\n', j, nFiles);
        image_path = fullfile( image_folder, files(j).name);
        tmp = imread( image_path );
        img = tmp(:,:,1);
        clear( 'tmp' )
        if (j == 1)
            sz = size(img);
            annotations = zeros( [ sz, nFiles ] );
        end
        annotations( :, :, j ) = img;
    end
    annotations = annotations > 0;
end
