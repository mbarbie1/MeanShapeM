function figs = plot_results( debug, plot_list )
%SHOW_RESULTS Show the results of the averaging with debugging info

    figs = [];

    for i_plot = 1:length(plot_list)

        plot_name = plot_list{i_plot};
        visible = 'off';

        switch plot_name

            case 'interpolation_curve_r'
                fig = plot_curves_interpolation( debug.r_curves, debug.r_inter, 0, 0.1, 'R curves and interpolations', visible );

            case 'interpolation_curve_r_lines'
                fig = plot_curves_interpolation( debug.r_curves, debug.r_inter, 1, 0.1, 'R curves and interpolations (lines)', visible );

            case 'average_curve_r'
                fig = plot_curves_average( debug.r_curves, debug.r_avg, 0, 0.1, 'R curves and average', visible );

            case 'average_curve_r_lines'
                fig = plot_curves_average( debug.r_curves, debug.r_avg, 1, 0.1, 'R curves and average (lines)', visible );

            case 'average_curve_r_color'
                fig = plot_curves_average_color( debug.r_curves, debug.r_avg, 1, 0.5, 'R curves and average (lines)', visible );

            case 'average_curve_q'
                fig = plot_curves_average( debug.q_curves, debug.q_avg, 0, 0.1, 'Q curves and average', visible );

            case 'average_curve_q_lines'
                fig = plot_curves_average( debug.q_curves, debug.q_avg, 1, 0.1, 'Q curves and average (lines)', visible );

            case 'reparameterization_gamma'
                % Plot the final gamma curve
                fig = figure('visible', visible);
                g = debug.g_list{2};
                plot( g );
                title( '\gamma(t) vs t' );

            case 'reparameterization_gammas'
                % Plot the gamma curves (iterations)
                fig = figure('visible', visible);
                plot_ratio = 0.01;
                skip = round(1/plot_ratio);
                gs = debug.gs_list{1};
                plot(gs(1:skip:end,:));
                title( 'Iterations: \gamma(t) vs t' );
                
            case 'reparameterization_energies'
                % Plot the energy curve vs iterations during
                % reparameterization.
                fig = figure('visible', visible);
                ens = debug.reparameterization_energies;
                plot( ens );
                ylim( [min(ens), 2 * median(ens)] );
                title( 'energy vs reparameterization iteration' );
                

            case 'reconstruction_step_sizes'
                % Plot the mean step sizes during averaging
                fig = figure('visible', visible);
                mean_step_sizes = debug.averaging_steps;
                plot( mean_step_sizes );
                title('Step sizes for convergence of q to r');
            
            case 'reconstruction_r_curves'
                fig = figure('visible', visible);
                i1 = 2;
                i2 = 1;
                plot_ratio = 1;
                skip = round( 1 / plot_ratio );
                for i_curve = 1:skip:length( debug.rs_avg )
                    r = debug.rs_avg{ i_curve };
                    plot( r(i1,:), -r(i2,:), 'g-', 'LineWidth',1);
                    hold on;
                    plot( r(i1,:), -r(i2,:), 'r.', 'LineWidth',1);
                    hold on;
                end
                axis 'equal'
                title('R curves during reconstruction');

            case 'reconstruction_r_init'
                fig = figure('visible', visible);
                i1 = 2;
                i2 = 1;
                r_init = debug.r_init;
                plot( r_init(i1,:),-r_init(i2,:),'b-', 'LineWidth',1);
                axis 'equal'
                title('Initial r for reconstruction');

        end
        
        hold off;
        figs(end+1) = fig;

    end

end

