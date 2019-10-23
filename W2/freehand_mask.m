%grayImage = imread('panda_snow.jpg');
grayImage = imread('paraglider2.jpg');
imshow(grayImage, []);

% Ask user to draw freehand mask.
message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
uiwait(msgbox(message));
hFH = imfreehand(); % Actual line of code to do the drawing.
% Create a binary image ("mask") from the ROI object.
binaryImage = hFH.createMask();
xy = hFH.getPosition;

% Now make it smaller so we can show more images.
subplot(1, 2, 1);
imshow(grayImage, []);
axis on;
drawnow;
title('Original gray scale image');

% Display the freehand mask.
subplot(1, 2, 2);
imshow(binaryImage);
axis on;
title('Binary mask of the region');

imwrite(binaryImage,'paraglider_mask2.jpg')
%imwrite(binaryImage,'panda_snow_mask.jpg')