function v_norm = normv( v )
%NORMV returns the norm of an array of vectors (2xN) matrix
    v_norm = sqrt(dot(v,v,1));
end

