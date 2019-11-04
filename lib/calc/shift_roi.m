function [p_val_new, pp_new, p_new] = shift_roi( p_val, pp, p, scale, dp )
% SHIFT_ROI scale and translates a roi in pp norm, corresponding p values
%   and p
    
    p_new = scale .* (p + dp');

    pp_new = pp;
    pp_new.coefs(1:2:end,4) = pp_new.coefs(1:2:end,4) + dp(1);
    pp_new.coefs(2:2:end,4) = pp_new.coefs(2:2:end,4) + dp(2);
    pp_new.coefs = scale .* pp_new.coefs;
   
    p_val_new = p_val;
    p_val_new(1,:) = p_val_new(1,:) + dp(1);
    p_val_new(2,:) = p_val_new(2,:) + dp(2);
    p_val_new = scale .* p_val_new;

end
