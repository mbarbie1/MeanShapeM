function [ pLengths, pDifference, totalLength ] = get_length( p )
%GET_LENGTH obtains the lengts of the line-pieces that the polygon exists
%   of.
    pDifference = circshift(p,-1,2) - p;
    pLengths = normv( pDifference );
    totalLength = sum( pLengths );
end

