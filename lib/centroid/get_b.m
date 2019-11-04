function b = get_b( r_list, v_list, r, v, t )

    %n = length( r_list );
    %[S_sum, L_sum] = sum_centroids( r_list );
    %[S_avg, r0, L_avg] = get_polygon_centroid( r_avg );
    %[S_mix, den_mix, terms] = int_mix( r_list, v_list, r_avg, v_avg, t );
    %b = ( S_sum + n * S_avg - S_mix ) ./ ( L_sum + n * L_avg - 2 * den_mix );% 
    num = 0;
    den = 0;
    n_curves = length( r_list );
    %v = dw( r, dt );
    sqrtv = sqrt( normv(v) );
    q = sqrtv .* r;
    for j = 1:n_curves
        ri = r_list{j};
        vi = v_list{j};
        %vi = dw( ri, dt );
        sqrtvi = sqrt( normv(vi) );
        qi = sqrtvi .* ri;
        %Int_num = sum( ( qi .* sqrtvi - q .* sqrtv ) .* sqrtvi, 2 ); % from JOZSEF
        Int_num = sum( qi .* sqrtvi + q .* sqrtv - q .* sqrtvi - qi .* sqrtv, 2 ); % from the paper before the Arxiv version
        %Int_num = sum( qi + q - q .* sqrtvi - qi .* sqrtv, 2 ); % This is the Arxiv version
        Int_den = sum( (sqrtvi-sqrtv) .* (sqrtvi-sqrtv) );
        num = num + Int_num;
        den = den + Int_den;
    end
    eps = 0.0000000001;
    if den > eps
        b = num / den; 
    else
        b = ( num + eps ) / ( den + eps );
    end

end
