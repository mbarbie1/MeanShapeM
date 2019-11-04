function plot_curves_average_update( r_curves, r_avg, centroid_list, do_plot_connections, plot_ratio, plot_title, h_fig )
%PLOT_UPDATE_CURVES_AVERAGE Plot the curves and the average with
%connections and add the centroid points

    % Get the axes of the fig and clear it
    ax = h_fig.CurrentAxes;
    cla(ax);

    i1 = 2;
    i2 = 1;
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
    plot( r_avg(i1,:), -r_avg(i2,:),'g-','LineWidth',2);
    axis 'equal';
    title( plot_title );

    hold on;
    c = linspace(0,1,length(centroid_list));
    for j = 1:length(centroid_list)
        centroid = centroid_list{j};
        scatter( centroid(2),-centroid(1),12,c(j)*[0.3,1,1]);
        hold on;
    end
end
