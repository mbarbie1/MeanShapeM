function fig = plot_curves_color( r_curves, do_plot_connections, plot_ratio, plot_title, visible )
% PLOT_CURVES_COLOR Plot the couple of curves and colored points, 
%   connecting lines (only for plots with two curves)
    i1 = 2;
    i2 = 1;
    %visible = 'off';
    fig = figure('visible', visible);
    min_x = inf;
    min_y = inf;
    max_x = 0;
    max_y = 0;
    for i_curve = 1:length( r_curves )
        rr = r_curves{i_curve};
        plot( rr(i1,:),-rr(i2,:),'LineWidth',1);
        hold on;
        c = linspace( 1, 10, length( rr ) );
        scatter( rr(i1,:),-rr(i2,:), 2, c );
        hold on;
        min_x = min( min_x, min( rr(i1,:) ) );
        min_y = min( min_y, min( rr(i2,:) ) );
        max_x = max( max_x, max( rr(i1,:) ) );
        max_y = max( max_y, max( rr(i2,:) ) );
    end
    if do_plot_connections
        ru = r_curves{1};
        rr = r_curves{2};
        skip = max( 1, floor(1.0/plot_ratio) );
        drx = rr(i1,1:skip:end)-ru(i1,1:skip:end);
        dry = rr(i2,1:skip:end)-ru(i2,1:skip:end);
        quiver( ru(i1,1:skip:end), -ru(i2,1:skip:end), drx, -dry, 0, 'ShowArrowHead', 'off' );
    end
    axis 'equal';
    title( plot_title );
    xlim([min_x max_x]);
    ylim([-max_y -min_y]);

end
