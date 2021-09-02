
% Takes an image I and intersections given by myLines
% Returns the homography matrix H

function I = myHomography(I, intersections)
    % Minimize Effects of Rounding
    width = size(I,2);
    height = size(I,1);
    if height > width; width=round((8.5 / 11.0) * height); else; height=round((11.0 / 8.5) * width); end
    
    % First figure out which intersection corresponds to which corner
    D = myDistanceMatrix(intersections(:,1), intersections(:,2));
    [~, idx1] = min(nonzeros(D(1,:)), [], 'all', 'linear');
    idx1 = idx1 + 1;
    [~, idx2] = max(D(1,:), [], 'all', 'linear');
    [~, idx3] = min(nonzeros(D(idx2,:)), [], 'all', 'linear');
    if idx3 >= idx2; idx3 = idx3+1; end
    % All coords are (x,y)
    top_left        = intersections(1,:);
    top_left_target = [1,1];
    top_right        = intersections(idx1,:);
    top_right_target = [width, 1];
    bottom_left        = intersections(idx3,:);
    bottom_left_target = [1, height];
    bottom_right        = intersections(idx2,:);
    bottom_right_target = [width, height];
    
    % Build matrices for Homography
    A = [top_left(1), top_left(2), 1, 0, 0, 0, 0, 0, 0;
         0, 0, 0, top_left(1), top_left(2), 1, 0, 0, 0;
         top_right(1), top_right(2), 1, 0, 0, 0, 0, 0, 0;
         0, 0, 0, top_right(1), top_right(2), 1, 0, 0, 0;
         bottom_left(1), bottom_left(2), 1, 0, 0, 0, 0, 0, 0;
         0, 0, 0, bottom_left(1), bottom_left(2), 1, 0, 0, 0;
         bottom_right(1), bottom_right(2), 1, 0, 0, 0, 0, 0, 0;
         0, 0, 0, bottom_right(1), bottom_right(2), 1, 0, 0, 0];
    B = [0, 0, 0, 0, 0, 0, top_left_target(1)*top_left(1), top_left_target(1)*top_left(2), top_left_target(1);
         0, 0, 0, 0, 0, 0, top_left_target(2)*top_left(1), top_left_target(2)*top_left(2), top_left_target(2);
         0, 0, 0, 0, 0, 0, top_right_target(1)*top_right(1), top_right_target(1)*top_right(2), top_right_target(1);
         0, 0, 0, 0, 0, 0, top_right_target(2)*top_right(1), top_right_target(2)*top_right(2), top_right_target(2);
         0, 0, 0, 0, 0, 0, bottom_left_target(1)*bottom_left(1), bottom_left_target(1)*bottom_left(2), bottom_left_target(1);
         0, 0, 0, 0, 0, 0, bottom_left_target(2)*bottom_left(1), bottom_left_target(2)*bottom_left(2), bottom_left_target(2)
         0, 0, 0, 0, 0, 0, bottom_right_target(1)*bottom_right(1), bottom_right_target(1)*bottom_right(2), bottom_right_target(1);
         0, 0, 0, 0, 0, 0, bottom_right_target(2)*bottom_right(1), bottom_right_target(2)*bottom_right(2), bottom_right_target(2)];
    
    % Singular Value Decomposition
    temp = A' * A + B' * B - A' * B - B' * A;
    [~,~,V] = svd(temp);
    % the last eigenvalue is the smallest one
    H = reshape(V(:, 9),[3, 3])';
    
    % New image
    new = zeros(round(height), round(width));
    for new_y = 1:size(new, 1)
        for new_x = 1:size(new, 2)
            homogenized = H \ [new_x, new_y, 1]';
            homogenized = homogenized / homogenized(3);
            og_x = round(homogenized(1));
            og_y = round(homogenized(2));
            if (og_x >= 1 && og_x <= size(I, 2)) && (og_y >= 1 && og_y <= size(I, 1))
                new(new_y, new_x) = I(og_y, og_x);
            end
        end
    end
    
    % Return new image
    I = new;
    
    % The intersections sorting above assumes that the top left corner is
    % lower in y value than the top right corner. In this case flip the
    % resulting image.
    if top_left(2) < top_right(2); I = flipud(I); end
    
end