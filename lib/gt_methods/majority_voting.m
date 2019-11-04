function fused = majority_voting( masks )
%MAJORITY_VOTING computes a fused mask by majority voting
%   Detailed explanation goes here
    n_masks = size( masks, 3 );
    fused = round(sum( masks, 3) / n_masks);
end

