function pp = polygon_interpolation( p, m_points )
% POLYGON_INTERPOLATION Arc length approximation of a polygon (The polygon
% is defined by its points (endpoint without starting point)
%
    n_points = length( p(1,:) );
    diff_table = circshift( p, -1, 2) - p;
    length_pieces = normv( diff_table );
    length_sum = sum( length_pieces );
    norm_length_pieces = length_pieces / length_sum;
    norm_end_pieces = cumsum( norm_length_pieces );
    norm_start_pieces = norm_end_pieces - norm_length_pieces;
    u = linspace( 0, 1, m_points+1 );
    pp = [];
    for i = 1:n_points
        uu = u( ( u >= norm_start_pieces(i) ) & ( u < norm_end_pieces(i) ) );
        line_1 = ( uu - norm_start_pieces(i) ) ./ norm_length_pieces(i) .* diff_table( 1, i ) + p( 1, i );
        line_2 = ( uu - norm_start_pieces(i) ) ./ norm_length_pieces(i) .* diff_table( 2, i ) + p( 2, i );
        line_segment = [ line_1; line_2 ];
        pp = [pp, line_segment];
    end
    if length(pp) > m_points
        pp = pp(:,1:m_points);
    end
end
