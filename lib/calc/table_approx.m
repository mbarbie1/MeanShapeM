function p_table = table_approx( sub_table, n_points, m_points )
% TABLE_APPROX approximation of a uniform distribution of a sub_table which
% is already uniform, this is a linear subdivision of the existing
% sub_table (sub_table has n_points points, each piece should be subdivided
% in m_points so that the total table has #points = n_points * m_points.
    total_points = n_points * m_points;
    p_table = zeros( 2, total_points );
    diff_table = circshift( sub_table,-1,2) - sub_table;
    for i = 1:n_points
        u = linspace( 0, 1, m_points+1 );
        line_1 = u * diff_table(1,i);
        line_2 = u * diff_table(2,i);
        line_segment = [ line_1; line_2 ];
        p_table( :, ((i-1)*m_points+1):(i*m_points) ) = sub_table( :, i ) + line_segment( :, 1:m_points );
    end
end

