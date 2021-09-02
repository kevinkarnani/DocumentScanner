function scanner(file)
    im = rgb2gray(imread(file));
    if size(im, 2) > size(im, 1)
        im = rot90(im);
    end
    edges = edgeDetection(im);
    hys = hysterisis(edges, 5, 20);
    figure; imshow(uint8(hys));
    [H, T, R] = myHough(hys);
    figure; imshow(uint8(H));
    P = myPeaks(H,4,ceil(0.1 * max(H(:))));
    [lineImg, intersections] = myLines(im, T, R, P);
    figure; imshow(uint8(lineImg));
    rectified = myHomography(im, intersections);
    figure; imshow(uint8(rectified));
end
