% Takes:
% I = Image
% T = Thetas
% R = Rhos
% P = Peaks
% Returns
% lineImg = original image with overlayed lines
% V = vertices of the resulting quadrilateral (x, y)
%   V is sorted in order (1) top left (2) 

function [lineImg, V] = myLines(I, T, R, P)
    % This value controls the the line thickness and,
    % consequently, the precision of the vertex placement
    [M, N] = size(I);
    
    lineImg = I;
    lineMasks = double(zeros(M, N, size(P, 1)));
    
    x = repmat(1:N, M, 1);
    y = repmat((1:M)', 1, N);
    
    for p=1:size(P, 1)
        lineMasks(:,:,p) = double(abs(x .* cosd(T(P(p, 2))) + y .* sind(T(P(p, 2))) - R(P(p, 1))) < 2);
    end
    
    lineImg(sum(lineMasks, 3) > 0) = 255;
    V = sortrows(myIntersections(lineMasks));
end

function V = myIntersections(lineMasks)

    % Get intersections from masks
    [Vy, Vx] = find(sum(lineMasks,3) == 2);
    if size(Vx,1) < 4
        throwEmptyMappingDialog;
    end
    
    % distances matrix
    while size(Vx,1) > 4
        D = myDistanceMatrix(Vx, Vy);
        % Remove the 0s from the diagonal
        D = D + (max(D,[],'all') * eye(size(D,1))) + 1;
        % Remove the point with the shortest distance to another point
        % (always prefers to remove points listed first)
        [~, idx] = min(min(D,[],1), [], 'all', 'linear');
        Vx = vertcat(Vx(1:idx-1), Vx(idx+1:size(Vx,1)));
        Vy = vertcat(Vy(1:idx-1), Vy(idx+1:size(Vy,1)));
    end
        
    V = horzcat(Vx, Vy);
    
end
