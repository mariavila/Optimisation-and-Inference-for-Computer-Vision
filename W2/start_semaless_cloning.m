clearvars;
dst = double(imread('lena.png'));
src = double(imread('girl.png')); % flipped girl, because of the eyes
[ni,nj, nChannels]=size(dst);

param.hi=1;
param.hj=1;


%masks to exchange: Eyes
mask_src=logical(imread('mask_src_eyes.png'));
mask_dst=logical(imread('mask_dst_eyes.png'));

for nC = 1: nChannels
    %gradient on src
    drivingGrad_i = - sol_DiFwd(src(:,:,nC), param.hi) + sol_DiBwd(src(:,:,nC),param.hi);
    drivingGrad_j = - sol_DjFwd(src(:,:,nC), param.hj) + sol_DjBwd(src(:,:,nC),param.hj);
    driving_on_src = (drivingGrad_i + drivingGrad_j);
    
    %gradient on dst
    drivingGrad_i_dst = - sol_DiFwd(dst(:,:,nC), param.hi) + sol_DiBwd(dst(:,:,nC),param.hi);
    drivingGrad_j_dst = - sol_DjFwd(dst(:,:,nC), param.hj) + sol_DjBwd(dst(:,:,nC),param.hj);
    driving_on_src_dst = (drivingGrad_i_dst + drivingGrad_j_dst);
    
    
    %assign gradient of src
    driving_on_dst = zeros(size(src(:,:,1))); 
    driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));

    %assign gradient of dst for each x where grad_dst(x)>grad_src(x)
    mask = zeros(size(dst(:,:,1)));
    mask(mask_dst(:)) = abs(driving_on_src_dst(mask_dst(:))) > abs(driving_on_src(mask_src(:)));
    %mask(mask_dst(:)) = driving_aux(mask_dst(:));
    mask = logical(mask);
    driving_on_dst(mask(:)) = driving_on_src_dst(mask(:));
    
    %{
    if(abs(driving_on_src_dst(mask_dst(:))) > abs(driving_on_src(mask_src(:))))
        driving_on_dst(mask_dst(:)) = driving_on_src_dst(mask_dst(:));
         
    else
        driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
    end
    %}
    
    param.driving = driving_on_dst;

    dst1(:,:,nC) = sol_Poisson_Equation_Axb(dst(:,:,nC), mask_dst,  param);

end

%Mouth
%masks to exchange: Mouth
mask_src=logical(imread('mask_src_mouth.png'));
mask_dst=logical(imread('mask_dst_mouth.png'));
for nC = 1: nChannels
    
    %TO DO: COMPLETE the ??
    drivingGrad_i = - sol_DiFwd(src(:,:,nC), param.hi) + sol_DiBwd(src(:,:,nC),param.hi);
    %TO DO: COMPLETE the ??
    drivingGrad_j = - sol_DjFwd(src(:,:,nC), param.hj) + sol_DjBwd(src(:,:,nC),param.hj);
    
    %TO DO: COMPLETE the ??
    driving_on_src = (drivingGrad_i + drivingGrad_j);
    
    driving_on_dst = zeros(size(src(:,:,1)));  
    driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
    
    param.driving = driving_on_dst;

    dst1(:,:,nC) = sol_Poisson_Equation_Axb(dst1(:,:,nC), mask_dst,  param);
end

imshow(dst1/256)