function I = hysterisis(I, t1, t2)
    %HYSTERESIS Summary of this function goes here
    %   Detailed explanation goes here
    for i = 1:size(I, 1)
        for j = 1:size(I, 2)
            if I(i, j) >= t1 && i - 1 > 0 && i + 1 < size(I, 1) && j - 1 > 0 && j + 1 < size(I, 2)
                if any(I(i - 1: i + 1, j - 1: j + 1) >= t2, 'all')
                    I(i, j) = 255;
                else
                    I(i, j) = 0;
                end
            else
                I(i, j) = 0;
            end
        end
    end
end