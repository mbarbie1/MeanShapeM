function [ der, term1, term21, term22] = rhs( r, rr, v, vv, a, aa )
%RHS Computes the right hand side of the Eq. (3) of the Euler Lagrange
%   equation
term1 = dot(v,rr,1) - dot(r,vv,1);
term21 = dot(v,a,1) ./ sum(dot(v,v,1));
term22 = dot(vv,aa,1) ./ sum(dot(vv,vv,1));
term2 = 0.5 * dot(r,rr,1) .* ( term21 - term22 );
der = term1 + term2;

end

