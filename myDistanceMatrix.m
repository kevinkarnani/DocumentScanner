function D = myDistanceMatrix(Vx, Vy)
    D = zeros(size(Vx,1));
    for i = 1:size(Vx,1)
        D(i,:) = abs(Vx - Vx(i)) + abs(Vy - Vy(i));
    end
end
