function e = edgeDetection(I)
    grad_x = [0, 0, 0; 1, 0, -1; 0, 0, 0] / 2;
    grad_y = [0, 1, 0; 0, 0, 0; 0, -1, 0] / 2;
    gauss = imgaussfilt(I, .25);
    e = abs(conv2(gauss, grad_x + grad_y, 'same'));
end
