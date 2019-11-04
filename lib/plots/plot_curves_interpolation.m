function fig = plot_curves_interpolation( r_curves, r_inter, do_plot_connections, plot_ratio, plot_title, visible )
% PLOT_CURVES_INTERPOLATION Plot the interpolation curves together with the original one
%   and connecting lines (optional only for plots with two )
    i1 = 2;
    i2 = 1;
    %visible = 'off';
    fig = figure('visible', visible);
    for i_curve = 1:length( r_curves )
        rr = r_curves{i_curve};
        plot( rr(i1,:),-rr(i2,:),'LineWidth',1);
        hold on;
    end
    if do_plot_connections
        ru = r_curves{1};
        rr = r_curves{2};
        skip = max( 1, floor(1.0/plot_ratio) );
        drx = rr(i1,1:skip:end)-ru(i1,1:skip:end);
        dry = rr(i2,1:skip:end)-ru(i2,1:skip:end);
        quiver( ru(i1,1:skip:end), -ru(i2,1:skip:end), drx, -dry, 0, 'ShowArrowHead', 'off' );
    end
    for i_curve = 1:length( r_inter )
        rr = r_inter{i_curve};
        plot( rr(i1,:),-rr(i2,:), 'g-', 'LineWidth',1);
        hold on;
    end
    axis 'equal';
    title( plot_title );
end
