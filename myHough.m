function [H, T, R] = myHough(I)
    rho_maximum = floor(sqrt(sum(size(I) .^ 2))) - 1;
    T = 0:180;
    R = -rho_maximum:rho_maximum;
 
    H = zeros(size(R, 2), size(T, 2));
    
    [rows, cols] = ind2sub(size(I), find(I == 255));
    
    for i = 1:numel(rows)
        row = rows(i);
        col = cols(i);
        for theta = T
            rho_index = round(((col - 1) * cosd(theta)) + ((row - 1) * sind(theta))) + rho_maximum + 1;
            H(rho_index, theta + 1) = H(rho_index, theta + 1) + 1;
        end
    end
end