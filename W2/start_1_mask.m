clearvars;
%dst = double(imread('pista_esqi.jpg'));
%src = double(imread('panda_snow.jpg'));
%src = double(imread('snowman.png'));
%dst = double(imread('underwater.png'));
dst = double(imread('mountain.jpg')); 
src = double(imread('paraglider.jpg')); 
[ni,nj, nChannels]=size(dst);

param.hi=1;
param.hj=1;


%masks to exchange
%mask_src = imread('panda_snow_mask.jpg');
mask_src = imread('paraglider_mask.jpg');
%mask_src = imread('snowman_mask.jpg');
mask_dst = zeros(size(dst(:,:,1)));
[height, width] = size(mask_src);
%iniX = 700;
%iniY = 450;
iniX = 150;
iniY = 100;
fiX = iniX + width - 1;
fiY = iniY + height - 1;
mask_dst(iniY:fiY, iniX:fiX) = mask_src;

mask_src = logical(mod(mask_src,2));
mask_dst = logical(mod(mask_dst,2));

for nC = 1: nChannels
    nC
    
    %TO DO: COMPLETE the ??
    drivingGrad_i = - sol_DiFwd(src(:,:,nC), param.hi) + sol_DiBwd(src(:,:,nC),param.hi);
    %TO DO: COMPLETE the ??
    drivingGrad_j = - sol_DjFwd(src(:,:,nC), param.hj) + sol_DjBwd(src(:,:,nC),param.hj);
    
    %TO DO: COMPLETE the ??
    driving_on_src = (drivingGrad_i + drivingGrad_j);
    driving_on_dst = zeros(size(dst(:,:,1)));
    driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
    
    param.driving = driving_on_dst;
    dst1(:,:,nC) = sol_Poisson_Equation_Axb(dst(:,:,nC), mask_dst,  param);

end

%dst1(mask_dst(:)) = dst1(mask_dst(:))/256;
imshow(dst1/256)
%imshow(dst1)

   