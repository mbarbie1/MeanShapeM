function S = overlap( mask1, mask2)
%OVERLAP calculates the dice coefficient
%   
    m1 = mask1 > 0;
    m2 = mask2 > 0;
    Ai = sum(m1.*m2);
    A1 = sum(m1);
    A2 = sum(m2);
    S = 2 * Ai / (A1 + A2);
end

