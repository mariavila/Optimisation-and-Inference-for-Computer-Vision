clearvars;
dst = double(imread('pista_esqi.jpg'));
%hgram = imhist(dst);
src = double(imread('panda_snow.jpg'));
%src = histeq(src, hgram);
%src = imread('paraglider2.jpg'); 
[ni,nj, nChannels]=size(dst);
[niS,njS,nChannelsS] = size(src);

%dst = imresize(dst,[niS njS]);
%src = imresize(src,[ni nj]);


param.hi=1;
param.hj=1;


%masks to exchange
mask_src = imread('panda_snow_mask.jpg');
%mask_src = imread('paraglider_mask2.jpg');
mask_dst = zeros(size(dst(:,:,1)));
[height, width] = size(mask_src);
iniX = 300;
iniY = 198;
%iniX = 1;
%iniY = 1;
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
        
    %Guidance Fields for Seamless Mixing
    if (norm(sol_DiBwd(src(:,:,nC),param.hi))>norm(sol_DiBwd(dst(:,:,nC),param.hi)))
        term1 = sol_DiBwd(src(:,:,nC),param.hi);
    else
        term1 = sol_DiBwd(dst(:,:,nC),param.hi);
    end
    
    if (norm(sol_DiFwd(src(:,:,nC),param.hi))>norm(sol_DiFwd(dst(:,:,nC),param.hi)))
        term2 = sol_DiFwd(src(:,:,nC),param.hi);
    else
        term2 = sol_DiFwd(dst(:,:,nC),param.hi);
    end
    
    if (norm(sol_DjBwd(src(:,:,nC),param.hj))>norm(sol_DjBwd(dst(:,:,nC),param.hj)))
        term3 = sol_DjBwd(src(:,:,nC),param.hj);
    else
        term3 = sol_DjBwd(dst(:,:,nC),param.hj);
    end
    
    if (norm(sol_DjFwd(src(:,:,nC),param.hj))>norm(sol_DjFwd(dst(:,:,nC),param.hj)))
        term4 = sol_DjFwd(src(:,:,nC),param.hj);
    else
        term4 = sol_DjFwd(dst(:,:,nC),param.hj);
    end
    
    guidanceField = + term1 - term2 - term3 + term4;
    
    size(guidanceField)
    size(driving_on_src)
    
    driving_on_src = driving_on_src + guidanceField(1:303,1:637);
    
    driving_on_dst = zeros(size(dst(:,:,1)));
    driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
    
    param.driving = driving_on_dst;
    dst1(:,:,nC) = sol_Poisson_Equation_Axb(dst(:,:,nC), mask_dst,  param);

end

%dst1(mask_dst(:)) = dst1(mask_dst(:))/256;
imshow(dst1/256)
%imshow(dst1)
