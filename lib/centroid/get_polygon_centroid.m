 function [ S, r0, L] = get_polygon_centroid( p )
    %
    % Centroid of the polygon curve:
    %    
    %  r0 = sum_i { R(i) * L(i) } / L
    %
    [ pLengths, pDifference, totalLength ] = get_length( p );
    mass = zeros( size( p ) );
    middle = p + pDifference/2;
    mass(1,:) = pLengths .* middle(1,:);
    mass(2,:) = pLengths .* middle(2,:);
    S = sum( mass, 2 );
    r0 = S / totalLength;
    L = totalLength;
end
