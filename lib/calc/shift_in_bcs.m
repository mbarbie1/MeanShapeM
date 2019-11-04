function uu = shift_in_bcs( u, min_u, max_u )
%SHIFT_IN_BCS applies periodic bcs to 1D points increasing on an interval, 
%   points larger than the maximum are put shifted to the beginning and 
%   points lower than the minimum are shifted to the end of the interval
    uu = u;
    uu_larger = uu > max_u;
    uu(uu_larger) = uu(uu_larger) - max_u + min_u;
    s = sum( uu > max_u );
    uu = circshift( uu, s );
    uu_smaller = uu < min_u;
    uu( uu_smaller ) = uu( uu_smaller ) - min_u + max_u;
    s = sum( uu_smaller );
    uu = circshift( uu, -s );
    
end

