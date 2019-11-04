function [S_sum, L_sum] = sum_centroids( r_list )
%SUM_CENTROIDS Take the sum of centroids for the proper centroid
%recalculation.
    
    S_sum = 0;
    L_sum = 0;
    for j = 1:length(r_list)
        r = r_list{ j };
        [Si, r0i, Li] = get_polygon_centroid( r );
        S_sum =+ Si;
        L_sum =+ Li;
    end
    
end
