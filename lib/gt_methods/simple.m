function gt = simple( masks, alpha )
%SIMPLE Calculates the ground truth from multiple mask images using the 
%       SIMPLE algorithm.
%   Detailed explanation goes here
    
    N = size( masks, 3 );

%    Initial E(GT)_0: majority voting
    gt0 = majority_voting( masks );
    gt = gt0;
    i = 1;
    N0 = 0;
    N1 = N;
    ind = 1:N;
    
    Ni = N;
    N_prev = N0;
    dicei = {};
    gti = {};
    gti{end+1} = gt0;

    while Ni ~= N_prev && Ni > 0
        dice = zeros( Ni, 1 );
        for j = 1:Ni
            Sj = masks(:,:,ind(j));
            dice(j) = overlap( Sj, gti{i} );
        end
        dicei{end+1} = dice;
        mu = mean( dice );
        sigma = std( dice );
        f = Ni / N;        
        tau = mu - alpha/f * sigma;
        ind_next = ind( dice > tau );
        gt = majority_voting( masks(:,:,ind) );
        gti{end+1} = gt;
        i = i + 1;
        ind = ind_next;
        N_prev = Ni;
        Ni = numel(ind);
    end
end

