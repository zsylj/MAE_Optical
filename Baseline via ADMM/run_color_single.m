clear;clc;
close all;

temp_list=["1011CarNew","1011RunningNew","1012CatNew","1012DophinNew","1012Pica","1012WindmillNew"];
patch_list=[8,12,14,16,24,32];
maskratio_list=[1,3,4,5,6,7];

for i=6:6 %folder
    for j=1:6 %patch
        result=[];
        for k=1:6 %maskratio

            fprintf("patch = %d \t", patch_list(j))
            fprintf("mask_ratio = %.2f \n", maskratio_list(k)/100)

            PSNR_list=[];SSIM_list=[];PSNR0_list=[];SSIM0_list=[];

            %mask
            mask=imread(strcat("Data\",temp_list(i),"\",num2str(patch_list(j)),"\",num2str(k),".png"));
            mask=(mask==255);
            %mask=repmat(mask,[1,1,3]);%Depend on Mask Data

            %original image
            orig_img=double(imread(strcat("Data\",temp_list(i),"\",num2str(patch_list(j)),"\","FixedOrig.png")));
            orig_img=orig_img./255;

            %masked image
            masked_img=double(imread(strcat("Data\",temp_list(i),"\",num2str(patch_list(j)),"\","MaskedImg_",num2str(k),".png")));
            masked_img=masked_img./255;

            [PSNR, SSIM, PSNR0, SSIM0, ~, out_img] = ADMM_Inpainting_color_ATV_single(orig_img, masked_img, mask, 1, 0.001, 1e-3, 99);
            PSNR_list(k,1)=PSNR;SSIM_list(k,1)=SSIM;PSNR0_list(k,1)=PSNR0;SSIM0_list(k,1)=SSIM0;
            fprintf('PSNR= %g \t',PSNR);
            fprintf('SSIM= %g \n',SSIM);
        
            result(:,:,:,k)=out_img;
            
        end
        save(strcat("Result\",temp_list(i),"_",num2str(patch_list(j))),"result")
    end
    
end

