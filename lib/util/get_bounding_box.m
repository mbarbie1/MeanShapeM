function [c_min, c_max] = get_bounding_box( mask )
%GET_BOUNDING_BOX Get the coords of the bounding box of a mask image
%   as the vector [ min_y, min_x, max_y, max_x ]
    [y,x] = ind2sub( size(mask), find(mask) );
    coord = [y, x];
    c_min = min(coord);
    c_max = max(coord);
end
