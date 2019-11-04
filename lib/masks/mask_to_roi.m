function [p_val, tt, pp, p] = mask_to_roi( mask, smooth_factor, n_points )
% MASK_TO_ROI converts a mask image in a polygon ROI (n x 2)
    p = bwboundaries( mask, 'noholes' );
    p = p{1};
%     if smooth_factor ~= 0
%         %x = p(:,1);
%         %y = p(:,2);
%         pp = cscvn( p' );
%         p2 = spcrv( p', 3 )';
%     end
%     figure();
%     fnplt( pp );
%     figure();
%     plot( p2(:,1), p2(:,2) );

    Y = p;
    t_points = length( p(:,1) );
    t = linspace( 0, t_points, t_points);
    tt = linspace( 0, t_points, n_points );
    pp = spcsp( t, Y', smooth_factor );
    %fnplt( pp );
    p_val = ppval(pp,tt);
   
%     x1 = p(:,1);
%     y1 = p(:,2);
%     [x_t, y_t, t] = parametric_spline( x1, y1, n_points, smooth_factor );
%     xref = ppval (x_t, t);
%     yref = ppval(y_t, t); 
%     figure();
%     plot(x1, y1, 'o', xref, yref); 
% 
%     t = linspace( 0, n_points, n_points );
%     p = fnval( pp, t )';
end
