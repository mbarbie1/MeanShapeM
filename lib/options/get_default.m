function default = get_default()
% GET_DEFAULT Generates the default options for the meanshape algorithm.
    default = struct;
    default.curve_n_table                           = 1000000;
    default.curve_n_table_sub                       = 1000;
    default.curve_center                            = 0;
    default.curve_type                              = 'discrete';
    default.curve_smoothness                        = 0.01;
    default.curve_n_points                          = 500;
    default.centroid_n_iter                         = 1;
    default.centroid_step_size                      = 1;
    default.average_is_weighted                     = 0;
    default.average_weights                         = [];
    default.reparametrization_step_size             = 0.001;
    default.reparametrization_n_iter                = 1000;
    default.reparametrization_min_point_distance    = 0.01;
    default.reparametrization_gamma                 = 0.01;
    default.reconstruction_step_size                = 0.001;
    default.reconstruction_n_iter                   = 1000;
    default.reconstruction_precision                = 0.000001;
end
