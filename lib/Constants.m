classdef Constants
    %CONSTANT This class defines constant labels and other throughout the
    %   program
    
    properties( Constant = true )
        LABEL_CURVE_REFERENCE = 'Reference';
        LABEL_CURVE_OTHER = 'Other curve';
        LABEL_CURVE_LIST = {'Reference', 'Other curve'};
        METHOD_REPARAMETERIZATION_DISCRETE = 'reparameterization_discrete';
        METHOD_RECONSTRUCTION_GRAD = 'reconstruction_grad';
        METHOD_RECONSTRUCTION_ITERATIVE = 'reconstruction_iter';
        METHOD_RECONSTRUCTION_ITERATIVE_VECTOR = 'reconstruction_iter_vec';
        METHOD_RECONSTRUCTION_NEWTON = 'reconstruction_newton';
        REPARAMETERIZATION_NORMALIZATION_FACTOR = 0.24;
        REPARAMETERIZATION_NORMALIZATION_LOCAL = 'reparameterization_normalization_local';
        REPARAMETERIZATION_NORMALIZATION_GLOBAL = 'reparameterization_normalization_global';
        REPARAMETERIZATION_NORMALIZATION_JOZSEF = 'reparameterization_normalization_jozsef';
    end
end
