function [A, b] = update_newton( A, r, q, uplus, umin )
% UPDATE_A_NEWTON Updates the sparse matrix A

    n = length( q );
    dt = 1;
    v = dw( r , dt );

    % Calculate new b
    b = double( normv( q ) ./ sqrt( normv( v ) ) + 0.5 * normv( r ) );
    
    % Calculate new A
    e = v ./ normv( v );
    tplus = 1.0/(4.0*dt) * ( normv(r) ./ normv(v) ) .* dot( uplus, e, 1 );
    tmin = - 1.0/(4.0*dt) * ( normv(r) ./ normv(v) ) .* dot( umin, e, 1 );
    for j = 2:n
        A( j, j-1 ) = tmin(j);
    end
    A( 1, n ) = tmin( 1 );
    for j = 1:n-1
        A( j, j+1 ) = tplus(j);
    end
    A( n, 1 ) = tplus( n );

end