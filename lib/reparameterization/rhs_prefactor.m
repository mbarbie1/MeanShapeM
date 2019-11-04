function [ der, term1, term21, term22] = rhs_prefactor( r, rr, v, vv, a, aa, dg )
%RHS Computes the right hand side of the Eq. (3) of the Euler Lagrange
%   equation
[ der, term1, term21, term22] = rhs( r, rr, v, vv, a, aa );
der = sqrt(v .* vv)./ dg .* der;

end

