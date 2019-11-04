function p = p_lookup( p_table, n_table, t, t_min, t_max, centroid )
%P_LOOKUP Looks up a vector of points when given a vector of parameter t
%   values
    tt = round( (n_table - 1) .* (t - t_min) ./ (t_max - t_min) ) + 1;
    tt = max(mod( tt-1, n_table ) + 1, 1 );
    p = p_table( :, tt(:) ) - centroid;
end
