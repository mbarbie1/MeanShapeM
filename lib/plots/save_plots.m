function save_plots( figs, prefix, plot_list, output_folder, fmt )
% SAVE_PLOTS Save the plots

    for i_plot = 1:length( figs )

        plot_str = [ prefix '_' plot_list{ i_plot }];
        name = [ plot_str '.' fmt ];
        file_name = fullfile( output_folder, name );
        h = figs( i_plot );
        saveas( h, file_name, fmt );

    end

end
