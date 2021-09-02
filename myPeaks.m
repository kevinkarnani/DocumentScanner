function peaks = myPeaks(H, numpeaks, threshold)
    window = floor(size(H) / 100.0) * 2 + 1;

    [rows, cols] = size(H);
    
    peaks = zeros(numpeaks, 2);
    for m = 1:numpeaks
        max_val = max(H(:));
        if max_val >= threshold
            [row_index, col_index] = find(H == max_val, 1);
            lowX = max([floor(row_index - window(1)), 1]);
            highX = min([ceil(row_index + window(1)), rows]);
            lowY = max([floor(col_index - window(2)), 1]);
            highY = min([ceil(col_index + window(2)), cols]);
            H(lowX:highX, lowY:highY) = 0;
            peaks(m, :) = [row_index, col_index];
        end
    end
    peaks = peaks(any(peaks, 2), :);
end