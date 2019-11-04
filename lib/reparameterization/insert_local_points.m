function [ t_new, g_new ] = insert_local_points( t, t_min, t_max, g, g_min, g_max, max_g_ratio, n_inc )
%%
    n_points = length(t);
    max_g_diff = max_g_ratio * (g_max - g_min) / n_points; 
    % max_g_ratio is typically 0.2 ( or at least higher than the minimal
    % distance, or wait, what? Let rethink about this
    if ( n_inc > 0 )
        g = [g, g_max + g(1)];
        t = [t, t_max + t(1)];
        g_diff = d( g, 1.0 );
        t_inc = find( g_diff > max_g_diff );
        i_shift_inc = 0;
        for index_inc = 1:length(t_inc)
            i_inc = t_inc( index_inc );
            i = i_inc + i_shift_inc;
            i_next = i+1;
            t_interp = linspace( t(i), t(i_next), n_inc + 2 );
            t_interp = t_interp(2:end-1);
            g_interp = linspace( g(i), g(i_next), n_inc + 2 );
            g_interp = g_interp(2:end-1);
            t = [ t(1:i), t_interp, t(i_next:end) ];
            g = [ g(1:i), g_interp, g(i_next:end) ];

            i_shift_inc = i_shift_inc + n_inc;
        end
        g_new = g(1:end-1);
        t_new = t(1:end-1);
    else
        g_new = g;
        t_new = t;
    end
    

end
