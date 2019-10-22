clearvars;
dst = double(imread('pista_esqi.jpg'));
src = double(imread('panda_snow.jpg')); 
[ni,nj, nChannels]=size(dst);

param.hi=1;
param.hj=1;


%masks to exchange
mask_src=logical(imread('panda_snow_mask.jpg'));
mask_dst=logical(imread('pista_esqi_mask.jpg'));

for nC = 1: nChannels
    
    %TO DO: COMPLETE the ??
    drivingGrad_i = - sol_DiFwd(src(:,:,nC), param.hi) + sol_DiBwd(src(:,:,nC),param.hi);
    %TO DO: COMPLETE the ??
    drivingGrad_j = - sol_DjFwd(src(:,:,nC), param.hj) + sol_DjBwd(src(:,:,nC),param.hj);
    
    %TO DO: COMPLETE the ??
    driving_on_src = (drivingGrad_i + drivingGrad_j);
    
    driving_on_dst = zeros(size(src(:,:,1)));  
    driving_on_src_aux = zeros(size(src(:,:,1))); 
    
    driving_on_dst(mask_dst ~= 0) = driving_on_src(mask_src ~= 0);
    aux = dst(:,:,nC);
    aux(mask_dst(:)) = driving_on_src(mask_src(:));
    
    param.driving = driving_on_dst;
    dst1(:,:,nC) = sol_Poisson_Equation_Axb(dst(:,:,nC), mask_dst,  param);

end

imshow(dst1/256)