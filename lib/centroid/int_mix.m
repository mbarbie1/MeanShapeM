function [S_mix, den_mix, terms] = int_mix( r_list, v_list, r_avg, v_avg, t )
    n_curves = length( r_list );
    terms = {};
    S_mix = zeros( 2, 1 );
    den_mix = zeros( 2, 1 );
    for j = 1:n_curves
        r = r_list{j};
        v = v_list{j};
        t_prev = circshift( t, 1 );
        tdiff = t - t_prev;
        tdiff(1) = t(1) - (t(end)-1);
        v_term = sqrt( normv( v_avg ) .* normv( v ) );
        % mix_term = sum( ( r + r_avg ) .* v_term .* tdiff, 2 );
        mix_term = sum( ( r + r_avg ) .* v_term, 2 );
        terms{end+1} = mix_term;
        S_mix = S_mix + mix_term;

        % tdiff should be 1 because the velocity is computed as such???
        % But what about the g function then???
        den_mix_term = sum( v_term, 2 );
        % den_mix_term = sum( v_term .* tdiff, 2 );
        den_mix = den_mix + den_mix_term;

    end
end
