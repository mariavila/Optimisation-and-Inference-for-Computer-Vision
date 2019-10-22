mask = imread('panda_snow_mask.jpg');
image = imread('pista_esqi.jpg');

mask2 = zeros(size(image(:,:,1)));

[height, width] = size(mask);
iniX = 350;
iniY = 195;
fiX = iniX + width - 1
fiY = iniY + height - 1
mask2(iniY:fiY, iniX:fiX) = mask;

%Change the dimension of the binary mask to match with the original image >>
R = image(:, :, 1); 
%zero will keep the background black. Write 255 if you want it to be white 
R(mask2 ~= 0) = mask(mask ~= 0); 
%imshow(R.*mask2)
imshow(R);

size(mask2)
imwrite(mask2,'pista_esqi_mask.jpg')

