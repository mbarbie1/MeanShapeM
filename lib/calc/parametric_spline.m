function [ xt, yt, tt ] = parametric_spline( x, y, n_points, smoothness )
% parametric_spline Summary of this function goes here 
% Detailed explanation goes here 
% Reference https://www.physicsforums.com/threads/parametric-spline-in-matlab.468582/
    arc_length = 0; n = length(x); 
    t = zeros(n, 1); 
    for i=2:n 
        arc_length = sqrt((x(i)-x(i-1))^2 + (y(i)-y(i-1))^2); 
        t(i) = t(i-1) + arc_length; 
    end
    t = t./t(length(t));
    %smoothness = smoothness * (x ./ x);
    xt = csaps( t, x, smoothness );
    yt = csaps( t, y, smoothness );
    xt = spcsp( t, x, smoothness );
    yt = spcsp( t, y, smoothness );
    %xt = csape( t, x, 'clamped' ); 
    %yt = csape( t, y, 'clamped' ); 
    %xt = spline(t, x);
    %yt = spline(t, y);
    tt = linspace( 0, 1, n_points );
    
end 

