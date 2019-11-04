function gt = tesd( masks )
%TESD Calculates the ground truth from multiple mask images using TESD
%   TESD is 
    n_masks = size(masks, 3);
    D = zeros( size(masks) );
    for i = 1:n_masks
        mask = masks( :, :, i);
        dist_out = -bwdist( mask );
        dist_in = bwdist( 1 - mask );
        D(:,:,i) = dist_out + dist_in;
    end
    % 1: inner core, 2: inside border, 3: outside border, 4: outer space
    L = 
    
    
    m , mi = max(  )
    
end

